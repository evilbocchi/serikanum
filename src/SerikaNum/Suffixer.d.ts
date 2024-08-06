declare namespace Suffixer {
    export const suffixes: {
        beginning: ["K", "M", "B"],
        first: ["U", "D", "T", "Qd", "Qn", "Sx", "Sp", "Oc", "No"],
        second: ["De", "Vt", "Tg", "Qdg", "Qng", "Sxg", "Spg", "Ocg", "Nog"],
        third: ["Ce", "Dce", "Tce", "Qdce", "Qnce", "Sxce", "Spce", "Occe", "Noce"],
        fourth: [],
    };
    export let savedSuffixes: string[];
    export function getSuffix(exponent: number): string | undefined;
}

export = Suffixer;