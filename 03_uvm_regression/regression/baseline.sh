#!/bin/bash

# ====================================
# Create Baseline
# ====================================

echo "╔══════════════════════════════════╗"
echo "║ Creating Baseline                ║"
echo "╚══════════════════════════════════╝"
echo ""

BASELINE_DIR="results/baseline"
mkdir -p $BASELINE_DIR

echo "[1/2] Compiling..."
bash compile.sh > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Compilation FAILED"
    exit 1
fi
echo "✓ Compilation successful"

echo "[2/2] Running baseline tests..."

TESTS=(
    "test_ral_write_read"
    "test_ral_backdoor"
    "test_ral_coverage"
    "test_ral_stress"
    "test_ral_advanced"
)

for test in "${TESTS[@]}"; do
    echo "  - $test"
    bash regression/run_single_test.sh "$test" > "$BASELINE_DIR/$test.ref" 2>&1
done

echo ""
echo "✓ Baseline created successfully!"
echo "  Location: $BASELINE_DIR/"
echo ""
