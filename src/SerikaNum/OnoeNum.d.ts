import Suffixer from "./Suffixer";

/** 
 * The base version of an OnoeNum object, stripped of its metatables and metamethods.
 * This type commonly appears when sending OnoeNum objects over the client-server boundary or saving it in datastores.
 * 
 * @example
 * {mantissa: 5.22, exponent: 4} // This represents 5.22 * 10^4, or 52200.
 */
interface BaseOnoeNum {
    /** This number primitive represents the significant digits of the entire number. */
    mantissa: number,
    /** This number primitive represents how much to exponentiate the mantissa by. */
    exponent: number
}

/** An object representing a number in this library. This could be a number primitive, {@link BaseOnoeNum} or {@link OnoeNum}.*/
type Number = BaseOnoeNum | number;

/**
 * Wrapper library for SerikaNum.
 */
interface OnoeNum extends BaseOnoeNum {
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
interface OnoeNumConstructor {
    /**
     * Create a new OnoeNum object from a primitive number.
     * @param val Primitive number or a table containing mantissa and exponent entries
     */
	new(val: Number): OnoeNum;
    /**
     * Create a new OnoeNum object from a mantissa and exponent.
     * This simply wraps the two numbers into a table and provides it the OnoeNum metatable.
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

/** @hidden */
declare const OnoeNum: OnoeNumConstructor;

export = OnoeNum;