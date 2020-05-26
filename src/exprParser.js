import * as nearley from "nearley"
const grammar = require("./expr.js");

export function parse(expr) {
	const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));
	parser.feed(expr);
	return parser.results[0];
}