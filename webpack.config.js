const path = require('path');

module.exports = {
	mode: 'production',
  	entry: './src/exprParser.js',
  	output: {
    	path: path.resolve(__dirname, 'public'),
		filename: 'buddle.js',
		library: 'parser'
	}
};