#!/bin/bash

# ====================================
# Regression Test Runner
# ====================================

set -e

echo "╔══════════════════════════════════╗"
echo "║ UVM Regression Test Suite         ║"
echo "╚══════════════════════════════════╝"
echo ""

# Configuration
BASELINE_DIR="results/baseline"
CURRENT_DIR="results/current"
LOGS_DIR="results/logs"
REPORTS_DIR="results/reports"

TESTS=(
    "test_ral_write_read"
    "test_ral_backdoor"
    "test_ral_coverage"
    "test_ral_stress"
    "test_ral_advanced"
)

PASSED=0
FAILED=0
START_TIME=$(date +%s)

# Create directories
mkdir -p $BASELINE_DIR $CURRENT_DIR $LOGS_DIR $REPORTS_DIR

echo "[1/3] Compiling..."
bash compile.sh > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Compilation FAILED"
    exit 1
fi
echo "✓ Compilation successful"
echo ""

echo "[2/3] Running tests..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for i in "${!TESTS[@]}"; do
    test=${TESTS[$i]}
    test_num=$((i + 1))
    total=${#TESTS[@]}
    
    printf "Test %d/%d: %-30s " $test_num $total "$test"
    
    # Run test
    bash regression/run_single_test.sh "$test" > "$LOGS_DIR/$test.log" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✓ PASS"
        ((PASSED++))
    else
        echo "✗ FAIL"
        ((FAILED++))
        echo "  Error log: $LOGS_DIR/$test.log"
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "[3/3] Generating report..."
python regression/compare.py > $REPORTS_DIR/comparison.txt 2>&1

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "╔══════════════════════════════════╗"
echo "║ Summary                           ║"
echo "╞══════════════════════════════════╠"
echo "║ Total Tests:   ${#TESTS[@]}                          ║"
echo "║ Passed:        $PASSED ✓                           ║"
echo "║ Failed:        $FAILED ✗                           ║"
echo "║ Duration:      ${DURATION}s                       ║"
echo "║ Report:        $REPORTS_DIR/comparison.txt      ║"
echo "╚══════════════════════════════════╝"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✅ ALL TESTS PASSED!"
    exit 0
else
    echo "❌ SOME TESTS FAILED"
    exit 1
fi
