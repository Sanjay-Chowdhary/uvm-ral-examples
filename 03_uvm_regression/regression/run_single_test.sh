#!/bin/bash

# ====================================
# Single Test Runner
# ====================================

if [ $# -eq 0 ]; then
    echo "Usage: bash run_single_test.sh <test_name> [additional_args]"
    echo "Example: bash run_single_test.sh test_ral_write_read +UVM_VERBOSITY=UVM_DEBUG"
    exit 1
fi

TEST_NAME=$1
shift
ADDITIONAL_ARGS="$@"

echo "Running: $TEST_NAME"

vvp -g2009 sim.vvp +UVM_TESTNAME="$TEST_NAME" $ADDITIONAL_ARGS > /tmp/test_run.log 2>&1

RESULT=$?

if grep -q "All tests completed" /tmp/test_run.log 2>/dev/null; then
    exit 0
else
    cat /tmp/test_run.log
    exit 1
fi
