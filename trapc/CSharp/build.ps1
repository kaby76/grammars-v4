# Generated from trgen 0.23.44
if (Test-Path -Path transformGrammar.py -PathType Leaf) {
    $(& python3 transformGrammar.py ) 2>&1 | Write-Host
}

$trxml2_output = dotnet trxml2 Other.csproj
if (-not $trxml2_output -or ($trxml2_output -match '^\s*$')) {
    Write-Host "trxml2 returned no output. Contents of Other.csproj:"
    Get-Content Other.csproj | Write-Host
}
$version = $trxml2_output | Select-String 'PackageReference/@Version' | ForEach-Object { ($_ -split '=')[1].Trim() }
if (-not $version -or $version -eq '') {
    Write-Host "version is empty, defaulting to 4.13.1"
    $version = "4.13.1"
}
Write-Host "trxml2 output"
dotnet trxml2 Other.csproj | Write-Host
Write-Host "trxml2 plus select string output"
dotnet trxml2 Other.csproj | Select-String 'PackageReference/@Version' | Write-Host
Write-Host "version = '$version'"

$(& antlr4 -v $version TrapCLexer.g4 -encoding utf-8 -Dlanguage=CSharp  ; $compile_exit_code = $LASTEXITCODE) | Write-Host
if($compile_exit_code -ne 0){
    exit $compile_exit_code
}
$(& antlr4 -v $version TrapCParser.g4 -encoding utf-8 -Dlanguage=CSharp  ; $compile_exit_code = $LASTEXITCODE) | Write-Host
if($compile_exit_code -ne 0){
    exit $compile_exit_code
}

$content = Get-Content ./CLexerBase.cs -Raw
$content = $content -replace 'TrapCLexerBase', '__PLACEHOLDER__'
$content = $content -replace 'CLexerBase', 'TrapCLexerBase'
$content = $content -replace '__PLACEHOLDER__', 'TrapCLexerBase'
Set-Content ./CLexerBase.cs $content

$content = Get-Content ./CParserBase.cs -Raw
$content = $content -replace 'TrapCParserBase', '__PH1__'
$content = $content -replace 'TrapCParser', '__PH2__'
$content = $content -replace 'TrapCLexer', '__PH3__'
$content = $content -replace 'CParserBase', '__PH1__'
$content = $content -replace 'CParser', '__PH2__'
$content = $content -replace 'CLexer', '__PH3__'
$content = $content -replace '__PH1__', 'TrapCParserBase'
$content = $content -replace '__PH2__', 'TrapCParser'
$content = $content -replace '__PH3__', 'TrapCLexer'
Set-Content ./CParserBase.cs $content

$content = Get-Content ./ErrorListener.cs -Raw
$content = $content -replace 'TrapCLexer', '__PH__'
$content = $content -replace 'CLexer', 'TrapCLexer'
$content = $content -replace '__PH__', 'TrapCLexer'
Set-Content ./ErrorListener.cs $content

$(& dotnet build Test.csproj; $compile_exit_code = $LASTEXITCODE) | Write-Host
exit $compile_exit_code
