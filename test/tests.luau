--!nocheck
local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local bytecode = luau.compile(fs.readFile("src/init.luau"))
local SerikaNum = luau.load(bytecode)()
local OnoeNum = SerikaNum.OnoeNum

--- Test runner

local tests = {}

function addTest(name, fn)
	table.insert(tests, { name = name, fn = fn })
end

function assertEqual(actual, expected, msg)
	if actual ~= expected then
		error(msg or ("Expected " .. tostring(expected) .. ", got " .. tostring(actual)), 2)
	end
end

function assertClose(actual, expected, epsilon, msg)
	epsilon = epsilon or 1e-9
	if math.abs(actual - expected) >= epsilon then
		error(
			(msg or "")
				.. " Expected "
				.. tostring(actual)
				.. " ≈ "
				.. tostring(expected)
				.. " (epsilon="
				.. tostring(epsilon)
				.. ")",
			2
		)
	end
end

function assertEquals(actual, expected, msg)
	if not actual:equals(expected) then
		print(actual.mantissa, actual.exponent, expected.mantissa, expected.exponent)
		error((msg or "") .. " Expected " .. expected:toString() .. ", got " .. actual:toString(), 2)
	end
end

function assertMoreThan(actual, expected, msg)
	if not actual:moreThan(expected) then
		error((msg or "") .. " Expected " .. actual:toString() .. " > " .. expected:toString(), 2)
	end
end

function assertLessThan(actual, expected, msg)
	if not actual:lessThan(expected) then
		error((msg or "") .. " Expected " .. actual:toString() .. " < " .. expected:toString(), 2)
	end
end

function assertMoreEquals(actual, expected, msg)
	if not actual:moreEquals(expected) then
		error((msg or "") .. " Expected " .. actual:toString() .. " >= " .. expected:toString(), 2)
	end
end

function assertLessEquals(actual, expected, msg)
	if not actual:lessEquals(expected) then
		error((msg or "") .. " Expected " .. actual:toString() .. " <= " .. expected:toString(), 2)
	end
end

function runTests()
	local passed, failed = 0, 0
	for _, test in ipairs(tests) do
		local ok, err = pcall(test.fn)
		if ok then
			print("[PASS]", test.name)
			passed += 1
		else
			print("[FAIL]", test.name, err)
			failed += 1
		end
	end
	print("Tests finished. Passed:", passed, "Failed:", failed)
	if failed > 0 then
		process.exit(1)
	else
		process.exit(0)
	end
end

--- Construction

addTest("fromNumber: creates from number", function()
	local num = OnoeNum.new(5)
	assertEqual(num:revert(), 5)
end)

addTest("fromNumber: creates from negative number", function()
	local num = OnoeNum.new(-10)
	assertEqual(num:revert(), -10)
end)

addTest("fromString: creates from string", function()
	local num = OnoeNum.fromString("12345")
	assertEqual(num:revert(), 12345)
end)

addTest("fromString: handles negative strings", function()
	local num = OnoeNum.fromString("-67890")
	assertEqual(num:revert(), -67890)
end)

addTest("fromString: handles zero string", function()
	local num = OnoeNum.fromString("0")
	assertEqual(num:revert(), 0)
end)

addTest("scientificNotation: parses scientific notation", function()
	local num = OnoeNum.fromString("1.23e5")
	assertClose(num:revert(), 123000)
end)

addTest("scientificNotation: handles negative signs in strings", function()
	local num = OnoeNum.fromString("-5.678")
	assertClose(num:revert(), -5.678)
end)

addTest("scientificNotation: handles scientific notation in various formats", function()
	local cases = {
		{ input = "1.23e+45", expected = 1.23e45 },
		{ input = "1.23e-5", expected = 1.23e-5 },
		{ input = "1e10", expected = 1e10 },
	}
	for _, case in ipairs(cases) do
		local num = OnoeNum.fromString(case.input)
		assertClose(num:revert() / case.expected, 1)
	end
end)

--- Arithmetic

addTest("add: simple addition", function()
	local a = OnoeNum.new(2)
	local b = OnoeNum.new(3)
	assertEqual((a + b):revert(), 5)
end)

