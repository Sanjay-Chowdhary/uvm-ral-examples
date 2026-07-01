# UVM Regression Guide

## Detailed Regression Methodology

### Phase 1: Baseline Creation

The baseline represents the "golden" or "known-good" state of your design.

```bash
# Step 1: Ensure design is stable
git checkout release/v1.0

# Step 2: Create baseline
bash regression/baseline.sh

# Output:
# ✓ Baseline created successfully!
#   Location: results/baseline/
```

Baseline files:
- `test_ral_write_read.ref` - Expected output for write/read test
- `test_ral_backdoor.ref` - Expected backdoor test output
- `test_ral_coverage.ref` - Expected coverage metrics
- `test_ral_stress.ref` - Expected stress test results
- `test_ral_advanced.ref` - Expected advanced test results

### Phase 2: Make Changes

Developer modifies RTL or testbench:

```bash
# Edit RTL
vim rtl/register_block.v

# Or edit testbench
vim tb/test_suite.sv

# Commit changes
git add .
git commit -m "Add new feature or fix bug"
```

### Phase 3: Run Regression

```bash
# Full regression suite
bash regression/run_regression.sh

# Or single test
bash regression/run_single_test.sh test_ral_write_read

# With debug output
bash regression/run_single_test.sh test_ral_write_read +UVM_VERBOSITY=UVM_DEBUG
```

### Phase 4: Analyze Results

```bash
# View dashboard
python3 regression/dashboard.py

# Check specific test log
cat results/logs/test_ral_write_read.log

# Compare against baseline
diff results/baseline/test_ral_write_read.ref results/logs/test_ral_write_read.log
```

## Understanding Test Results

### PASS Result
```
✓ Test 1/5: test_ral_write_read ............... PASS
```
Means:
- All assertions passed
- Output matches baseline
- No UVM errors

### FAIL Result
```
✗ Test 3/5: test_ral_coverage ................ FAIL
  Error log: results/logs/test_ral_coverage.log
```
Means:
- One or more assertions failed
- Output differs from baseline
- UVM errors detected

## Debugging Failures

### Step 1: Check Log File
```bash
cat results/logs/test_ral_coverage.log | grep -i error
```

### Step 2: View Waveform
```bash
gtkwave sim.vcd &
```

### Step 3: Run with Increased Verbosity
```bash
bash regression/run_single_test.sh test_ral_coverage +UVM_VERBOSITY=UVM_FULL
```

### Step 4: Check Changes
```bash
git diff
```

## Common Issues

### Issue 1: Compilation Error
```
✗ Compilation FAILED
```
**Solution:**
```bash
# Check syntax
bash compile.sh 2>&1 | head -20

# Fix SystemVerilog syntax
vim tb/test_suite.sv
```

### Issue 2: Timeout
```
✗ Simulation timeout!
```
**Solution:**
- Increase timeout in tb_top.sv
- Check for infinite loops
- Verify test completes objection

### Issue 3: Coverage Drop
```
✗ Coverage threshold not met
```
**Solution:**
- Add more test stimuli
- Target uncovered code
- Review test_ral_coverage

## Performance Optimization

### Parallel Execution
```bash
# Run tests in parallel
for test in test_ral_*; do
    (bash regression/run_single_test.sh $test) &
done
wait
```

### Coverage Collection
```bash
# Collect and merge coverage
vvp -g2009 sim.vvp +UVM_TESTNAME=test_ral_write_read +coverage
```

## Integration with CI/CD

### Jenkins Pipeline
```bash
# Trigger on commit
cd 03_uvm_regression
bash regression/run_regression.sh
```

### GitHub Actions
```yaml
name: Regression Tests
on: [push]
jobs:
  regression:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: bash 03_uvm_regression/regression/run_regression.sh
```

## Best Practices

✅ Run regression on every commit  
✅ Keep baseline updated quarterly  
✅ Document all failures  
✅ Archive results for trend analysis  
✅ Use parallel execution  
✅ Monitor coverage metrics  
✅ Set realistic timeouts  
✅ Maintain test isolation  

## Metrics to Track

- **Pass Rate**: Percentage of tests passing
- **Coverage**: Code and functional coverage %
- **Execution Time**: Total regression time
- **Trends**: Performance over time
- **Failure Rate**: Regression failures per day

