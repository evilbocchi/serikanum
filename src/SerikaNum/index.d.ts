import Suffixer from "./Suffixer";

/**
 * Basic library for performing mathematical operations on numbers exceeding 2^1024.
 */
interface SerikaNum {
    /** Create a new SerikaNum tuple from a primitive number, returning the mantissa and exponent respectively. */
	new (number: number): LuaTuple<[number, number]>;

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
}

/** @hidden */
declare const SerikaNum: SerikaNum;

export = SerikaNum;
