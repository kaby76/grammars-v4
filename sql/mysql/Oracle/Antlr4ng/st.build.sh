# Generated from trgen <version>
set -e
rm -rf node_modules package-lock.json
#npm install -g typescript ts-node
npm install

if [ -f transformGrammar.py ]; then python3 transformGrammar.py ; fi

# Because there is no integrated build script for Dart targets, we need
# to manually look at the version in package.json and extract the
# version number. We can then use this with antlr4 to generate the
# parser and lexer.
version=`grep antlr4 package.json | awk '{print $2}' | tr -d '"' | tr -d ',' | tr -d '\r' | tr -d '\n'`

<tool_grammar_tuples:{x |
tsx --tsconfig ~/antlr-ng/tsconfig.json ~/antlr-ng/cli/runner.ts -Dlanguage=TypeScript <x.AntlrArgs> <antlr_tool_args:{y | <y> } > <x.GrammarFileName>
} >

rm -rf original

tsc -p tsconfig.json --pretty
exit 0


java -jar ./node_modules/antlr4ng-cli/*.jar -encoding utf-8 -Dlanguage=TypeScript   MySQLLexer.g4
java -jar ./node_modules/antlr4ng-cli/*.jar -encoding utf-8 -Dlanguage=TypeScript   MySQLParser.g4

tsc -p tsconfig.json --pretty
exit 0
