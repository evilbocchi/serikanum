/** 
 * The base version of an OnoeNum object, stripped of its metatables and metamethods.
 * This type commonly appears when sending OnoeNum objects over the client-server boundary or saving it in datastores.
 * 
 * @example
 * {mantissa: 5.22, exponent: 4} // This represents 5.22 * 10^4, or 52200.
 */
export interface BaseOnoeNum {
    /** This number primitive represents the significant digits of the entire number. */
    mantissa: number,
    /** This number primitive represents how much to exponentiate the mantissa by. */
    exponent: number
}

/** An object representing a number in this library. This could be a number primitive, {@link BaseOnoeNum} or {@link OnoeNum}.*/
export type Number = BaseOnoeNum | number;

export type Suffixes = {
    beginning: string[],
    first: string[],
    second: string[],
    third: string[],
};

/**
 * Small number suffixing library.
 */
export interface Suffixer {
    /**
     * Gets the suffix for the specified exponent number if the number were to be simplified to less than 1000.
     * 
     * @example
     * getSuffix(9) // returns B
     * 
     * @param exponent Exponent number primitive
     */
    getSuffix: (exponent: number) => string | undefined;
    /**
     * Change the suffixes to be shown when using the method {@link getSuffix}.
     * 
     * @example 
     * changeSuffixes({
     *      beginning: ["K", "M", "B"],
     *      first: ["U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No"],
     *      second: ["De", "Vt", "Tg", "Qdg", "Qng", "Sxg", "Spg", "Ocg", "Nog"],
     *      third: ["Ce", "Dce", "Tce", "Qdce", "Qnce", "Sxce", "Spce", "Occe", "Noce"]
     * })
     * @param suffixes Suffix dictionary. 
     */
    changeSuffixes: (suffixes: Suffixes) => void;
}

/**
 * Basic library for performing mathematical operations on numbers exceeding 2^1024.
 */
