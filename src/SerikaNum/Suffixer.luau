--!native
--!optimize 2

local Suffixer = {}

local suffixes = {
	beginning = { "K", "M", "B" },
	first = { "U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No" },
	second = { "De", "Vt", "Tg", "Qdg", "Qng", "Sxg", "Spg", "Ocg", "Nog" },
	third = { "Ce", "Dce", "Tce", "Qdce", "Qnce", "Sxce", "Spce", "Occe", "Noce" },
}

local maximum = math.huge

function Suffixer.getSuffix(exponent: number, isUnbounded: boolean?): string?
	if exponent < 3 or exponent > maximum then
		return nil
	end
	local firstDivisee = math.floor(exponent / 3)
	local final = ""
	if firstDivisee < 4 then
		final = suffixes.beginning[firstDivisee]
	else
		local secondDivisee: number?
		local thirdDivisee: number?
		if exponent > 302 then
			thirdDivisee = math.floor((exponent - 3) / 300)
			final = suffixes.third[thirdDivisee]
			if final == nil then
				maximum = exponent
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

function Suffixer.changeSuffixes(suffixes: typeof(suffixes))
	maximum = math.huge
	suffixes = suffixes
end

return Suffixer
