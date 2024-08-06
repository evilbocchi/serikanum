type Suffixes = {
    beginning: string[],
    first: string[],
    second: string[],
    third: string[],
};

/**
 * Small number suffixing library.
 */
interface Suffixer {
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

/** @hidden */
declare const Suffixer: Suffixer;

export = Suffixer;