declare const SerikaNum: {
    /** Create a new SerikaNum tuple from a primitive number, returning the mantissa and exponent respectively. */
	new: (number: number) => LuaTuple<[number, number]>,
    /**
     * Adds two SerikaNum tuples together.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	add: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
    /**
     * Substracts the first SerikaNum tuple by the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	sub: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
    /**
     * Multiplies two SerikaNum tuples together.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	mul: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
    /**
     * Divides the first SerikaNum tuple by the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	div: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
    /**
     * Raises the SerikaNum tuple by the specified power.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @param power Power to raise by in a primitive number.
     * @returns Resulting SerikaNum tuple
     */
	pow: (mantissa: number, exponent: number, power: number) => LuaTuple<[number, number]>;
    /**
     * Gets the remainder of the first SerikaNum tuple divided by the second.
     * This is a slightly expensive operation.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	mod: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => LuaTuple<[number, number]>;
    /**
     * Checks if two SerikaNum tuples are equivalent.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns Equality of the two SerikaNum tuples
     */
	equals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
    /**
     * Checks if the first SerikaNum tuple is less than the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns First SerikaNum tuple is less than the second
     */
	lessThan: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
    /**
     * Checks if the first SerikaNum tuple is less than or equal to the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns First SerikaNum tuple is less than or equal to the second
     */
	lessEquals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
    /**
     * Checks if the first SerikaNum tuple is more than to the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns First SerikaNum tuple is more than the second
     */
	moreThan: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
    /**
     * Checks if the first SerikaNum tuple is more than or equal to the second.
     * 
     * @param mantissa1 First SerikaNum tuple's mantissa
     * @param exponent1 First SerikaNum tuple's exponent
     * @param mantissa2 Second SerikaNum tuple's mantissa
     * @param exponent2 Second SerikaNum tuple's exponent
     * @returns First SerikaNum tuple is more than or equal to the second
     */
	moreEquals: (mantissa1: number, exponent1: number, mantissa2: number, exponent2: number) => boolean;
    /**
     * Rounds down the SerikaNum tuple to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns SerikaNum tuple rounded down to the nearest integer
     */
	floor: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
    /**
     * Rounds the SerikaNum tuple to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns SerikaNum tuple rounded to the nearest integer
     */
	round: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
     /**
     * Rounds up the SerikaNum tuple to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns SerikaNum tuple rounded up to the nearest integer
     */
	ceil: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
    /**
     * Get the absolute value of the SerikaNum tuple.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Absolute value of the SerikaNum tuple
     */
	abs: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
    /**
     * Flips the sign of the SerikaNum tuple.
     * Equivalent to multiplying by -1.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Negative of the SerikaNum tuple
     */
	unary: (mantissa: number, exponent: number) => LuaTuple<[number, number]>;
    /**
     * Reverts the SerikaNum tuple back to a primitive number.
     * For numbers beyond 2^1024, this will return `math.huge`.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Reverted primitive number
     */
	revert: (mantissa: number, exponent: number) => number;
    /**
     * Get the logarithm of the SerikaNum tuple with the specified primitive number base.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @param base Base of the logarithm as a primitive number
     * @returns Resulting SerikaNum tuple
     */
	log: (mantissa: number, exponent: number, base?: number) => LuaTuple<[number, number]> | undefined;
    /**
     * Get the logarithm of the SerikaNum tuple with a base of 10.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Resulting SerikaNum tuple
     */
	log10: (mantissa: number, exponent: number) => LuaTuple<[number, number]> | undefined;
    /**
     * Converts the SerikaNum tuple into a string with the specified mode.
     * If suffix is used, this method is equivalent to {@link toSuffix}.
     * If scientific is used, this method is equivalent to {@link toScientific}.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @param mode Mode of conversion to string
     * @returns Resulting string
     */
	toString: (mantissa: number, exponent: number, mode?: "suffix" | "scientific") => string;
    /**
     * Converts the SerikaNum tuple into a string with a number and suffix.
     * Use the {@link Suffixer.changeSuffixes} method to edit the suffixes. 
     * If a suffix for the specified SerikaNum tuple is not found, scientific notation is used.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Resulting string
     */
	toSuffix: (mantissa: number, exponent: number) => string;
    /**
     * Converts the SerikaNum tuple into a string in scientific notation format.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Resulting string
     */
	toScientific: (mantissa: number, exponent: number) => string;
    /**
     * Converts the SerikaNum tuple into a single primitive number that represents the magnitude of the number.
     * This method should only be used for leaderboards and other things that do not require the
     * specific number itself as the resulting single numbers are highly inaccurate.
     * 
     * @param mantissa SerikaNum tuple's mantissa
     * @param exponent SerikaNum tuple's exponent
     * @returns Resulting single number
     */
	toSingle: (mantissa: number, exponent: number) => number;
    /**
     * Converts the single primitive number back into a SerikaNum tuple.
     * This SerikaNum tuple is usually much more inaccurate than it previous was before conversion into
     * a single primitive number.
     * Use this method to display numbers stored in leaderboard datastores.
     * 
     * @param single Single primitive number
     * @returns Resulting SerikaNum tuple
     */
	fromSingle: (single: number) => LuaTuple<[number, number]>;
    /**
     * In SerikaNum, addition and substraction is usually performed at up to 16 digits of precision.
     * This means that `1e+16 + 1` will simply remain as `1e+16`, while `1e+15 + 1` would change.
     * Change this threshold to modify how large a difference is allowed for such calculations.
     * Note that this usually does not provide any performance improvements.
     * 
     * @param threshold New exponent threshold
     */
	changeThreshold: (threshold: number) => void;
    /**
     * Change the number of decimal points when formatting SerikaNum tuples into a string.
     * 
     * @param decimalPoints Decimal points to display in strings
     */
	changeDecimalPoints: (decimalPoints: number) => void;
    /**
     * Change the default abbreviation mode used in {@link toString}. 
     * 
     * @param mode Abbreviation method to use
     */
	changeDefaultAbbreviation: (mode: "suffix" | "scientific") => void;

    OnoeNum: OnoeNumConstructor;
    Suffixer: Suffixer;
};

/**
 * Wrapper library for SerikaNum.
 */