addTest("sub: simple subtraction", function()
	local a = OnoeNum.new(10)
	local b = OnoeNum.new(4)
	assertEqual((a - b):revert(), 6)
end)

addTest("mul: simple multiplication", function()
	local a = OnoeNum.new(7)
	local b = OnoeNum.new(6)
	assertEqual((a * b):revert(), 42)
end)

addTest("div: simple division", function()
	local a = OnoeNum.new(20)
	local b = OnoeNum.new(5)
	assertEqual((a / b):revert(), 4)
end)

addTest("pow: simple power", function()
	local a = OnoeNum.new(2)
	local b = OnoeNum.new(8)
	assertEqual((a ^ b):revert(), 256)
end)

addTest("mod: simple modulo", function()
	local a = OnoeNum.new(17)
	local b = OnoeNum.new(5)
	assertClose((a % b):revert(), 2, 1e-9)
end)

addTest("unary minus", function()
	local a = OnoeNum.new(9)
	assertClose((-a):revert(), -9, 1e-9)
end)

addTest("reciprocal", function()
	local a = OnoeNum.new(4)
	assertClose((1 / a):revert(), 0.25)
end)

addTest("reciprocal: using reciprocal method", function()
	local a = OnoeNum.new(4)
	local result = OnoeNum.reciprocal(a)
	assertClose(result:revert(), 0.25, 1e-9, "reciprocal of 4 should be 0.25")
end)

addTest("reciprocal: large number", function()
	local a = OnoeNum.new(1e6)
	local result = OnoeNum.reciprocal(a)
	assertClose(result:revert(), 1e-6, 1e-15, "reciprocal of 1e6 should be 1e-6")
end)

addTest("reciprocal: small number", function()
	local a = OnoeNum.new(0.01)
	local result = OnoeNum.reciprocal(a)
	assertClose(result:revert(), 100, 1e-9, "reciprocal of 0.01 should be 100")
end)

addTest("reciprocal: negative number", function()
	local a = OnoeNum.new(-5)
	local result = OnoeNum.reciprocal(a)
	assertClose(result:revert(), -0.2, 1e-9, "reciprocal of -5 should be -0.2")
end)

addTest("reciprocal: very large number", function()
	local a = OnoeNum.fromString("1e100")
	local result = OnoeNum.reciprocal(a)
	local expected = OnoeNum.fromString("1e-100")
	assertEquals(result, expected, "reciprocal of 1e100 should be 1e-100")
end)

addTest("reciprocal: double reciprocal equals original", function()
	local a = OnoeNum.new(42)
	local result = OnoeNum.reciprocal(OnoeNum.reciprocal(a))
	assertEquals(result, a, "reciprocal of reciprocal should equal original")
end)

addTest("reciprocal: multiplication by reciprocal equals 1", function()
	local a = OnoeNum.new(7)
	local recip = OnoeNum.reciprocal(a)
	local result = a:mul(recip)
	assertClose(result:revert(), 1, 1e-9, "number times its reciprocal should equal 1")
end)

addTest("root: square root", function()
	local a = OnoeNum.new(16)
	local result = OnoeNum.root(a, 2)
	assertClose(result:revert(), 4, 1e-9, "square root of 16 should be 4")
end)

addTest("root: cube root", function()
	local a = OnoeNum.new(27)
	local result = OnoeNum.root(a, 3)
	assertClose(result:revert(), 3, 1e-9, "cube root of 27 should be 3")
end)

addTest("root: fourth root", function()
	local a = OnoeNum.new(81)
	local result = OnoeNum.root(a, 4)
	assertClose(result:revert(), 3, 1e-9, "fourth root of 81 should be 3")
end)

addTest("root: square root of large number", function()
	local a = OnoeNum.new(1e10)
	local result = OnoeNum.root(a, 2)
	assertClose(result:revert(), 1e5, 1e-4, "square root of 1e10 should be 1e5")
end)

addTest("root: cube root of very large number", function()
	local a = OnoeNum.fromString("1e300")
	local result = OnoeNum.root(a, 3)
	local expected = OnoeNum.fromString("1e100")
	assertEquals(result, expected, "cube root of 1e300 should be 1e100")
end)

