--!optimize 2
--!native

local THRESHOLD = 16
local DECIMAL_POINTS = 2
local DEFAULT_ABBREVIATION: "suffix" | "scientific" = "suffix"
local E = math.exp(1)
local HUGE = math.huge
local suffixes = {
	beginning = { "K", "M", "B" },
	first = { "U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No" },
	second = { "De", "Vt", "Tg", "Qdg", "Qng", "Sxg", "Spg", "Ocg", "Nog" },
	third = { "Ce", "Dce", "Tce", "Qdce", "Qnce", "Sxce", "Spce", "Occe", "Noce" },
}

--- @class Suffixer
--- Small number suffixing library.
local Suffixer = {}

function Suffixer.getSuffix(exponent: number): string?
	if exponent < 3 or exponent > HUGE then
		return nil
	end
	local firstDivisee = math.floor(exponent / 3)
	local final = ""
	if firstDivisee < 4 then
		final = suffixes.beginning[firstDivisee]
	else
		local secondDivisee: number
		local thirdDivisee: number
		if exponent > 302 then
			thirdDivisee = math.floor((exponent - 3) / 300)
			final = suffixes.third[thirdDivisee]
			if final == nil then
				return nil
			end
		end
		if exponent > 32 then
			secondDivisee = math.floor((exponent - 3) / 30)
			if thirdDivisee ~= nil then
				secondDivisee -= thirdDivisee * 10
				firstDivisee -= thirdDivisee * 100
			end
			firstDivisee -= secondDivisee * 10 + 1
			local second = suffixes.second[secondDivisee]
			if second ~= nil then
				final = second .. final
			end
			local first = suffixes.first[firstDivisee]
			if first ~= nil then
				final = first .. final
			end
		else
			final = suffixes.first[firstDivisee - 1]
		end
	end
	return final
end

function Suffixer.getSuffixExponent(suffix: string): number?
	local exponent = 0
	for i, v in suffixes.third do
		local startIndex, endIndex = string.find(suffix, v)
		if startIndex ~= nil then
			exponent += i * 300
			suffix = string.sub(suffix, 1, startIndex - 1)
			break
		end
	end
	local secondPresent = false
	for i, v in suffixes.second do
		local startIndex, endIndex = string.find(suffix, v)
		if startIndex ~= nil then
			exponent += i * 30
			suffix = string.sub(suffix, 1, startIndex - 1)
			secondPresent = true
			break
		end
	end
	for i, v in suffixes.first do
		local startIndex, endIndex = string.find(suffix, v)
		if startIndex ~= nil then
			exponent += i * 3
			suffix = string.sub(suffix, 1, startIndex - 1)
			break
		end
	end
	for i, v in suffixes.beginning do
		local startIndex, endIndex = string.find(suffix, v)
		if startIndex ~= nil then
			exponent += i * 3 - 3
			suffix = string.sub(suffix, 1, startIndex - 1)
			break
		end
	end

	return exponent + 3
end

function Suffixer.changeSuffixes(suffixes: typeof(suffixes))
	suffixes = suffixes
end

--- @class SerikaNum
--- Basic library for performing mathematical operations on numbers exceeding 2^1024.
local SerikaNum = {}

local function fixMantissa(mantissa: number, exponent: number): (number, number)
	if mantissa == 0 then
		return 0, 0
	end
	if exponent % 1 > 0 then
		mantissa *= math.pow(10, exponent % 1)
		exponent = math.floor(exponent)
	end

	local exponentGain = math.floor(math.log10(math.abs(mantissa)))
	return mantissa * math.pow(10, -exponentGain), exponent + exponentGain
end

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
	mantissa2 *= math.pow(10, -exponentDiff)
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
	return fixMantissa(math.pow(mantissa, power), exponent * power)
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
	return exponent1 == exponent2 and math.abs(mantissa1 - mantissa2) < 1e-7
end

