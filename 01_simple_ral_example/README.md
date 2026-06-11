# Simple UVM RAL Example - Front Door & Back Door Access

This is a beginner-friendly UVM RAL example that demonstrates:
- Simple RTL register design
- UVM RAL register model
- Front door access (via APB protocol)
- Back door access (direct RTL access)
- Simple verification

## Directory Structure

```
01_simple_ral_example/
├── rtl/
│   ├── simple_dut.v          # Simple register DUT
│   └── apb_if.sv             # APB interface
├── src/
│   ├── ral_model.sv          # UVM RAL register model
│   ├── apb_agent.sv          # APB driver & sequencer
│   ├── test_env.sv           # Test environment
│   └── simple_test.sv        # Simple test cases
├── tb/
│   └── tb_top.sv             # Top-level testbench
├── run.sh                     # Run script
└── README.md
```

## Quick Start

```bash
cd 01_simple_ral_example
bash run.sh
```

## Files Description

### RTL (rtl/)
- **simple_dut.v**: Contains 3 simple 8-bit registers (CONTROL, STATUS, DATA)
- **apb_if.sv**: APB protocol interface definition

### RAL Model (src/)
- **ral_model.sv**: Defines register blocks, fields, and RAL structure
- **apb_agent.sv**: APB driver to execute register transactions
- **test_env.sv**: UVM environment that connects RAL model to APB agent
- **simple_test.sv**: Test cases demonstrating:
  - Frontdoor write/read
  - Backdoor write/read
  - Mirror checking
  - Value verification

## Test Cases

### test_frontdoor_write_read
- Writes value via APB (frontdoor)
- Reads value via APB (frontdoor)
- Verifies mirror matches DUT

### test_backdoor_access
- Writes value directly to RTL (backdoor)
- Updates RAL mirror using predict()
- Reads and verifies

### test_compare_frontdoor_backdoor
- Writes via frontdoor
- Reads via backdoor
- Compares both values

## Waveform

Simulation generates `wave.vcd` which can be viewed in GTKWave:

```bash
gtkwave wave.vcd &
```

## Learn

Key concepts covered:
1. Register model definition
2. Field configuration
3. Frontdoor access patterns
4. Backdoor access patterns
5. Mirror synchronization
6. Value verification
