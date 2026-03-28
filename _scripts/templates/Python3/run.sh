if [ -f .venv/bin/activate ]; then source .venv/bin/activate; fi
python3 Test.py "$@"
