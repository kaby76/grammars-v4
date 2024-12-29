#!/bin/sh

# set up environment.
OIFS="$IFS"
IFS=$'\n'
git checkout https://github.com/antlr/grammars-v4.git
cd grammars-v4
dotnet tool restore
dotnet tool update --local --all

# set up trees from Java parse.
bash _scripts/test.sh -t Java

# commit .tree's.
for i in `find . -name '*.tree'`; do echo "$i"; git add "$i"; done
git commit -m "Add trees"

# re-test using specific target
target=CSharp
bash _scripts/test.sh -t $target
