# Generated from trgen <version>
Get-Content build.ps1 | Write-Host

if (Test-Path -Path transformGrammar.py -PathType Leaf) {
    $(& python3 transformGrammar.py ) 2>&1 | Write-Host
}

# Because there is no integrated build script for Dart targets, we need
# to manually look at the version in requirements.txt and extract the
# version number. We can then use this with antlr4 to generate the
# parser and lexer.
$version = (Select-String -Path "requirements.txt" -Pattern "antlr4" | ForEach-Object {$_.Line.Split("=")[2]}) -replace '"|,|\r|\n'

python3 -m venv .venv
if (Test-Path -Path .\.venv\Scripts ) {
    .venv\Scripts\Activate.ps1
    .venv\Scripts\pip install -r requirements.txt
} elseif (Test-Path -Path .\.venv\bin ) {
    .venv\bin\activate
    .venv\bin\pip install -r requirements.txt
}

<if(antlrng_tool)>
npm init -y
npm i antlr-ng
<else>
if (Test-Path -Path .\.venv\Scripts ) {
    .venv\Scripts\pip install antlr4-tools
} elseif (Test-Path -Path .\.venv\bin ) {
    .venv\bin\pip install antlr4-tools
}
<endif>

<tool_grammar_tuples:{x |
<if(antlrng_tool)>
$(& tsx $HOME/antlr-ng/cli/runner.ts --encoding <antlr_encoding> -Dlanguage=Python3 <x.AntlrArgs> <antlr_tool_args:{y | <y> } > <x.GrammarFileNameTarget> ; $compile_exit_code = $LASTEXITCODE) | Write-Host
<else>
$(& antlr4 -v $version <x.GrammarFileNameTarget> -encoding <antlr_encoding> -Dlanguage=Python3 <x.AntlrArgs> <antlr_tool_args:{y | <y> } > ; $compile_exit_code = $LASTEXITCODE) | Write-Host
<endif>
}>

exit $compile_exit_code
