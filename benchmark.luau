--!optimize 2
--!native

-- Simplified benchmark tests for SerikaNum vs number vs OnoeNum performance
-- This script reproduces the performance comparison chart results

local SerikaNum = require("./SerikaNum")
local OnoeNum = SerikaNum.OnoeNum

-- Benchmark configuration
local ITERATIONS = 200000 -- 200K operations as mentioned in the chart
local WARMUP_ITERATIONS = 1000

-- Test data setup
local testNumbers = {
	small = { 123.456, 789.012, 345.678 },
	medium = { 1.23e15, 4.56e20, 7.89e25 },
	large = { 1.23e100, 4.56e200, 7.89e300 }
}

-- Convert test numbers to SerikaNum format
local testSerikaNum = {}
for category, numbers in testNumbers do
	testSerikaNum[category] = {}
	for i, num in numbers do
		local mantissa, exponent = SerikaNum.new(num)
		testSerikaNum[category][i] = { mantissa = mantissa, exponent = exponent }
	end
end

-- Convert test numbers to OnoeNum format
local testOnoeNum = {}
for category, numbers in testNumbers do
	testOnoeNum[category] = {}
	for i, num in numbers do
		testOnoeNum[category][i] = OnoeNum.new(num)
	end
end

-- Utility functions
local function formatTime(ns: number): string
	if ns < 1000 then
		return string.format("%.2f ns", ns)
	elseif ns < 1000000 then
		return string.format("%.2f μs", ns / 1000)
	else
		return string.format("%.2f ms", ns / 1000000)
	end
end

local function formatOpsPerSecond(ops: number): string
	if ops >= 1000000 then
		return string.format("%.2f M ops/s", ops / 1000000)
	elseif ops >= 1000 then
		return string.format("%.2f K ops/s", ops / 1000)
	else
		return string.format("%.2f ops/s", ops)
	end
end

local function benchmark(name: string, func: () -> (), iterations: number): (number, number)
	-- Warmup
	for i = 1, WARMUP_ITERATIONS do
		func()
	end
	
	-- Actual benchmark
	local startTime = os.clock()
	for i = 1, iterations do
		func()
	end
	local endTime = os.clock()
	
	local totalTime = (endTime - startTime) * 1000000000 -- Convert to nanoseconds
	local avgTime = totalTime / iterations
	local opsPerSecond = 1000000000 / avgTime
	
	print(string.format("%-20s: %s/op (%s)", name, formatTime(avgTime), formatOpsPerSecond(opsPerSecond)))
	
	return avgTime, opsPerSecond
end