addTest("root: root then power equals original", function()
	local a = OnoeNum.new(64)
	local root_val = 3
	local result = OnoeNum.root(a, root_val):pow(root_val)
	assertClose(result:revert(), a:revert(), 1e-9, "taking root then raising to that power should equal original")
end)

addTest("root: power then root equals original", function()
	local a = OnoeNum.new(5)
	local power_val = 4
	local result = a:pow(power_val):root(power_val)
	assertClose(result:revert(), a:revert(), 1e-9, "raising to power then taking that root should equal original")
end)

addTest("root: square root of 2", function()
	local a = OnoeNum.new(2)
	local result = OnoeNum.root(a, 2)
	assertClose(result:revert(), math.sqrt(2), 1e-9, "square root of 2 should match math.sqrt(2)")
end)

addTest("root: root of 1 is 1", function()
	local a = OnoeNum.new(1)
	local result = OnoeNum.root(a, 5)
	assertClose(result:revert(), 1, 1e-9, "any root of 1 should be 1")
end)

addTest("root: relationship with pow", function()
	local a = OnoeNum.new(8)
	local root_result = OnoeNum.root(a, 3)
	local pow_result = a:pow(1 / 3)
	assertClose(root_result:revert(), pow_result:revert(), 1e-9, "root(x, n) should equal pow(x, 1/n)")
end)

addTest("root: negative base with odd root", function()
	-- Note: This might not work perfectly with floating point, but we can test the concept
	local a = OnoeNum.new(-8)
	local result = OnoeNum.root(a, 3)
	-- cube root of -8 should be -2
	assertClose(result:revert(), -2, 1e-9, "cube root of -8 should be -2")
end)

addTest("root: fractional results", function()
	local a = OnoeNum.new(10)
	local result = OnoeNum.root(a, 2)
	assertClose(result:revert(), math.sqrt(10), 1e-9, "square root of 10 should be approximately 3.162")
end)

--- Comparison

addTest("equals: equal numbers", function()
	local a = OnoeNum.new(123)
	local b = OnoeNum.new(123)
	assert(a:eq(b))
end)

addTest("lessThan: true", function()
	local a = OnoeNum.new(1)
	local b = OnoeNum.new(2)
	assert(a:lt(b))
end)

addTest("moreThan: true", function()
	local a = OnoeNum.new(5)
	local b = OnoeNum.new(3)
	assert(a:mt(b))
end)

addTest("lessEquals: equal", function()
	local a = OnoeNum.new(7)
	local b = OnoeNum.new(7)
	assert(a:le(b))
end)

addTest("moreEquals: equal", function()
	local a = OnoeNum.new(8)
	local b = OnoeNum.new(8)
	assert(a:me(b))
end)

--- String conversion

addTest("toString: small number", function()
	local a = OnoeNum.new(42)
	assertEqual(a:toString(), "42")
end)

addTest("toString: negative number", function()
	local a = OnoeNum.new(-123)
	assertEqual(a:toString(), "-123")
end)

addTest("toSuffix: large number", function()
	local a = OnoeNum.new(1e6)
	assert(a:toSuffix():find("M"))
end)

addTest("toScientific: large number", function()
	local a = OnoeNum.new(1e12)
	assert(a:toScientific():find("e"))
end)

--- Edge cases

addTest("zero: addition", function()
	local a = OnoeNum.new(0)
	local b = OnoeNum.new(5)
	assertEqual((a + b):revert(), 5)
end)

addTest("zero: multiplication", function()
	local a = OnoeNum.new(0)
	local b = OnoeNum.new(123)
	assertEqual((a * b):revert(), 0)
end)

addTest("negative: multiplication", function()
	local a = OnoeNum.new(-3)
	local b = OnoeNum.new(7)
	assertEqual((a * b):revert(), -21)
end)

addTest("negative: division", function()
	local a = OnoeNum.new(-12)
	local b = OnoeNum.new(3)
	assertClose((a / b):revert(), -4, 1e-9)
end)

