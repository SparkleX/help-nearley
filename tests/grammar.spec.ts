import * as chai from "chai";
import * as glob from "glob";
import * as jsonfile from "jsonfile";
import * as fs from "fs";
import * as nearley from "nearley";

const grammar = require("../src/expr.js");
//chai.should();
//chai.use(sinonChai);




describe("Expression Test", () => {
    it("Test All", async () => {
		let files = glob.sync("tests/data/*.expr.txt");
		for(let inFile of files) {
			console.info(inFile);
			let outFile = inFile.slice(0, -8) + "tree.json";
			var outJson = jsonfile.readFileSync(outFile);
			var inputText = fs.readFileSync(inFile, "utf8");
			const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));
			parser.feed(inputText);
			console.debug(JSON.stringify(parser.results[0])+"\r\n");
			chai.expect(parser.results[0]).to.deep.equals(outJson);
		}
    });
});
