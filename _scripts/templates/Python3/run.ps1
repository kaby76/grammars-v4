if (Test-Path -Path .\.venv\Scripts ) {
    .venv\Scripts\Activate.ps1
} elseif (Test-Path -Path .\.venv\bin ) {
    .venv\bin\activate
}
python Test.py $args
