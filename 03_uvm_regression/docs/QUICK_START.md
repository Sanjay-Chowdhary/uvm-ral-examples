# Quick Start Guide

## 5-Minute Setup

### Step 1: Install Prerequisites
```bash
# Ubuntu/Debian
sudo apt-get install -y iverilog gtkwave python3

# macOS
brew install icarus-verilog gtkwave python3

# CentOS/RHEL
sudo yum install -y iverilog gtkwave python3
```

### Step 2: Clone Repository
```bash
git clone https://github.com/Sanjay-Chowdhary/uvm-ral-examples.git
cd uvm-ral-examples/03_uvm_regression
```

### Step 3: Create Baseline (First Time Only)
```bash
bash regression/baseline.sh

# Output:
# ✓ Baseline created successfully!
#   Location: results/baseline/
```

### Step 4: Run Regression
```bash
bash regression/run_regression.sh

# Output:
# ✓ ALL TESTS PASSED!
```

### Step 5: View Results
```bash
python3 regression/dashboard.py

# Interactive dashboard appears
```

## Running Individual Tests

```bash
# Quick test
bash run.sh

# Specific test
bash regression/run_single_test.sh test_ral_write_read

# With debug output
bash regression/run_single_test.sh test_ral_backdoor +UVM_VERBOSITY=UVM_DEBUG
```

## Typical Workflow

1. **Make change to RTL or TB**
   ```bash
   vim rtl/register_block.v
   ```

2. **Run regression**
   ```bash
   bash regression/run_regression.sh
   ```

3. **Check results**
   ```bash
   python3 regression/dashboard.py
   ```

4. **Debug if needed**
   ```bash
   cat results/logs/test_name.log
   gtkwave sim.vcd &
   ```

5. **Commit changes**
   ```bash
   git add -A
   git commit -m "Fixed XYZ feature"
   ```

## Directory Navigation

- **RTL**: `rtl/` - Design Under Test
- **Testbench**: `tb/` - UVM environment and tests
- **Regression Scripts**: `regression/` - Automated test runners
- **Results**: `results/` - Test outputs and logs
- **CI/CD**: `ci/` - Jenkins and automation
- **Documentation**: `docs/` - Detailed guides

## Quick Commands

```bash
# Compile only
bash compile.sh

# Run full suite
bash regression/run_regression.sh

# Create new baseline
bash regression/baseline.sh

# View dashboard
python3 regression/dashboard.py

# Check specific test
cat results/logs/test_ral_write_read.log

# View waveforms
gtkwave sim.vcd &

# Clean up
rm -rf results/ *.vvp sim.vcd
```

## Troubleshooting

### "Command not found: iverilog"
→ Install Icarus Verilog

### "ModuleNotFoundError: No module named 'uvm'"
→ SystemVerilog simulator includes UVM automatically

### "Compilation failed"
→ Check `bash compile.sh 2>&1 | head -20`

### "All tests timeout"
→ Increase timeout in `tb/tb_top.sv`

## Next Steps

1. ✅ Read `REGRESSION_GUIDE.md` for detailed methodology
2. ✅ Read `UVM_BASICS.md` for UVM concepts
3. ✅ Add your own tests in `tb/test_suite.sv`
4. ✅ Set up Jenkins CI/CD (see `ci/Jenkinsfile`)
5. ✅ Integrate with Slack notifications

