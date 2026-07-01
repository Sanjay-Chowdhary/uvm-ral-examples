#!/bin/bash

# ====================================
# Compile Script
# ====================================

echo "[Compile] Starting compilation..."

RTL_FILES="rtl/register_block.v rtl/apb_if.sv"
TB_FILES="tb/ral_model.sv tb/test_base.sv tb/test_suite.sv tb/tb_top.sv"

echo "Compiling RTL..."
iverilog -g2009 $RTL_FILES $TB_FILES -o sim.vvp 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
    exit 0
else
    echo "✗ Compilation failed"
    exit 1
fi