-- Main benchmark execution
local function runAllBenchmarks()
	print("🚀 SerikaNum Performance Benchmark Suite")
	print(string.format("Running %dK iterations per test with %d warmup iterations", ITERATIONS / 1000, WARMUP_ITERATIONS))
	print(string.rep("=", 60))
	
	-- Store all results
	local allResults = {}
	
	-- Addition benchmarks
	print("\n=== Addition Benchmarks ===")
	
	local a, b = testNumbers.medium[1], testNumbers.medium[2]
	local numberTime, numberOps = benchmark("number", function()
		local _ = a + b
	end, ITERATIONS)
	
	local sa = testSerikaNum.medium[1]
	local sb = testSerikaNum.medium[2]
	local serikaTime, serikaOps = benchmark("SerikaNum", function()
		local _, _ = SerikaNum.add(sa.mantissa, sa.exponent, sb.mantissa, sb.exponent)
	end, ITERATIONS)
	
	local oa = testOnoeNum.medium[1]
	local ob = testOnoeNum.medium[2]
	local onoeTime, onoeOps = benchmark("OnoeNum", function()
		local _ = oa + ob
	end, ITERATIONS)
	
	allResults.addition = {
		number = { time = numberTime, ops = numberOps },
		serika = { time = serikaTime, ops = serikaOps },
		onoe = { time = onoeTime, ops = onoeOps }
	}
	
	-- Multiplication benchmarks
	print("\n=== Multiplication Benchmarks ===")
	
	numberTime, numberOps = benchmark("number", function()
		local _ = a * b
	end, ITERATIONS)
	
	serikaTime, serikaOps = benchmark("SerikaNum", function()
		local _, _ = SerikaNum.mul(sa.mantissa, sa.exponent, sb.mantissa, sb.exponent)
	end, ITERATIONS)
	
	onoeTime, onoeOps = benchmark("OnoeNum", function()
		local _ = oa * ob
	end, ITERATIONS)
	
	allResults.multiplication = {
		number = { time = numberTime, ops = numberOps },
		serika = { time = serikaTime, ops = serikaOps },
		onoe = { time = onoeTime, ops = onoeOps }
	}
	
	-- Exponentiation benchmarks
	print("\n=== Exponentiation Benchmarks ===")
	
	local a_small = testNumbers.small[1]
	local power = 2.5
	numberTime, numberOps = benchmark("number", function()
		local _ = a_small ^ power
	end, ITERATIONS)
	
	local sa_small = testSerikaNum.small[1]
	serikaTime, serikaOps = benchmark("SerikaNum", function()
		local _, _ = SerikaNum.pow(sa_small.mantissa, sa_small.exponent, power)
	end, ITERATIONS)
	
	local oa_small = testOnoeNum.small[1]
	onoeTime, onoeOps = benchmark("OnoeNum", function()
		local _ = oa_small ^ power
	end, ITERATIONS)
	
	allResults.exponentiation = {
		number = { time = numberTime, ops = numberOps },
		serika = { time = serikaTime, ops = serikaOps },
		onoe = { time = onoeTime, ops = onoeOps }
	}
	
	-- Comparison benchmarks
	print("\n=== Comparison Benchmarks ===")
	
	numberTime, numberOps = benchmark("number", function()
		local _ = a < b
		local _ = a > b
		local _ = a == b
	end, ITERATIONS)
	
	serikaTime, serikaOps = benchmark("SerikaNum", function()
		local _ = SerikaNum.lessThan(sa.mantissa, sa.exponent, sb.mantissa, sb.exponent)
		local _ = SerikaNum.moreThan(sa.mantissa, sa.exponent, sb.mantissa, sb.exponent)
		local _ = SerikaNum.equals(sa.mantissa, sa.exponent, sb.mantissa, sb.exponent)
	end, ITERATIONS)
	
	onoeTime, onoeOps = benchmark("OnoeNum", function()
		local _ = oa < ob
		local _ = oa > ob
		local _ = oa == ob
	end, ITERATIONS)
	
	allResults.comparison = {
		number = { time = numberTime, ops = numberOps },
		serika = { time = serikaTime, ops = serikaOps },
		onoe = { time = onoeTime, ops = onoeOps }
	}
	
	-- Analysis and summary
	print("\n" .. string.rep("=", 60))
	print("📊 PERFORMANCE ANALYSIS")
	print(string.rep("=", 60))
	
	local function calculateSpeedRatio(baseline: number, target: number): string
		local ratio = baseline / target
		if ratio > 1 then
			return string.format("%.1fx slower", ratio)
		else
			return string.format("%.1fx faster", target / baseline)
		end
	end
	
	for operation, results in allResults do
		print(string.format("\n--- %s Performance Analysis ---", operation))
		
		local baselineOps = results.number.ops
		local serikaOps = results.serika.ops
		local onoeOps = results.onoe.ops
		
		print(string.format("SerikaNum vs number: %s", calculateSpeedRatio(serikaOps, baselineOps)))
		print(string.format("OnoeNum vs number: %s", calculateSpeedRatio(onoeOps, baselineOps)))
		print(string.format("SerikaNum vs OnoeNum: %s", calculateSpeedRatio(serikaOps, onoeOps)))
		
		-- Calculate approximate ms/200K operations as shown in chart
		local numberMs = (results.number.time * ITERATIONS) / 1000000
		local serikaMs = (results.serika.time * ITERATIONS) / 1000000
		local onoeMs = (results.onoe.time * ITERATIONS) / 1000000
		
		print(string.format("\nTime for %dK operations:", ITERATIONS / 1000))
		print(string.format("number:    %.1f ms", numberMs))
		print(string.format("SerikaNum: %.1f ms", serikaMs))
		print(string.format("OnoeNum:   %.1f ms", onoeMs))
	end
	
	-- Summary table matching the chart format
	print("\n" .. string.rep("=", 60))
	print("📋 SUMMARY TABLE (ms/200K operations)")
	print(string.rep("=", 60))
	
	print(string.format("%-15s | %-10s | %-10s | %-10s", "Operation", "number", "SerikaNum", "OnoeNum"))
	print(string.rep("-", 55))
	
	for operation, results in allResults do
		local numberMs = (results.number.time * ITERATIONS) / 1000000
		local serikaMs = (results.serika.time * ITERATIONS) / 1000000
		local onoeMs = (results.onoe.time * ITERATIONS) / 1000000
		
		print(string.format("%-15s | %-10.1f | %-10.1f | %-10.1f", operation, numberMs, serikaMs, onoeMs))
	end
	
	print("\n✅ Benchmark completed successfully!")
	print("Note: Lower numbers indicate better performance")
end

-- Execute benchmarks
runAllBenchmarks()