addTest("pow: negative exponent", function()
	local a = OnoeNum.new(2)
	local b = OnoeNum.new(-3)
	assertClose((a ^ b):revert(), 0.125)
end)

addTest("pow: (-8)^(1/3)", function()
	local a = OnoeNum.new(-8)
	local b = OnoeNum.new(1 / 3)
	assertClose((a ^ b):revert(), -2, 1e-9)
end)

addTest("fromString: suffix", function()
	local num = OnoeNum.fromString("1M")
	assertEqual(num:revert(), 1e6)
end)

addTest("fromString: scientific", function()
	local num = OnoeNum.fromString("2.5e3")
	assertClose(num:revert(), 2500)
end)

addTest("fromString: negative scientific", function()
	local num = OnoeNum.fromString("-1.2e2")
	assertClose(num:revert(), -120)
end)

addTest("fromString: zero", function()
	local num = OnoeNum.fromString("0")
	assertEqual(num:revert(), 0)
end)

addTest("fromString: fallback", function()
	local num = OnoeNum.fromString("999")
	assertEqual(num:revert(), 999)
end)

--- Mathematical Properties Tests

-- Identity Tests
addTest("identity: additive identity", function()
	local a = OnoeNum.new(42)
	local zero = OnoeNum.new(0)
	assertEquals(a:add(zero), a, "a + 0 should equal a")
	assertEquals(zero:add(a), a, "0 + a should equal a")
end)

addTest("identity: multiplicative identity", function()
	local a = OnoeNum.new(42)
	local one = OnoeNum.new(1)
	assertEquals(a:mul(one), a, "a * 1 should equal a")
	assertEquals(one:mul(a), a, "1 * a should equal a")
end)

addTest("identity: exponentiation identity", function()
	local a = OnoeNum.new(42)
	local one = OnoeNum.new(1)
	local zero = OnoeNum.new(0)
	assertEquals(a:pow(one), a, "a^1 should equal a")
	assertEquals(a:pow(zero), one, "a^0 should equal 1")
end)

-- Commutativity Tests
addTest("commutativity: addition", function()
	local a = OnoeNum.new(13)
	local b = OnoeNum.new(27)
	assertEquals(a:add(b), b:add(a), "a + b should equal b + a")
end)

addTest("commutativity: multiplication", function()
	local a = OnoeNum.new(7)
	local b = OnoeNum.new(11)
	assertEquals(a:mul(b), b:mul(a), "a * b should equal b * a")
end)

addTest("commutativity: large numbers", function()
	local a = OnoeNum.new(1e100)
	local b = OnoeNum.new(1e150)
	assertEquals(a:add(b), b:add(a), "large a + b should equal b + a")
	assertEquals(a:mul(b), b:mul(a), "large a * b should equal b * a")
end)

-- Associativity Tests
addTest("associativity: addition", function()
	local a = OnoeNum.new(5)
	local b = OnoeNum.new(8)
	local c = OnoeNum.new(12)
	local left = a:add(b):add(c)
	local right = a:add(b:add(c))
	assertEquals(left, right, "(a + b) + c should equal a + (b + c)")
end)

addTest("associativity: multiplication", function()
	local a = OnoeNum.new(3)
	local b = OnoeNum.new(4)
	local c = OnoeNum.new(5)
	local left = a:mul(b):mul(c)
	local right = a:mul(b:mul(c))
	assertEquals(left, right, "(a * b) * c should equal a * (b * c)")
end)

-- Distributivity Tests
addTest("distributivity: multiplication over addition", function()
	local a = OnoeNum.new(3)
	local b = OnoeNum.new(5)
	local c = OnoeNum.new(7)
	local left = a:mul(b:add(c))
	local right = a:mul(b):add(a:mul(c))
	assertEquals(left, right, "a * (b + c) should equal (a * b) + (a * c)")
end)

-- Inverse Operation Tests
addTest("inverse: addition and subtraction", function()
	local a = OnoeNum.new(42)
	local b = OnoeNum.new(17)
	local result = a:add(b):sub(b)
	assertEquals(result, a, "(a + b) - b should equal a")
end)

