#!/bin/bash

# Jenkins Setup Script

echo "Setting up Jenkins environment..."

# Check for required tools
command -v vvp >/dev/null 2>&1 || { echo "Icarus Verilog not found"; }
command -v python3 >/dev/null 2>&1 || { echo "Python3 not found"; }

echo "Environment setup complete"
