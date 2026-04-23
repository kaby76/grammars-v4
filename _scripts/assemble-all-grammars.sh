#!/usr/bin/env bash
# Build all grammars and combine their JARs into one fat JAR at
# target/all-grammars-1.0-SNAPSHOT.jar.
# Run from the repo root.
set -euo pipefail

echo "Building all grammars..."
mvn -B clean test package -Pgrammarv4

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Collecting compiled grammar JARs..."
while IFS= read -r jar; do
    abs=$(realpath "$jar")
    (cd "$TMPDIR" && jar xf "$abs")
done < <(find . -path "*/target/*.jar" \
    ! -name "*-sources.jar" \
    ! -name "*-javadoc.jar" \
    ! -name "*-tests.jar" \
    ! -name "*-test-sources.jar" \
    ! -path "./target/*")

mkdir -p target
OUTPUT="target/all-grammars-1.0-SNAPSHOT.jar"
echo "Assembling $OUTPUT ..."
jar cf "$OUTPUT" -C "$TMPDIR" .
echo "Done: $OUTPUT"
