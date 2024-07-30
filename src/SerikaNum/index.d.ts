interface SerikaNum {
	new (number: number): LuaTuple<[number, number]>;
	add: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
	sub: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
	mul: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
	div: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
	pow: (mantissa1: number, exponent1: number, power: number) => LuaTuple<[number, number]>;
	mod: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;

	equals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
	lessThan: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
	lessEquals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
	moreThan: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
	moreEquals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;

	floor: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
	round: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
	ceil: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
	abs: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
	unary: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
	revert: (mantissa: number, exponent: number) => number;
	log: (mantissa: number, exponent: number, base?: number) => LuaTuple<[number, number]> | undefined;
	log10: (mantissa: number, exponent: number) => LuaTuple<[number, number]> | undefined;

	toString: (mantissa: number, exponent: number, mode?: "suffix" | "scientific") => string;
	toSuffix: (mantissa: number, exponent: number) => string;
	toScientific: (mantissa: number, exponent: number) => string;
	toSingle: (mantissa: number, exponent: number) => number;
	fromSingle: (single: number) => LuaTuple<[number, number]>;

	changeThreshold: (threshold: number) => void;
	changeDecimalPoints: (decimalPoints: number) => void;
	changeSuffixes: (suffixes: string[]) => void;
	changeDefaultAbbreviation: (mode: "suffix" | "scientific") => void;
}

declare const SerikaNum: SerikaNum;

export = SerikaNum;
