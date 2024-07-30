type BaseOnoeNum = {mantissa: number, exponent: number};
type Number = number | BaseOnoeNum;

declare interface OnoeNum extends BaseOnoeNum {
	add(number: Number): OnoeNum;
    sub(number: Number): OnoeNum;
    mul(number: Number): OnoeNum;
    div(number: Number): OnoeNum;
    pow(number: Number): OnoeNum;
    mod(number: Number): OnoeNum;

    equals(number: Number): boolean;
    lessThan(number: Number): boolean;
    lessEquals(number: Number): boolean;
    moreThan(number: Number): boolean;
    moreEquals(number: Number): boolean;
    
    revert(): number;
    toString(mode?: "suffix" | "scientific"): string;
    toSuffix(): string;
    toScientific(): string;
    toSingle(): number;
}

interface OnoeNumConstructor {
	new(val: Number): OnoeNum;
    fromSerika: (mantissa: number, exponent: number) => OnoeNum;

	floor: (number: Number) => OnoeNum;
	round: (number: Number) => OnoeNum;
	ceil: (number: Number) => OnoeNum;
	abs: (number: Number) => OnoeNum;
    unary: (number: Number) => OnoeNum;
    revert: (number: BaseOnoeNum) => number;
	sign: (number: Number) => OnoeNum;
	log: (number: Number, Base: number) => OnoeNum | undefined;
	log10: (number: Number) => OnoeNum | undefined;
    toString: (number: Number, mode?: "suffix" | "scientific") => string;
    toSuffix: (number: Number) => string;
    toScientific: (number: Number) => string;
    toSingle: (number: Number) => number;
    fromSingle: (number: number) => OnoeNum;
    max: (...numbers: Number[]) => OnoeNum;
    min: (...numbers: Number[]) => OnoeNum;
}

declare const OnoeNum: OnoeNumConstructor;

export = OnoeNum;