addTest("inverse: multiplication and division", function()
	local a = OnoeNum.new(84)
	local b = OnoeNum.new(7)
	local result = a:mul(b):div(b)
	assertEquals(result, a, "(a * b) / b should equal a")
end)

addTest("inverse: power and root", function()
	local a = OnoeNum.new(8)
	local b = OnoeNum.new(3)
	local result = a:pow(b):pow(1 / b)
	assertClose(result:revert(), a:revert(), 1e-10, "a^b root b should equal a")
end)

--- Large Number Tests

addTest("large: basic operations with googol", function()
	local googol = OnoeNum.new(10):pow(OnoeNum.new(100))
	local two = OnoeNum.new(2)

	-- Test basic operations
	local doubled = googol:mul(two)
	local halved = doubled:div(two)
	assertEquals(halved, googol, "Large number multiplication/division should be reversible")
end)

addTest("large: extreme numbers within safe limit", function()
	-- Test numbers approaching the safe limits mentioned in the code
	local large_exp = OnoeNum.new({ mantissa = 1, exponent = 100 })
	local larger_exp = OnoeNum.new({ mantissa = 1, exponent = 101 })

	-- Test basic operations
	assertMoreThan(larger_exp, large_exp, "Larger exponent number should be greater")

	local sum = large_exp:add(larger_exp)
	assertMoreThan(sum, larger_exp, "Sum should be greater than either addend")
end)

addTest("large: operations with scientific notation", function()
	local huge1 = OnoeNum.fromString("1e1000")
	local huge2 = OnoeNum.fromString("2e1000")

	-- Test that operations work with very large numbers
	local sum = huge1:add(huge2)
	assertMoreThan(sum, huge2, "Sum of huge numbers should be larger")

	local product = huge1:mul(huge2)
	assertMoreThan(product, sum, "Product should be much larger than sum")
end)

