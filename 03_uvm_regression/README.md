# UVM-Based Regression Testing for VLSI Design

A comprehensive example demonstrating UVM-based regression testing with complete test infrastructure, CI/CD integration, and regression management.

## 📚 Project Overview

This example covers:
- ✅ UVM Register Model (RAL) with multiple registers
- ✅ Comprehensive UVM testbench environment
- ✅ Multiple test cases with different scenarios
- ✅ Automated regression suite
- ✅ Coverage tracking
- ✅ Regression dashboard and reporting
- ✅ Jenkins CI/CD pipeline
- ✅ Python-based regression management

## 📁 Directory Structure

```
03_uvm_regression/
├── rtl/
│   ├── register_block.v        # Design Under Test (DUT)
│   ├── apb_if.sv               # APB Interface
│   └── simple_dut.v            # Simple ALU for examples
├── tb/
│   ├── ral_model.sv            # UVM RAL Model
│   ├── uvm_env.sv              # UVM Environment
│   ├── test_base.sv            # Base test class
│   ├── test_suite.sv           # All test cases
│   └── tb_top.sv               # Top-level testbench
├── regression/
│   ├── run_regression.sh       # Main regression script
│   ├── run_single_test.sh      # Single test runner
│   ├── baseline.sh             # Create baseline
│   ├── compare.py              # Result comparison
│   └── dashboard.py            # Regression dashboard
├── ci/
│   ├── Jenkinsfile             # Jenkins pipeline
│   ├── jenkins_setup.sh        # Jenkins configuration
│   └── slack_notify.py         # Slack notifications
├── results/
│   ├── baseline/               # Golden reference results
│   ├── current/                # Current test results
│   ├── logs/                   # Test logs
│   └── reports/                # HTML/JSON reports
├── docs/
│   ├── REGRESSION_GUIDE.md     # Detailed guide
│   ├── UVM_BASICS.md           # UVM concepts
│   └── QUICK_START.md          # Getting started
├── compile.sh                  # Compile script
├── run.sh                       # Quick run script
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites
```bash
# Install UVM
git clone https://github.com/accellera/uvm.git

# Install simulator (choose one)
# - VCS (commercial)
# - ModelSim (commercial)
# - Icarus Verilog + ghdl (free)

# Install Python tools
pip install -r requirements.txt
```

### Run First Regression
```bash
# Navigate to project
cd 03_uvm_regression

# Create baseline (first time only)
bash regression/baseline.sh

# Run regression suite
bash regression/run_regression.sh

# View results
python regression/dashboard.py
```

## 📊 Test Hierarchy

```
Base Test
├── test_ral_write_read
│   ├── test_control_write
│   ├── test_status_read
│   └── test_data_operations
├── test_ral_backdoor
│   ├── test_backdoor_write
│   └── test_backdoor_read
├── test_ral_coverage
│   ├── test_field_coverage
│   └── test_register_coverage
├── test_ral_stress
│   ├── test_random_operations
│   └── test_heavy_load
└── test_ral_advanced
    ├── test_mirror_check
    └── test_cross_operations
```

## 🔄 Regression Workflow

### Phase 1: Baseline Creation
```bash
# Run on known-good design
bash regression/baseline.sh

# Output:
# ✓ Baseline created
# ✓ Results saved to baseline/
# ✓ Coverage metrics stored
```

### Phase 2: Change Implementation
Designer makes RTL or testbench changes

### Phase 3: Automated Regression
```bash
# Run full regression suite
bash regression/run_regression.sh

# Output:
# Test 1/8: test_ral_write_read ............... PASS
# Test 2/8: test_ral_backdoor ................ PASS
# Test 3/8: test_ral_coverage ............... FAIL ❌
# ...
```

### Phase 4: Results Analysis
```bash
# Generate comparison report
python regression/compare.py

# Output:
# ═══════════════════════════════════════════
# Regression Results
# ═══════════════════════════════════════════
# Total Tests:      8
# Passed:           7 ✓
# Failed:           1 ❌
# Success Rate:     87.5%
```

## 🧪 Test Cases Explained

### 1. test_ral_write_read
**Purpose:** Verify basic RAL write/read operations
```
Write → Read → Compare against Mirror
```
**Scenario:**
- Write to CONTROL register (0x0)
- Read back value
- Verify mirror matches DUT

### 2. test_ral_backdoor
**Purpose:** Test backdoor access and mirror synchronization
```
Backdoor Write → predict() → Backdoor Read → Verify
```
**Scenario:**
- Direct write to RTL register
- Update RAL mirror
- Read and verify

### 3. test_ral_coverage
**Purpose:** Ensure code coverage metrics
```
Run Stimulus → Collect Coverage → Compare Baseline
```
**Scenario:**
- Functional coverage
- Code coverage
- Cross coverage

### 4. test_ral_stress
**Purpose:** Random stress testing
```
Random Operations × 1000 → Check for Errors
```
**Scenario:**
- Random register accesses
- Random operation sequences
- Concurrent operations

### 5. test_ral_advanced
**Purpose:** Complex register interactions
```
Control Register Affects Status Register
```
**Scenario:**
- Dependent register operations
- Field interactions
- Cross-register synchronization

## 📈 Regression Dashboard

```bash
$ python regression/dashboard.py

