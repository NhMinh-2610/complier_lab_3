#!/bin/sh
# Simple runner for kplc across example tests.
set -eu

LAB_DIR="../incompleted_lab3b"
BIN="$LAB_DIR/kplc"

if [ ! -x "$BIN" ]; then
  echo "kplc not built yet. Run: (cd $LAB_DIR && make)" >&2
  exit 1
fi

fail=0
for i in 1 2 3 4 5 6; do
  in_file="example${i}.kpl"
  expect_file="result${i}.txt"
  echo "--- Test ${i}: $in_file" 
  if [ ! -f "$in_file" ]; then
    echo "Missing input $in_file" >&2
    fail=1
    continue
  fi
  if [ ! -f "$expect_file" ]; then
    echo "Missing expected $expect_file" >&2
    fail=1
    continue
  fi

  # Run compiler and compare with expected result.
  if ! "$BIN" "$in_file" | diff -u "$expect_file" -; then
    echo "Result: FAIL"
    fail=1
  else
    echo "Result: PASS"
  fi
  echo
done

if [ "$fail" -ne 0 ]; then
  echo "Some tests failed." >&2
  exit 1
fi

echo "All tests passed." 
