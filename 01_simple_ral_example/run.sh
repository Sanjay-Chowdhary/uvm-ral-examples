#!/bin/bash

# Simple UVM RAL Example - Run Script

echo "╔═════════════════════════════════════════╗"
echo "║ Simple UVM RAL Example - Run Script     ║"
echo "╚═════════════════════════════════════════╝"
echo ""

# Compile parameters
COMPILE_FLAGS="-timescale=1ns/1ps +acc -sv"

# Files to compile (in order)
RTL_FILES="\
    rtl/simple_dut.v \
    rtl/apb_if.sv"

SRC_FILES="\
    src/ral_model.sv \
    src/apb_agent.sv \
    src/apb_reg_adapter.sv \
    src/test_env.sv \
    src/simple_test.sv"

TB_FILES="tb/tb_top.sv"

echo "[1/3] Compiling RTL files..."
vlog $COMPILE_FLAGS $RTL_FILES
if [ $? -ne 0 ]; then
    echo "✗ RTL compilation failed!"
    exit 1
fi

echo "[2/3] Compiling UVM RAL model and tests..."
vlog $COMPILE_FLAGS $SRC_FILES
if [ $? -ne 0 ]; then
    echo "✗ UVM compilation failed!"
    exit 1
fi

echo "[3/3] Compiling testbench..."
vlog $COMPILE_FLAGS $TB_FILES
if [ $? -ne 0 ]; then
    echo "✗ Testbench compilation failed!"
    exit 1
fi

echo ""
echo "✓ Compilation successful!"
echo ""

# Run simulation
echo "Running simulation with test: ${UVM_TESTNAME:-test_frontdoor_write_read}"
echo ""

vsim tb_top \
    -c \
    -do "run -all; quit" \
    +UVM_TESTNAME=${UVM_TESTNAME:-test_frontdoor_write_read} \
    -voptargs="+acc" \
    | tee simulation.log

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║ Simulation completed!                      ║"
echo "║ Waveform saved as: wave.vcd                ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo "To view waveform:"
echo "  gtkwave wave.vcd &"
echo ""
echo "Available tests:"
echo "  1. test_frontdoor_write_read          (default)"
echo "  2. test_backdoor_access"
echo "  3. test_compare_frontdoor_backdoor"
echo ""
echo "Run with specific test:"
echo "  UVM_TESTNAME=test_backdoor_access bash run.sh"
echo ""
