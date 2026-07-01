#!/bin/bash

# ====================================
# Quick Run Script
# ====================================

echo "╔══════════════════════════════════╗"
echo "║ UVM Regression Quick Start        ║"
echo "╚══════════════════════════════════╝"
echo ""

echo "Running: test_ral_write_read"
echo ""

bash compile.sh || exit 1

vvp -g2009 sim.vvp +UVM_TESTNAME=test_ral_write_read

echo ""
echo "✓ Test completed!"