function SerikaNum.lessThan(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	local sign1 = math.sign(mantissa1)
    local sign2 = math.sign(mantissa2)
    if sign1 < sign2 then
        return true
    elseif sign1 > sign2 then
        return false
    end

    -- Both numbers have the same sign
    if exponent1 == exponent2 then
		return mantissa1 < mantissa2
	else
		-- For positive numbers: larger exponent means larger number
		-- For negative numbers: larger exponent means smaller number (more negative)
		if sign1 > 0 then
			return exponent1 < exponent2
		else
			return exponent1 > exponent2
		end
	end
end

function SerikaNum.lessEquals(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	local sign1 = math.sign(mantissa1)
    local sign2 = math.sign(mantissa2)
    if sign1 < sign2 then
        return true
    elseif sign1 > sign2 then
        return false
    end

    -- Both numbers have the same sign
    if exponent1 == exponent2 then
		return mantissa1 <= mantissa2
	else
		-- For positive numbers: larger exponent means larger number
		-- For negative numbers: larger exponent means smaller number (more negative)
		if sign1 > 0 then
			return exponent1 <= exponent2
		else
			return exponent1 >= exponent2
		end
	end
end

function SerikaNum.moreThan(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	local sign1 = math.sign(mantissa1)
    local sign2 = math.sign(mantissa2)
    if sign1 < sign2 then
        return false
    elseif sign1 > sign2 then
        return true
    end

    -- Both numbers have the same sign
    if exponent1 == exponent2 then
		return mantissa1 > mantissa2
	else
		-- For positive numbers: larger exponent means larger number
		-- For negative numbers: larger exponent means smaller number (more negative)
		if sign1 > 0 then
			return exponent1 > exponent2
		else
			return exponent1 < exponent2
		end
	end
end

function SerikaNum.moreEquals(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): boolean
	local sign1 = math.sign(mantissa1)
    local sign2 = math.sign(mantissa2)
    if sign1 < sign2 then
        return false
    elseif sign1 > sign2 then
        return true
    end

    -- Both numbers have the same sign
    if exponent1 == exponent2 then
		return mantissa1 >= mantissa2
	else
		-- For positive numbers: larger exponent means larger number
		-- For negative numbers: larger exponent means smaller number (more negative)
		if sign1 > 0 then
			return exponent1 >= exponent2
		else
			return exponent1 <= exponent2
		end
	end
end

function SerikaNum.floor(mantissa: number, exponent: number): (number, number)
	local shift = math.pow(10, -exponent)
	return math.floor(mantissa / shift) * shift, exponent
end

function SerikaNum.round(mantissa: number, exponent: number): (number, number)
    mantissa, exponent = SerikaNum.add(mantissa, exponent, 5, -1)
	return SerikaNum.floor(mantissa, exponent)
end

function SerikaNum.ceil(mantissa: number, exponent: number): (number, number)
	local shift = math.pow(10, -exponent)
	return math.ceil(mantissa / shift) * shift, exponent
end

function SerikaNum.abs(mantissa: number, exponent: number): (number, number)
	return math.abs(mantissa), exponent
end

function SerikaNum.unary(mantissa: number, exponent: number): (number, number)
	return -mantissa, exponent
end

function SerikaNum.revert(mantissa: number, exponent: number): number
	return mantissa * math.pow(10, exponent)
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

function SerikaNum.random(mantissa1: number, exponent1: number, mantissa2: number, exponent2: number): (number, number)
	-- Ensure min <= max
	if SerikaNum.moreThan(mantissa1, exponent1, mantissa2, exponent2) then
		mantissa1, exponent1, mantissa2, exponent2 = mantissa2, exponent2, mantissa1, exponent1
	end
	
	-- Handle zero cases
	if mantissa1 == 0 and mantissa2 == 0 then
		return 0, 0
	end
	
	-- Handle equal cases
	if SerikaNum.equals(mantissa1, exponent1, mantissa2, exponent2) then
		return mantissa1, exponent1
	end
	
	-- If both numbers have the same exponent, interpolate between mantissas
	if exponent1 == exponent2 then
		local randomMantissa = mantissa1 + math.random() * (mantissa2 - mantissa1)
		return fixMantissa(randomMantissa, exponent1)
	end
	
	-- For different exponents, we need to handle the range more carefully
	local exponentDiff = exponent2 - exponent1
	
	-- Check if both numbers have the same sign
	local sign1 = math.sign(mantissa1)
	local sign2 = math.sign(mantissa2)
	
	-- If signs differ, we need to handle crossing zero
	if sign1 ~= sign2 then
		-- Range crosses zero, so we can pick any value in the range
		local minValue = SerikaNum.revert(mantissa1, exponent1)
		local maxValue = SerikaNum.revert(mantissa2, exponent2)
		if math.abs(maxValue - minValue) < 1e15 then -- Stay within safe range
			local randomValue = minValue + math.random() * (maxValue - minValue)
			return SerikaNum.new(randomValue)
		end
	end
	
	-- If the difference is small enough, we can work with the numbers directly
	if exponentDiff <= 15 then -- Stay within double precision range
		local min = SerikaNum.revert(mantissa1, exponent1)
		local max = SerikaNum.revert(mantissa2, exponent2)
		if math.abs(max) < 1e100 and math.abs(min) < 1e100 then -- Additional safety check
			local randomValue = min + math.random() * (max - min)
			return SerikaNum.new(randomValue)
		end
	end
	
	-- For very large ranges with same sign, use the logarithmic approach
	-- But only if both numbers are positive (negative large numbers are trickier)
	if sign1 > 0 and sign2 > 0 then
		-- First decide which "decade" (power of 10) the result should be in
		local randomExponent = math.random(exponent1, exponent2 - 1)
		
		if randomExponent == exponent1 then
			-- If we're in the same exponent as min, start from mantissa1
			local randomMantissa = mantissa1 + math.random() * (10 - mantissa1)
			return fixMantissa(randomMantissa, randomExponent)
		elseif randomExponent == exponent2 - 1 then
			-- If we're one below max exponent, go up to mantissa2/10
			local randomMantissa = 1 + math.random() * (mantissa2 - 1)
			return fixMantissa(randomMantissa, randomExponent)
		else
			-- For middle exponents, use full range [1, 10)
			local randomMantissa = 1 + math.random() * 9
			return fixMantissa(randomMantissa, randomExponent)
		end
	end
	
	-- Fallback: for very large negative numbers or complex cases,
	-- convert to regular numbers if possible
	local min = SerikaNum.revert(mantissa1, exponent1)
	local max = SerikaNum.revert(mantissa2, exponent2)
	local randomValue = min + math.random() * (max - min)
	return SerikaNum.new(randomValue)
end

local function enforceDecimalPoints(mantissa: number, exponent: number)
	if DECIMAL_POINTS <= 0 then
		return tostring(math.round(SerikaNum.revert(mantissa, exponent)))
	else
		local shift = math.pow(10, DECIMAL_POINTS)
		return tostring(math.round(SerikaNum.revert(mantissa, exponent) * shift) / shift)
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
			return SerikaNum.toScientific(mantissa, exponent, false)
		end
		return enforceDecimalPoints(mantissa, exponent % 3) .. suffix
	end
end

function SerikaNum.toScientific(mantissa: number, exponent: number, shorten: boolean?): string
	local shift = math.pow(10, DECIMAL_POINTS)
	if shorten == false then -- idk prevent stack overflow from inf or nan
		return tostring(math.floor(mantissa * shift) / shift) .. "e" .. exponent
	end
	local eMantissa, eExponent = SerikaNum.new(exponent)
	return tostring(math.floor(mantissa * shift) / shift) .. "e" .. SerikaNum.toSuffix(eMantissa, eExponent)
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

function SerikaNum.fromSuffix(str: string): (number, number)
	local suffix = str:match("%a+")
	if suffix == nil then
        local parsed = tonumber(str)
        if parsed == nil then
            return 0, 0
        end
		return SerikaNum.new(parsed)
	end
    local found = string.find(str, suffix)
    if found == nil then
        return 0, 0
    end
	local mantissa = tonumber(string.sub(str, 1, found - 1))
	
	local exponent = Suffixer.getSuffixExponent(suffix)
	if mantissa ~= nil and exponent > 0 then
		return fixMantissa(mantissa, exponent)
	else
		return 0, 0
	end
end

function SerikaNum.fromString(str: string): (number, number)
	local split = string.split(str, "e")
	if #split > 1 and string.len(split[2]) > 0 then
		local mantissa = tonumber(split[1])
		local eMantissa, eExponent = SerikaNum.fromSuffix(split[2])
		return fixMantissa(mantissa, (eMantissa * math.pow(10, eExponent)))
	end
	
	return SerikaNum.fromSuffix(str)
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

--- @class OnoeNum
--- Wrapper library for SerikaNum.
local OnoeNum = {}
OnoeNum.__index = OnoeNum

local function fromSerika(mantissa: number, exponent: number): OnoeNum
	return setmetatable({
		mantissa = mantissa,
		exponent = exponent,
	}, OnoeNum)
end

local function toSerika(number: Number): (number, number)
	local t = typeof(number)
	if t == "number" then
		return SerikaNum.new(number :: number)
	elseif t == "table" then
		return (number :: BaseOnoeNum).mantissa, (number :: BaseOnoeNum).exponent
	end
	error("Number is not a primitive number, OnoeNum nor BaseOnoeNum.")
end

function OnoeNum.new(number: Number)
	if typeof(number) == "number" then
		local mantissa, exponent = SerikaNum.new(number)
		return setmetatable({
			mantissa = mantissa,
			exponent = exponent,
		}, OnoeNum)
	else
		return setmetatable(number, OnoeNum)
	end
end

function OnoeNum.fromSerika(mantissa: number, exponent: number): OnoeNum
	return fromSerika(SerikaNum.fixMantissa(mantissa, exponent))
end

function OnoeNum.__add(self: Number, number: Number): OnoeNum
    local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.add(selfMantissa, selfExponent, mantissa, exponent))
end

function OnoeNum.__sub(self: Number, number: Number): OnoeNum
	local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.sub(selfMantissa, selfExponent, mantissa, exponent))
end

function OnoeNum.__mul(self: Number, number: Number): OnoeNum
	local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.mul(selfMantissa, selfExponent, mantissa, exponent))