addTest("large: numbers approaching ee308 limit", function()
	-- Test numbers with significant hyperoperation levels but within safe bounds
	local near_limit1 = OnoeNum.new({ mantissa = 1, exponent = 1e15 })

	local near_limit2 = OnoeNum.new({ mantissa = 1, exponent = 1e40 })

	-- Test basic operations work
	local doubled = near_limit1:mul(near_limit2)
	assertMoreEquals(doubled, near_limit2, "Operations should work on extreme numbers")

	-- Test string conversion works
	local str = near_limit1:toString()
	assert(type(str) == "string" and #str > 0, "Should convert to string")
end)

addTest("large: 2^5000", function()
	local two = OnoeNum.new(2)
	local exp = OnoeNum.new(5000)
	local result = two:pow(exp)

	-- Test that the result is greater than 1e1500
	local threshold = OnoeNum.fromString("1e1500")
	assertMoreThan(result, threshold, "2^5000 should be greater than 1e1500")
end)

--- Edge Cases and Boundary Conditions

addTest("edge: zero in various operations", function()
	local zero = OnoeNum.new(0)
	local nonzero = OnoeNum.new(42)

	-- Test zero behavior
	assertEquals(zero:mul(nonzero), zero, "0 * a should equal 0")
	assertEquals(zero:pow(nonzero), zero, "0^a should equal 0 (for positive a)")
	assertEquals(nonzero:pow(zero), OnoeNum.new(1), "a^0 should equal 1")
end)

addTest("edge: negative numbers", function()
	local neg = OnoeNum.new(-5)
	local pos = OnoeNum.new(3)

	-- Test negative number operations
	local sum = neg:add(pos)
	assertEqual(sum:revert(), -2)

	local product = neg:mul(pos)
	assertEqual(product:revert(), -15)

	-- Test absolute value
	assertEquals(neg:abs(), OnoeNum.new(5), "abs(-5) should equal 5")
end)

addTest("edge: very small numbers", function()
	local tiny = OnoeNum.new(1e-100)
	local small = OnoeNum.new(1e-50)

	-- Test operations with very small numbers
	local sum = tiny:add(small)
	assertMoreEquals(sum, small, "Sum should be dominated by larger number")

	local product = tiny:mul(small)
	assertLessThan(product, tiny, "Product should be smaller")
end)

addTest("edge: comparison edge cases", function()
	local a = OnoeNum.new(1)
	local b = OnoeNum.new(1)
	local c = OnoeNum.new(2)

	-- Test equality and comparison
	assertEquals(a, b, "Equal numbers should be equal")
	assert(not a:equals(c), "Different numbers should not be equal")
	assertLessThan(a, c, "1 should be less than 2")
	assertMoreThan(c, a, "2 should be greater than 1")
	assertLessEquals(a, b, "Equal numbers satisfy <=")
	assertMoreEquals(a, b, "Equal numbers satisfy >=")
end)

addTest("edge: string parsing edge cases", function()
	-- Test various string formats
	local cases = {
		"0",
		"1",
		"-1",
		"123.456",
		"-123.456",
		"1e5",
		"-1e5",
		"1.5e10",
		"-2.3e-5",
	}

	for _, case in ipairs(cases) do
		local num = OnoeNum.fromString(case)
		assert(num ~= nil, "Should parse string: " .. case)
		local expected = tonumber(case)
		if expected and math.abs(expected) < 1e308 then
			assertClose(num:revert(), expected, 1e-5, "Parsed value should match for: " .. case)
		end
	end
end)

addTest("edge: min/max operations", function()
	local a = OnoeNum.new(5)
	local b = OnoeNum.new(10)

	assertEquals(a:min(b), a, "min(5,10) should equal 5")
	assertEquals(a:max(b), b, "max(5,10) should equal 10")

	local min_val, max_val = a:minmax(b)
	assertEquals(min_val, a, "minmax should return min first")
	assertEquals(max_val, b, "minmax should return max second")
end)

--- Random Number Generation Tests

addTest("random: basic range", function()
	local min_val = OnoeNum.new(5)
	local max_val = OnoeNum.new(10)

	for i = 1, 10 do
		local random_val = OnoeNum.random(min_val, max_val)
		assertMoreEquals(random_val, min_val, "Random value should be >= min")
		assertLessEquals(random_val, max_val, "Random value should be <= max")
	end
end)

addTest("random: swapped parameters", function()
	local min_val = OnoeNum.new(5)
	local max_val = OnoeNum.new(10)

	-- Test with swapped parameters - should auto-correct
	local random_val = OnoeNum.random(max_val, min_val)
	assertMoreEquals(random_val, min_val, "Random value should be >= min (auto-swapped)")
	assertLessEquals(random_val, max_val, "Random value should be <= max (auto-swapped)")
end)

addTest("random: large numbers same exponent", function()
	local min_val = OnoeNum.new(1e15)
	local max_val = OnoeNum.new(9e15)

	for i = 1, 5 do
		local random_val = OnoeNum.random(min_val, max_val)
		assertMoreEquals(random_val, min_val, "Large random value should be >= min")
		assertLessEquals(random_val, max_val, "Large random value should be <= max")
	end
end)

addTest("random: very large numbers different exponents", function()
	local min_val = OnoeNum.fromString("1e100")
	local max_val = OnoeNum.fromString("1e200")

	for i = 1, 5 do
		local random_val = OnoeNum.random(min_val, max_val)
		assertMoreEquals(random_val, min_val, "Very large random value should be >= min")
		assertLessEquals(random_val, max_val, "Very large random value should be <= max")
	end
end)

addTest("random: including negative numbers", function()
	local min_val = OnoeNum.new(-10)
	local max_val = OnoeNum.new(10)

	for i = 1, 10 do
		local random_val = OnoeNum.random(min_val, max_val)
		assertMoreEquals(random_val, min_val, "Random value should be >= min (negative)")
		assertLessEquals(random_val, max_val, "Random value should be <= max (negative)")
	end
end)

addTest("random: zero range", function()
	local val = OnoeNum.new(42)
	local random_val = OnoeNum.random(val, val)
	assertEquals(random_val, val, "Random with same min and max should return that value")
end)

addTest("random: zero values", function()
	local zero = OnoeNum.new(0)
	local random_val = OnoeNum.random(zero, zero)
	assertEquals(random_val, zero, "Random with zero range should return zero")
end)

runTests()
