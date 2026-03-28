if (Test-Path .venv\Scripts\python3.exe) { $env:PATH = "$PWD\.venv\Scripts;$env:PATH" }
python3 Test.py $args