end

function OnoeNum.__div(self: Number, number: Number): OnoeNum
	local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.div(selfMantissa, selfExponent, mantissa, exponent))
end

function OnoeNum.__pow(self: Number, number: Number): OnoeNum
	local selfMantissa, selfExponent = toSerika(self)
	return fromSerika(
		SerikaNum.pow(
			selfMantissa,
			selfExponent,
			typeof(number) == "number" and number or OnoeNum.revert(number :: BaseOnoeNum)
		)
	)
end

function OnoeNum.__mod(self: Number, number: Number): OnoeNum
    local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.mod(selfMantissa, selfExponent, mantissa, exponent))
end

function OnoeNum.__eq(self: Number, number: Number): boolean
    local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return SerikaNum.equals(selfMantissa, selfExponent, mantissa, exponent)
end

function OnoeNum.__lt(self: Number, number: Number): boolean
    local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return SerikaNum.lessThan(selfMantissa, selfExponent, mantissa, exponent)
end

function OnoeNum.__le(self: Number, number: Number): boolean
    local selfMantissa, selfExponent = toSerika(self)
	local mantissa, exponent = toSerika(number)
	return SerikaNum.lessEquals(selfMantissa, selfExponent, mantissa, exponent)
end

function OnoeNum.__concat(self: OnoeNum, str: string): string
	return self:toString() .. str
