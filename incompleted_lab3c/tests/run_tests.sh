#!/bin/bash
# Test runner for lab3c - semantic analysis
# Run all test cases and report PASS/FAIL with colored output

cd "$(dirname "$0")"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BIN="../incompleted/kplc"

# Check if binary exists
if [ ! -x "$BIN" ]; then
  echo -e "${RED}Error: kplc not found or not executable${NC}"
  echo "Run: cd ../incompleted && make"
  exit 1
fi

echo "========================================="
echo "   Lab3c Semantic Analysis Test Suite"
echo "========================================="
echo

passed=0
failed=0
total=6

for i in 1 2 3 4 5 6; do
  test_file="example${i}.kpl"
  expect_file="result${i}.txt"
  
  echo -n "Test ${i} (${test_file})... "
  
  if [ ! -f "$test_file" ]; then
    echo -e "${RED}SKIP${NC} (input file missing)"
    continue
  fi
  
  if [ ! -f "$expect_file" ]; then
    echo -e "${RED}SKIP${NC} (expected result missing)"
    continue
  fi
  
  # Run the compiler and capture output
  actual_output=$("$BIN" "$test_file" 2>&1)
  expected_output=$(cat "$expect_file")
  
  # Compare outputs
  if diff -q <(echo "$actual_output") <(echo "$expected_output") > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((passed++))
  else
    echo -e "${RED}✗ FAIL${NC}"
    ((failed++))
    echo "  Expected:"
    echo "$expected_output" | head -5 | sed 's/^/    /'
    if [ $(echo "$expected_output" | wc -l) -gt 5 ]; then
      echo "    ..."
    fi
    echo "  Got:"
    echo "$actual_output" | head -5 | sed 's/^/    /'
    if [ $(echo "$actual_output" | wc -l) -gt 5 ]; then
      echo "    ..."
    fi
    echo
  fi
done

echo
echo "========================================="
echo -e "Results: ${GREEN}${passed} passed${NC}, ${RED}${failed} failed${NC} out of ${total}"
echo "========================================="

if [ $failed -eq 0 ]; then
  echo -e "${GREEN}All tests passed! ✓${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed.${NC}"
  exit 1
fi