╔════════════════════════════════════════════════════════════╗
║            UVM REGRESSION TEST DASHBOARD                  ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  SUMMARY                                                   ║
║  ────────────────────────────────────────────────────────  ║
║  Total Tests:        8                                    ║
║  Passed:             7 ✓  (87.5%)                         ║
║  Failed:             1 ❌ (12.5%)                         ║
║  Skipped:            0                                    ║
║  Duration:           124.3 seconds                        ║
║                                                            ║
║  COVERAGE                                                  ║
║  ────────────────────────────────────────────────────────  ║
║  Code Coverage:      92.5% (↑ 1.2%)                       ║
║  Functional:         88.3% (→ same)                       ║
║  Cross Coverage:     76.5% (↓ 2.1%)                       ║
║                                                            ║
║  LAST 5 RUNS                                               ║
║  ────────────────────────────────────────────────────────  ║
║  2024-01-15 14:23  8/8 PASS    Coverage: 92.5%            ║
║  2024-01-15 13:45  8/8 PASS    Coverage: 92.4%            ║
║  2024-01-15 12:10  7/8 FAIL    Coverage: 91.2%            ║
║  2024-01-15 11:30  8/8 PASS    Coverage: 92.1%            ║
║  2024-01-15 10:15  6/8 FAIL    Coverage: 85.3%            ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

## 🔧 Configuration Files

### regression_config.yaml
```yaml
# Regression Configuration

design:
  name: "UVM_Register_Block"
  version: "1.0"
  rtl_path: "rtl/"
  tb_path: "tb/"

simulator:
  tool: "vcs"  # vcs, modelsim, xcelium
  threads: 4
  timeout: 300  # seconds

tests:
  - test_ral_write_read
  - test_ral_backdoor
  - test_ral_coverage
  - test_ral_stress
  - test_ral_advanced

coverage:
  track: true
  merge: true
  threshold: 80  # Minimum coverage %

reporting:
  format: "html"  # html, json, text
  email: "team@company.com"
  slack_webhook: "https://hooks.slack.com/..."
```

## 🔗 Jenkins CI/CD Pipeline

### Automated Workflow
```
Git Commit
    ↓
[Trigger Jenkins Job]
    ↓
[Checkout Code]
    ↓
[Run Regression]
    ↓
[Collect Results]
    ↓
[Generate Report]
    ↓
[Notify Team] (Email/Slack)
    ↓
Done
```

### Jenkinsfile Example
```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Compile') {
            steps {
                sh 'bash compile.sh'
            }
        }
        
        stage('Regression') {
            steps {
                sh 'bash regression/run_regression.sh'
            }
        }
        
        stage('Report') {
            steps {
                sh 'python regression/dashboard.py'
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'results/reports',
                    reportFiles: 'report.html',
                    reportName: 'Regression Report'
                ])
            }
        }
        
        stage('Notify') {
            steps {
                sh 'python ci/slack_notify.py'
            }
        }
    }
    
    post {
        failure {
            mail to: 'team@company.com',
                 subject: 'Regression FAILED',
                 body: 'Check Jenkins console'
        }
    }
}
```

## 📊 Result Formats

### JSON Report
```json
{
  "timestamp": "2024-01-15T14:23:45Z",
  "design": "UVM_Register_Block",
  "version": "1.0",
  "summary": {
    "total": 8,
    "passed": 7,
    "failed": 1,
    "skipped": 0,
    "pass_rate": 87.5
  },
  "coverage": {
    "code": 92.5,
    "functional": 88.3,
    "cross": 76.5
  },
  "tests": [
    {
      "name": "test_ral_write_read",
      "status": "PASS",
      "duration": 12.3,
      "assertions": 45,
      "errors": 0
    },
    {
      "name": "test_ral_coverage",
      "status": "FAIL",
      "duration": 15.8,
      "assertions": 38,
      "errors": 1,
      "error_msg": "Coverage threshold not met"
    }
  ]
}
```

## 🔍 Debugging Failures

### When Regression Fails

1. **Check Logs**
   ```bash
   cat results/logs/test_name.log
   ```

2. **View Waveform**
   ```bash
   gtkwave results/logs/test_name.vcd &
   ```

3. **Compare Output**
   ```bash
   diff baseline/test_name.ref current/test_name.log
   ```

4. **Run Single Test with Verbose**
   ```bash
   bash regression/run_single_test.sh test_name +UVM_VERBOSITY=UVM_DEBUG
   ```

## 📈 Performance Metrics

```
Test Execution Time Trends

test_ral_write_read:    12.3s → 12.1s → 12.4s (stable)
test_ral_backdoor:      14.5s → 14.2s → 13.9s (improving)
test_ral_coverage:      18.7s → 22.1s → 24.3s (degrading ⚠️)
test_ral_stress:        45.2s → 46.8s → 47.3s (stable)
test_ral_advanced:      16.8s → 17.2s → 17.1s (stable)

Total Time: 107.5s → 112.4s → 115.1s
```

## 🎯 Best Practices

✅ **Run regression on every commit**  
✅ **Maintain >80% code coverage**  
✅ **Keep test execution time <2 hours**  
✅ **Archive baseline for each version**  
✅ **Document all test failures**  
✅ **Review coverage trends**  
✅ **Automate with CI/CD**  
✅ **Notify team on failures**  

## 📚 Learn More

See individual documents:
- `docs/REGRESSION_GUIDE.md` - Detailed regression methodology
- `docs/UVM_BASICS.md` - UVM concepts and RAL
- `docs/QUICK_START.md` - Step-by-step setup guide

## 🤝 Contributing

To add new tests:
1. Create test in `tb/test_suite.sv`
2. Add to regression list in `regression_config.yaml`
3. Update `REGRESSION_GUIDE.md`
4. Run `bash regression/run_regression.sh`

## 📝 License

Open source - Free to use and modify

## 👨‍💻 Author

Sanjay Chowdhary - VLSI Design & Verification

---

**Next Steps:**
1. Review `QUICK_START.md` for detailed setup
2. Run `bash compile.sh` to set up environment
3. Execute `bash regression/run_regression.sh`
4. Check `results/reports/report.html` for results

Happy Regressing! 🚀
