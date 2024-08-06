--!optimize 2
--!native
--!strict

local Suffixer = require(script.Suffixer)
local THRESHOLD = 16
local DECIMAL_POINTS = 2
local DEFAULT_ABBREVIATION: "suffix" | "scientific" = "suffix"
local E = math.exp(1)

local function fixMantissa(mantissa: number, exponent: number): (number, number)
	if mantissa == 0 then
		return 0, 0
	end
	if exponent % 1 > 0 then
		mantissa *= 10 ^ (exponent % 1)
		exponent = math.floor(exponent)
	end

	local exponentGain = math.floor(math.log10(math.abs(mantissa)))
	return mantissa * (10 ^ -exponentGain), exponent + exponentGain
end

local SerikaNum = {}

function SerikaNum.new(number: number): (number, number)
	if number == 0 then
		return 0, 0
	end
	local exponent = math.floor(math.log10(math.abs(number)))
	return number / (math.pow(10, exponent)), exponent
end

function SerikaNum.add(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	local exponentDiff = exponent1 - exponent2
	if exponentDiff > THRESHOLD or exponentDiff < -THRESHOLD then
		if exponent1 > exponent2 then
			return mantissa1, exponent1
		else
			return mantissa2, exponent2
		end
	end
	mantissa2 *= (10 ^ -exponentDiff)
	return fixMantissa(mantissa1 + mantissa2, exponent1)
end

function SerikaNum.sub(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	return SerikaNum.add(mantissa1, exponent1, -mantissa2, exponent2)
end

function SerikaNum.mul(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	return fixMantissa(mantissa1 * mantissa2, exponent1 + exponent2)
end

function SerikaNum.div(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	return fixMantissa(mantissa1 / mantissa2, exponent1 - exponent2)
end

function SerikaNum.pow(mantissa: number, exponent: number, power: number): (number, number)
	return fixMantissa(mantissa ^ power, exponent * power)
end

function SerikaNum.mod(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	local dividedMantissa, dividedExponent = SerikaNum.div(mantissa1, exponent1, mantissa2, exponent2)
	if math.sign(mantissa1) == 1 then
		dividedMantissa, dividedExponent = SerikaNum.floor(dividedMantissa, dividedExponent)
	else
		dividedMantissa, dividedExponent = SerikaNum.round(dividedMantissa, dividedExponent)
	end
	return SerikaNum.sub(mantissa1, exponent1, SerikaNum.mul(mantissa2, exponent2, dividedMantissa, dividedExponent))
end

function SerikaNum.equals(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	return mantissa1 == mantissa2 and exponent1 == exponent2
end

function SerikaNum.lessThan(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	if exponent1 == exponent2 then
		return mantissa1 < mantissa2
	else
		return math.sign(mantissa1) * math.abs(exponent1) < math.sign(mantissa2) * math.abs(exponent2)
	end
end

function SerikaNum.lessEquals(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	if exponent1 == exponent2 then
		return mantissa1 <= mantissa2
	else
		return math.sign(mantissa1) * math.abs(exponent1) < math.sign(mantissa2) * math.abs(exponent2)
	end
end

function SerikaNum.moreThan(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	if exponent1 == exponent2 then
		return mantissa1 > mantissa2
	else
		return math.sign(mantissa1) * math.abs(exponent1) > math.sign(mantissa2) * math.abs(exponent2)
	end
end

function SerikaNum.moreEquals(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	if exponent1 == exponent2 then
		return mantissa1 >= mantissa2
	else
		return math.sign(mantissa1) * math.abs(exponent1) > math.sign(mantissa2) * math.abs(exponent2)
	end
end

function SerikaNum.floor(mantissa: number, exponent: number): (number, number)
	local shift = 10 ^ -exponent
	return math.floor(mantissa / shift) * shift, exponent
end

function SerikaNum.round(mantissa: number, exponent: number): (number, number)
	return SerikaNum.floor(SerikaNum.add(mantissa, exponent, 5, -1))
end

function SerikaNum.ceil(mantissa: number, exponent: number): (number, number)
	local shift = 10 ^ -exponent
	return math.ceil(mantissa / shift) * shift, exponent
end

function SerikaNum.abs(mantissa: number, exponent: number): (number, number)
	return math.abs(mantissa), exponent
end

function SerikaNum.unary(mantissa: number, exponent: number): (number, number)
	return -mantissa, exponent
end

function SerikaNum.revert(mantissa: number, exponent: number): number
	return mantissa * 10 ^ exponent
end

function SerikaNum.log(mantissa: number, exponent: number, base: number?): (number?, number?)
	if mantissa < 0 then
		return nil
	elseif base == nil then
		base = E
	end
	return SerikaNum.new(math.log(mantissa, base) + exponent * math.log(10, base))
end

function SerikaNum.log10(mantissa: number, exponent: number): (number?, number?)
	return SerikaNum.log(mantissa, exponent, 10)
end

local function enforceDecimalPoints(mantissa: number, exponent: number)
	if DECIMAL_POINTS <= 0 then
		return tostring(math.floor(SerikaNum.revert(mantissa, exponent)))
	else
		local shift = 10 ^ DECIMAL_POINTS
		return tostring(math.floor(SerikaNum.revert(mantissa, exponent) * shift) / shift)
	end
end

function SerikaNum.toString(mantissa: number, exponent: number, mode: "suffix" | "scientific"?): string
	if mode == nil then
		mode = DEFAULT_ABBREVIATION
	end
	if mode == "suffix" then
		return SerikaNum.toSuffix(mantissa, exponent)
	elseif mode == "scientific" then
		return SerikaNum.toScientific(mantissa, exponent)
	end
	error("Please enter a valid mode 'suffix' or 'scientific'. Given: " .. tostring(mode))
end

function SerikaNum.toSuffix(mantissa: number, exponent: number): string
	if exponent < 3 then
		return enforceDecimalPoints(mantissa, exponent)
	else
		local suffix = Suffixer.getSuffix(exponent)
		if suffix == nil then
			return SerikaNum.toScientific(mantissa, exponent)
		end
		return enforceDecimalPoints(mantissa, exponent % 3) .. suffix
	end
end

function SerikaNum.toScientific(mantissa: number, exponent: number): string
	local shift = 10 ^ DECIMAL_POINTS
	return tostring(math.floor(mantissa * shift) / shift) .. "e+" .. exponent
end

function SerikaNum.toSingle(mantissa: number, exponent: number): number
	return math.floor((tonumber(tostring(exponent) .. "." .. tostring(mantissa):gsub("%.", ""):sub(1, 5)) or 0) * 10000)
end

function SerikaNum.fromSingle(single: number): (number, number)
	single /= 10000
	local split = string.split(tostring(single), ".")
	local exponent, mantissa = split[1], split[2]
	if mantissa == nil then
		return 0, 0
	end
	local wholeMantissa = mantissa:sub(1, 1)
	local decimalMantissa = mantissa:sub(2)
	return tonumber(wholeMantissa .. "." .. decimalMantissa) or 0, tonumber(exponent) or 0
end

function SerikaNum.changeThreshold(threshold: number)
	THRESHOLD = threshold
end

function SerikaNum.changeDecimalPoints(decimalPoints: number)
	DECIMAL_POINTS = decimalPoints
end

function SerikaNum.changeDefaultAbbreviation(mode: "suffix" | "scientific")
	DEFAULT_ABBREVIATION = mode
end

SerikaNum.eq = SerikaNum.equals
SerikaNum.lt = SerikaNum.lessThan
SerikaNum.le = SerikaNum.lessEquals
SerikaNum.mt = SerikaNum.moreThan
SerikaNum.me = SerikaNum.moreEquals
SerikaNum.unm = SerikaNum.unary
SerikaNum.fixMantissa = fixMantissa -- exported utility function

return SerikaNum
