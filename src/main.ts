// reference : 
// https://github.com/kach/nearley/blob/master/examples/fun-lang.ne
// https://nearley.js.org/docs/tokenizers



import * as nearley from "nearley"
const grammar = require("./expr.js");

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));
//parser.feed('(1+(2+3)*4 == 5 and Order.ID>"888")');

try {
	parser.feed('1+2*3-5/6+[Table].[Attr1].[arr2]');
	console.dir(parser.results, {depth:null});
	console.debug(JSON.stringify(parser.results));
} catch (err) {
	console.log(`Error character '${err.token.value}' at ${err.offset}`); // "Error at character 9"
}



//console.debug(JSON.stringify(parser.results));