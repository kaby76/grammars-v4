# Generated from trgen 0.23.44
set -e
if [ -f transformGrammar.py ]; then python3 transformGrammar.py ; fi

version=`dotnet trxml2 Other.csproj | fgrep 'PackageReference/@Version' | awk -F= '{print $2}'`

antlr4 -v $version -encoding utf-8 -Dlanguage=CSharp   TrapCLexer.g4
antlr4 -v $version -encoding utf-8 -Dlanguage=CSharp   TrapCParser.g4

sed -i \
    's/TrapCLexerBase/__PLACEHOLDER__/g
     s/CLexerBase/TrapCLexerBase/g
     s/__PLACEHOLDER__/TrapCLexerBase/g' \
    ./CLexerBase.cs

sed -i \
    's/TrapCParserBase/__PH1__/g
     s/TrapCParser/__PH2__/g
     s/TrapCLexer/__PH3__/g
     s/CParserBase/__PH1__/g
     s/CParser/__PH2__/g
     s/CLexer/__PH3__/g
     s/__PH1__/TrapCParserBase/g
     s/__PH2__/TrapCParser/g
     s/__PH3__/TrapCLexer/g' \
    ./CParserBase.cs
    
sed -i \
    's/TrapCLexer/__PH__/g
     s/CLexer/TrapCLexer/g
     s/__PH__/TrapCLexer/g' \
    ./ErrorListener.cs

dotnet restore Test.csproj
dotnet build Test.csproj

exit 0