export interface OnoeNum extends BaseOnoeNum {
    /** macro for OnoeNum + OnoeNum */
	add(number: Number): OnoeNum;
    /** macro for OnoeNum - OnoeNum */
    sub(number: Number): OnoeNum;
    /** macro for OnoeNum * OnoeNum */
    mul(number: Number): OnoeNum;
    /** macro for OnoeNum / OnoeNum */
    div(number: Number): OnoeNum;
    /** macro for OnoeNum ^ OnoeNum */
    pow(number: Number): OnoeNum;
    /** macro for OnoeNum % OnoeNum */
    mod(number: Number): OnoeNum;

    /** macro for OnoeNum == OnoeNum */
    equals(number: Number): boolean;
    /** macro for OnoeNum < OnoeNum */
    lessThan(number: Number): boolean;
    /** macro for OnoeNum <= OnoeNum */
    lessEquals(number: Number): boolean;
    /** macro for OnoeNum > OnoeNum */
    moreThan(number: Number): boolean;
    /** macro for OnoeNum >= OnoeNum */
    moreEquals(number: Number): boolean;

    /**
     * Rounds down the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     */
	floor(): OnoeNum;
    /**
     * Rounds the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     */
	round(): OnoeNum;
    /**
     * Rounds up the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     */
	ceil(): OnoeNum;
    /**
     * Get the absolute value of the OnoeNum.
     */
	abs(): OnoeNum;
    /**
     * Flips the sign of the OnoeNum object.
     * Equivalent to multiplying by -1.
     */
    unary(): OnoeNum;
    /**
     * Reverts the OnoeNum back to a primitive number.
     * For numbers beyond 2^1024, this will return `math.huge`.
     */
    revert(): number;
    /**
     * Get the logarithm of the OnoeNum object with the specified primitive number base.
     * 
     * @param base Base of the logarithm as a primitive number
     */
	log(base: number): OnoeNum | undefined;
    /**
     * Get the logarithm of the OnoeNum object with a base of 10.
     */
	log10(): OnoeNum | undefined;
    /**
     * Converts the OnoeNum object into a string with the specified mode.
     * If suffix is used, this method is equivalent to {@link OnoeNum.toSuffix}.
     * If scientific is used, this method is equivalent to {@link OnoeNum.toScientific}.
     * 
     * @param mode Mode of conversion to string
     * @returns Resulting string
     */
    toString(mode?: "suffix" | "scientific"): string;
    /**
     * Converts the OnoeNum into a string with a number and suffix.
     * Use the {@link Suffixer.changeSuffixes} method to edit the suffixes.
     * If a suffix for the specified OnoeNum tuple is not found, scientific notation is used.
     * 
     * @returns Resulting string
     */
    toSuffix(): string;
    /**
     * Converts the SerikaNum tuple into a string in scientific notation format.
     * 
     * @returns Resulting string
     */
    toScientific(): string;
    /**
     * Converts the SerikaNum tuple into a single primitive number that represents the magnitude of the number.
     * This method should only be used for leaderboards and other things that do not require the
     * specific number itself as the resulting single numbers are highly inaccurate.
     *
     * @returns Resulting single number
     */
    toSingle(): number;
}

/**
 * Static version of {@link OnoeNum}. This is only separated because roblox-ts requires it.
 * You can simply ignore the naming and treat this interface as {@link OnoeNum}.
 */
export interface OnoeNumConstructor {
    /**
     * Create a new OnoeNum object from a primitive number.
     * @param val Primitive number or a table containing mantissa and exponent entries
     */
	new(val: Number): OnoeNum;

    /**
     * Create a new OnoeNum object from a mantissa and exponent.
     * This simply wraps the two numbers into a table and provides it the OnoeNum metatable.
     * This could be useful for quickly creating large numbers exceeding 10^308 without having
     * to do num1 * 10 ^ num2.
     * @example
     * const number = OnoeNum.fromSerika(5.23, 2359) // 5.23e2359
     * 
     * @param mantissa Mantissa of the SerikaNum
     * @param exponent Exponent of the SerikaNum
     * @returns Resulting OnoeNum object
     */
    fromSerika: (mantissa: number, exponent: number) => OnoeNum;

