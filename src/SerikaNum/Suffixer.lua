local Suffixer = {};

Suffixer.suffixes = {
	beginning = {"K", "M", "B"},
	first = {"U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No"},
	second = {"De", "Vt", "Tg", "Qdg", "Qng", "Sxg", "Spg", "Ocg", "Nog"},
	third = {"Ce", "Dce", "Tce", "Qdce", "Qnce", "Sxce", "Spce", "Occe", "Noce"},
	fourth = {},
};

Suffixer.savedSuffixes = {};

function Suffixer.getSuffix(exponent: number): string?
	if (exponent < 3) then
		return nil;
	end
	local firstDivisee = math.floor(exponent / 3);
	local savedSuffix = Suffixer.savedSuffixes[firstDivisee];
	if (savedSuffix ~= nil) then
		return savedSuffix;
	end
	local final = "";
	if (firstDivisee < 4) then
		final = Suffixer.suffixes.beginning[firstDivisee];
	else
		local secondDivisee: number?;
		local thirdDivisee: number?;
		if (exponent > 302) then
			thirdDivisee = math.floor((exponent - 3) / 300);
			final = Suffixer.suffixes.third[thirdDivisee];
		end
		if (exponent > 32) then
			secondDivisee = math.floor((exponent - 3) / 30);
			if (thirdDivisee ~= nil) then
				secondDivisee -= thirdDivisee * 10;
				firstDivisee -= thirdDivisee * 100;
			end
			firstDivisee -= secondDivisee * 10 + 1;
			local second = Suffixer.suffixes.second[secondDivisee];
			if (second ~= nil) then
				final = second .. final;
			end
			local first = Suffixer.suffixes.first[firstDivisee];
			if (first ~= nil) then
				final = first .. final;
			end
		else
			final = Suffixer.suffixes.first[firstDivisee - 1];
		end
	end

	Suffixer.savedSuffixes[firstDivisee] = final;
	return final;
end

return Suffixer;