end

function OnoeNum.__tostring(self: OnoeNum): string
	return self:toString()
end

function OnoeNum.moreThan(self: OnoeNum, number: Number): boolean
	local mantissa, exponent = toSerika(number)
	return SerikaNum.moreThan(self.mantissa, self.exponent, mantissa, exponent)
end

function OnoeNum.moreEquals(self: OnoeNum, number: Number): boolean
	local mantissa, exponent = toSerika(number)
	return SerikaNum.moreEquals(self.mantissa, self.exponent, mantissa, exponent)
end

function OnoeNum.floor(number: Number): OnoeNum
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.floor(mantissa, exponent))
end

function OnoeNum.round(number: Number): OnoeNum
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.round(mantissa, exponent))
end

function OnoeNum.ceil(number: Number): OnoeNum
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.ceil(mantissa, exponent))
end

function OnoeNum.abs(number: Number): OnoeNum
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.abs(mantissa, exponent))
end

function OnoeNum.unary(number: Number): OnoeNum
	local mantissa, exponent = toSerika(number)
	return fromSerika(SerikaNum.unary(mantissa, exponent))
end

function OnoeNum.revert(number: BaseOnoeNum): number
	return SerikaNum.revert(number.mantissa, number.exponent)
end

function OnoeNum.log(number: Number, base: number?): OnoeNum?
	local mantissa, exponent = toSerika(number)
	mantissa, exponent = SerikaNum.log(mantissa, exponent, base)
	if mantissa == nil or exponent == nil then
		return nil
	end
	return fromSerika(mantissa, exponent)
