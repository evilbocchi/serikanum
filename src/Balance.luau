--!native
--!optimize 2

local SerikaNum = require(script.Parent)
local OnoeNum = SerikaNum.OnoeNum

local ZERO = OnoeNum.new(0) -- utility

--- @class Balance
--- A class used to perform calculations on multiple currencies at once.
--- Note that all Balance objects are immutable when using its builtin methods. Balance.amountPerCurrency is mutable, however.
local Balance = {}
Balance.__index = Balance

--- Create a new Balance object.
--- @param amountPerCurrency -- Default amount of currencies in the balance
--- @param clone -- Optional parameter, indicating whether or not to clone amountPerCurrency. Default is true.
function Balance.new(amountPerCurrency: {[string]: SerikaNum.Number}?, clone: boolean?): Balance
	local newAmountPerCurrency: {[string]: SerikaNum.OnoeNum};
	if (amountPerCurrency ~= nil) then
		if (clone == false) then
			newAmountPerCurrency = amountPerCurrency
		else
			newAmountPerCurrency = {}
		end
		for currency, amount in pairs(newAmountPerCurrency) do
			newAmountPerCurrency[currency] = OnoeNum.new(amount)
		end
	else
		newAmountPerCurrency = {}
	end
	
	return setmetatable({
		amountPerCurrency = newAmountPerCurrency
	}, Balance)
end

--- Get the amount of the currency specified in the Balance object.
--- @param currency -- Currency to get amount of
function Balance.get(self: Balance, currency: string): SerikaNum.OnoeNum
	return self.amountPerCurrency[currency] or ZERO
end

--- Sets the amount of the currency specified in the Balance object.
--- @param currency -- Currency to get amount of
function Balance.set(self: Balance, currency: string, amount: (SerikaNum.OnoeNum | number)?): Balance
	if (amount == nil) then
		self.amountPerCurrency[currency] = nil
		return self
	end
	self.amountPerCurrency[currency] = OnoeNum.new(amount)
	return self
end

function Balance.add(self: Balance, value: Balance)
	local newBalance = Balance.new()
	for currency, amount in pairs(self.amountPerCurrency) do
		newBalance.amountPerCurrency[currency] = OnoeNum.new(amount)
	end
	for currency, amount in pairs(value.amountPerCurrency) do
		local currentAmount = newBalance.amountPerCurrency[currency]
		newBalance.amountPerCurrency[currency] = currentAmount == nil and amount or OnoeNum.add(currentAmount, amount)
	end
	return newBalance
end

function Balance.sub(self: Balance, value: Balance)
	local newBalance = Balance.new()
	for currency, amount in pairs(self.amountPerCurrency) do
		newBalance.amountPerCurrency[currency] = OnoeNum.new(amount)
	end
	for currency, amount in pairs(value.amountPerCurrency) do
		local currentAmount = newBalance.amountPerCurrency[currency]
		newBalance.amountPerCurrency[currency] = currentAmount == nil and amount:unary() or OnoeNum.sub(currentAmount, amount)
	end
	return newBalance
end

function Balance.mul(self: Balance, value: Balance | number)
	local constant = typeof(value) == "number" and OnoeNum.new(value) or nil
	local newBalance = Balance.new()
	for currency, amount in pairs(self.amountPerCurrency) do
		local value = constant or (value :: Balance).amountPerCurrency[currency]
		newBalance.amountPerCurrency[currency] = value == nil and amount or amount:mul(value)
	end
	return newBalance
end

function Balance.pow(self: Balance, value: Balance | number)
	local constant = typeof(value) == "number" and OnoeNum.new(value) or nil
	local newBalance = Balance.new()
	for currency, amount in pairs(self.amountPerCurrency) do
		local value = constant or (value :: Balance).amountPerCurrency[currency]
		newBalance.amountPerCurrency[currency] = value == nil and amount or amount:pow(value)
	end
	return newBalance
end

function Balance.canAfford(self: Balance, value: Balance)
	local remainingPerCurrency = {}
	local result = true
	for currency, amount in pairs(self.amountPerCurrency) do
		local other = value.amountPerCurrency[currency]
		if other ~= nil then
			local remaining = amount:sub(other)
			remainingPerCurrency[currency] = remaining
			if remaining.sign == -1 then
				result = false
			end
		end
	end
	
	return result, remainingPerCurrency
end

Balance.__add = Balance.add
Balance.__sub = Balance.sub
Balance.__mul = Balance.mul

export type Balance = typeof(setmetatable({} :: { amountPerCurrency: {[string]: SerikaNum.OnoeNum} }, Balance))

return Balance
