local SerikaNum = require(script.Parent);

local OnoeNum = {};
OnoeNum.__index = OnoeNum;

local function fromSerika(mantissa: number, exponent: number): OnoeNum
	return setmetatable({
		mantissa = mantissa,
		exponent = exponent
	}, OnoeNum);
end

local function toSerika(number: Number): (number, number)
	local t = typeof(number);
	if (t == "number") then
		return SerikaNum.new(number);
	elseif (t == "table") then
		return number.mantissa, number.exponent;
	end
	error("Number is not a primitive number, OnoeNum nor BaseOnoeNum.");
end

function OnoeNum.new(number: Number)
	if (typeof(number) == "number") then
		local mantissa, exponent = SerikaNum.new(number);
		return setmetatable({
			mantissa = mantissa,
			exponent = exponent
		}, OnoeNum);
	else
		return setmetatable(number, OnoeNum);
	end
end

function OnoeNum.fromSerika(mantissa: number, exponent: number): OnoeNum
	return fromSerika(SerikaNum.fixMantissa(mantissa, exponent));
end

function OnoeNum.__add(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.add(self.mantissa, self.exponent, mantissa, exponent));
end

function OnoeNum.__sub(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.sub(self.mantissa, self.exponent, mantissa, exponent));
end

function OnoeNum.__mul(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.mul(self.mantissa, self.exponent, mantissa, exponent));
end

function OnoeNum.__div(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.div(self.mantissa, self.exponent, mantissa, exponent));
end

function OnoeNum.__pow(self: OnoeNum, number: Number)
	return fromSerika(SerikaNum.pow(self.mantissa, self.exponent, typeof(number) == "number" and number or OnoeNum.revert(number)));
end

function OnoeNum.__mod(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.mod(self.mantissa, self.exponent, mantissa, exponent));
end

function OnoeNum.__eq(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return SerikaNum.equals(self.mantissa, self.exponent, mantissa, exponent);
end

function OnoeNum.__lt(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return SerikaNum.lessThan(self.mantissa, self.exponent, mantissa, exponent);
end

function OnoeNum.__le(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return SerikaNum.lessEquals(self.mantissa, self.exponent, mantissa, exponent);
end

function OnoeNum.__concat(self: OnoeNum, str: string)
	return self:toString() .. str;
end

function OnoeNum.__tostring(self: OnoeNum)
	return self:toString();
end

function OnoeNum.moreThan(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return SerikaNum.moreThan(self.mantissa, self.exponent, mantissa, exponent);
end

function OnoeNum.moreEquals(self: OnoeNum, number: Number)
	local mantissa, exponent = toSerika(number);
	return SerikaNum.moreEquals(self.mantissa, self.exponent, mantissa, exponent);
end

function OnoeNum.floor(number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.floor(mantissa, exponent));
end

function OnoeNum.round(number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.round(mantissa, exponent));
end

function OnoeNum.ceil(number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.ceil(mantissa, exponent));
end

function OnoeNum.abs(number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.abs(mantissa, exponent));
end

function OnoeNum.unary(number: Number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.unary(mantissa, exponent));
end

function OnoeNum.revert(number: BaseOnoeNum)
	return SerikaNum.revert(number.mantissa, number.exponent);
end

function OnoeNum.log(number: Number, base: number)
	local mantissa, exponent = toSerika(number);
	return fromSerika(SerikaNum.log(mantissa, exponent));
end

function OnoeNum.log10(number: Number)
    return OnoeNum.log(number);
end

function OnoeNum.toString(number: Number, mode: "suffix" | "scientific"?): string
	local mantissa, exponent = toSerika(number);
	return SerikaNum.toString(mantissa, exponent, mode);
end

function OnoeNum.toSuffix(number: Number): string
	local mantissa, exponent = toSerika(number);
	return SerikaNum.toSuffix(mantissa, exponent);
end

function OnoeNum.toScientific(number: Number): string
	local mantissa, exponent = toSerika(number);
	return SerikaNum.toScientific(mantissa, exponent);
end

function OnoeNum.toSingle(number: Number): number
	local mantissa, exponent = toSerika(number);
	return SerikaNum.toSingle(mantissa, exponent);
end

function OnoeNum.fromSingle(single: number): OnoeNum
	local mantissa, exponent = SerikaNum.fromSingle(single);
	return fromSerika(mantissa, exponent);
end

function OnoeNum.max(...: {Number}): OnoeNum
	local numbers = {...};
	local max: OnoeNum? = nil;
	for _, number in numbers do
		local number = OnoeNum.new(number);
		if (max == nil or number:moreThan(max)) then
			max = number;
		end
	end
	return max;
end

function OnoeNum.min(...: {Number}): OnoeNum
	local numbers = {...};
	local max: OnoeNum? = nil;
	for _, number in numbers do
		local number = OnoeNum.new(number);
		if (max == nil or number:lessThan(max)) then
			max = number;
		end
	end
	return max;
end

OnoeNum.add = OnoeNum.__add;
OnoeNum.sub = OnoeNum.__sub;
OnoeNum.mul = OnoeNum.__mul;
OnoeNum.div = OnoeNum.__div;
OnoeNum.pow = OnoeNum.__pow;
OnoeNum.mod = OnoeNum.__mod;
OnoeNum.eq = OnoeNum.__eq;
OnoeNum.equals = OnoeNum.__eq;
OnoeNum.lt = OnoeNum.__lt;
OnoeNum.lessThan = OnoeNum.__lt;
OnoeNum.le = OnoeNum.__le;
OnoeNum.lessEquals = OnoeNum.__le;
OnoeNum.mt = OnoeNum.moreThan;
OnoeNum.me = OnoeNum.moreEquals;
OnoeNum.unm = OnoeNum.unary;

type BaseOnoeNum = {mantissa: number, exponent: number};
type OnoeNum = (typeof (setmetatable({}, OnoeNum))) & BaseOnoeNum;
type Number = number | BaseOnoeNum;

return OnoeNum;