    /**
     * Rounds down the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param number Number to round down
     * @returns OnoeNum rounded down to the nearest integer
     */
	floor: (number: Number) => OnoeNum;
    /**
     * Rounds the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param number Number to round
     * @returns OnoeNum rounded to the nearest integer
     */
	round: (number: Number) => OnoeNum;
    /**
     * Rounds up the OnoeNum to the nearest integer.
     * This operation is unsafe for numbers beyond 2^1024.
     * 
     * @param number Number to round up
     * @returns OnoeNum rounded up to the nearest integer
     */
	ceil: (number: Number) => OnoeNum;
    /**
     * Get the absolute value of the OnoeNum.
     * 
     * @param number OnoeNum object
     * @returns Absolute value of the OnoeNum object
     */
	abs: (number: Number) => OnoeNum;
    /**
     * Flips the sign of the OnoeNum object.
     * Equivalent to multiplying by -1.
     * 
     * @param number OnoeNum object
     * @returns Negative of the OnoeNum object
     */
    unary: (number: Number) => OnoeNum;
    /**
     * Reverts the OnoeNum back to a primitive number.
     * For numbers beyond 2^1024, this will return `math.huge`.
     * 
     * @param number OnoeNum object
     * @returns Reverted primitive number
     */
    revert: (number: BaseOnoeNum) => number;
    /**
     * Get the logarithm of the OnoeNum object with the specified primitive number base.
     * 
     * @param number OnoeNum object
     * @param base Base of the logarithm as a primitive number
     * @returns Resulting OnoeNum object. Note that if the specified number is negative, this will return nil.
     */
	log: (number: Number, base: number) => OnoeNum | undefined;
    /**
     * Get the logarithm of the OnoeNum object with a base of 10.
     * 
     * @param number OnoeNum object
     * @returns Resulting OnoeNum object
     */
	log10: (number: Number) => OnoeNum | undefined;
    /**
     * Converts the OnoeNum object into a string with the specified mode.
     * If suffix is used, this method is equivalent to {@link toSuffix}.
     * If scientific is used, this method is equivalent to {@link toScientific}.
     * 
     * @param number OnoeNum object
     * @param mode Mode of conversion to string
     * @returns Resulting string
     */
    toString: (number: Number, mode?: "suffix" | "scientific") => string;
    /**
     * Converts the OnoeNum into a string with a number and suffix.
     * Use the {@link Suffixer.changeSuffixes} method to edit the suffixes.
     * If a suffix for the specified OnoeNum tuple is not found, scientific notation is used.
     * 
     * @param number OnoeNum object
     * @returns Resulting string
     */
    toSuffix: (number: Number) => string;
    /**
     * Converts the OnoeNum object into a string in scientific notation format.
     * 
     * @param number OnoeNum object
     * @returns Resulting string
     */
    toScientific: (number: Number) => string;
    /**
     * Converts the OnoeNum object into a single primitive number that represents the magnitude of the number.
     * This method should only be used for leaderboards and other things that do not require the
     * specific number itself as the resulting single numbers are highly imprecise.
     * 
     * @param number OnoeNum object
     * @returns Resulting single number
     */
    toSingle: (number: Number) => number;
    /**
     * Converts the single primitive number back into an OnoeNum object.
     * This OnoeNum object is usually much more imprecise than it previous was before conversion into
     * a single primitive number.
     * Use this method to display numbers stored in leaderboard datastores.
     * 
     * @param single Single primitive number
     * @returns Resulting OnoeNum object
     */
    fromSingle: (single: number) => OnoeNum;
    /**
     * Returns the maximum value of all OnoeNum objects passed.
     * 
     * @param numbers OnoeNum objects
     * @returns Largest OnoeNum object
     */
    max: (...numbers: Number[]) => OnoeNum;
    /**
     * Returns the minimum value of all OnoeNum objects passed.
     * 
     * @param numbers OnoeNum objects
     * @returns Smallest OnoeNum object
     */
    min: (...numbers: Number[]) => OnoeNum;
}

export default SerikaNum;