end

function OnoeNum.log10(number: Number): OnoeNum?
	return OnoeNum.log(number, 10)
end

function OnoeNum.toString(number: Number, mode: "suffix" | "scientific"?): string
	local mantissa, exponent = toSerika(number)
	return SerikaNum.toString(mantissa, exponent, mode)
end

function OnoeNum.toSuffix(number: Number): string
	local mantissa, exponent = toSerika(number)
	return SerikaNum.toSuffix(mantissa, exponent)
end

function OnoeNum.toScientific(number: Number): string
	local mantissa, exponent = toSerika(number)
	return SerikaNum.toScientific(mantissa, exponent)
end

function OnoeNum.toSingle(number: Number): number
	local mantissa, exponent = toSerika(number)
	return SerikaNum.toSingle(mantissa, exponent)
end

function OnoeNum.fromSingle(single: number): OnoeNum
	local mantissa, exponent = SerikaNum.fromSingle(single)
	return fromSerika(mantissa, exponent)
end

function OnoeNum.fromSuffix(str: string): OnoeNum
	local mantissa, exponent = SerikaNum.fromSuffix(str)
	return fromSerika(mantissa, exponent)
end

function OnoeNum.fromString(str: string): OnoeNum
	local mantissa, exponent = SerikaNum.fromString(str)
	return fromSerika(mantissa, exponent)
end

function OnoeNum.max(...: Number): OnoeNum?
	local numbers = { ... }
	local max: OnoeNum? = nil
	for _, number in numbers do
		local number = OnoeNum.new(number)
		if max == nil or number:moreThan(max) then
			max = number
		end
	end
	return max
end

function OnoeNum.min(...: { Number }): OnoeNum
	local numbers = { ... }
	local max: OnoeNum? = nil
	for _, number in numbers do
		local converted = OnoeNum.new(number)
		if max == nil or converted:lessThan(max) then
			max = converted
		end
	end
	return max :: OnoeNum
end

function OnoeNum.minmax(a: Number, b: Number): (OnoeNum, OnoeNum)
    local numA = OnoeNum.new(a)
    local numB = OnoeNum.new(b)
    if numA:lessThan(numB) then
        return numA, numB
    else
        return numB, numA
    end
end

function OnoeNum.random(min: Number, max: Number): OnoeNum
	local minMantissa, minExponent = toSerika(min)
	local maxMantissa, maxExponent = toSerika(max)
	local mantissa, exponent = SerikaNum.random(minMantissa, minExponent, maxMantissa, maxExponent)
	return fromSerika(mantissa, exponent)
end

OnoeNum.add = OnoeNum.__add
OnoeNum.sub = OnoeNum.__sub
OnoeNum.mul = OnoeNum.__mul
OnoeNum.div = OnoeNum.__div
OnoeNum.pow = OnoeNum.__pow
OnoeNum.mod = OnoeNum.__mod
OnoeNum.eq = OnoeNum.__eq
OnoeNum.equals = OnoeNum.__eq
OnoeNum.lt = OnoeNum.__lt
OnoeNum.lessThan = OnoeNum.__lt
OnoeNum.le = OnoeNum.__le
OnoeNum.lessEquals = OnoeNum.__le
OnoeNum.mt = OnoeNum.moreThan
OnoeNum.me = OnoeNum.moreEquals
OnoeNum.unm = OnoeNum.unary
OnoeNum.__unm = OnoeNum.unary
OnoeNum.toSerika = toSerika
OnoeNum.lbencode = OnoeNum.toSingle
OnoeNum.lbdecode = OnoeNum.fromSingle
SerikaNum.lbencode = SerikaNum.toSingle
SerikaNum.lbdecode = SerikaNum.fromSingle

export type BaseOnoeNum = { mantissa: number, exponent: number }
export type Number = number | BaseOnoeNum
export type OnoeNum = typeof(setmetatable({} :: BaseOnoeNum, OnoeNum))

SerikaNum.Suffixer = Suffixer
SerikaNum.OnoeNum = OnoeNum
SerikaNum.SerikaNum = SerikaNum
SerikaNum.default = SerikaNum -- Hack to make `export = ` and `export default` work equivalently in roblox-ts
return SerikaNum