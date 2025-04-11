// This array contains a mix of strings and numbers for demonstration purposes.
// Strings will be filtered and processed, while numbers are ignored.
const example = ["man", "axe", "mango", 123, "power", 654.983, 9485, 3395];
// Filter the array to include only elements of type string
const strings = example.filter(item => typeof item === "string");
// Define locale options for sorting
const localeOptions = { sensitivity: "base" };

// Sort strings alphabetically (case-insensitive)
strings.sort((a, b) => a.localeCompare(b, undefined, localeOptions));
strings.sort((a, b) => a.localeCompare(b, undefined, { sensitivity: "base" }));

console.log("Alphabetically Ordered Strings:", strings);
const stringCount = strings.length;

console.log("Ordered Strings:", strings);
console.log("Number of Strings:", stringCount);
