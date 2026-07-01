# UVM Basics

## What is UVM?

The Universal Verification Methodology (UVM) is a standardized approach to writing testbenches in SystemVerilog.

## Key Components

### 1. Test
Top-level component that orchestrates the testbench
```systemverilog
class my_test extends uvm_test;
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // Test logic here
        phase.drop_objection(this);
    endtask
endclass
```

### 2. Environment
Contains agents and scoreboards
```systemverilog
class my_env extends uvm_env;
    my_agent agent;
    
    virtual function void build_phase(uvm_phase phase);
        agent = my_agent::type_id::create("agent", this);
    endfunction
endclass
```

### 3. Agent
Provides stimulus and monitors response
```systemverilog
class my_agent extends uvm_agent;
    my_sequencer sequencer;
    my_driver driver;
    
    virtual function void build_phase(uvm_phase phase);
        sequencer = my_sequencer::type_id::create("sequencer", this);
        driver = my_driver::type_id::create("driver", this);
    endfunction
endclass
```

### 4. Register Abstraction Layer (RAL)
Abstract model of registers
```systemverilog
class my_register extends uvm_reg;
    rand uvm_reg_field field1;
    
    virtual function void build();
        field1 = uvm_reg_field::type_id::create("field1");
        field1.configure(this, 8, 0, "RW", 0, 8'b0, 1, 0);
    endfunction
endclass
```

## UVM Phases

1. **build_phase** - Create components
2. **connect_phase** - Connect components
3. **run_phase** - Run tests
4. **extract_phase** - Extract coverage
5. **check_phase** - Final checks

## Common UVM Macros

```systemverilog
`uvm_object_utils       // Factory registration
`uvm_component_utils    // Component factory
`uvm_info               // Print info message
`uvm_warning            // Print warning
`uvm_error              // Print error
`uvm_fatal              // Print fatal error
```

## RAL Operations

### Write
```systemverilog
reg.write(status, 32'hDEAD_BEEF);
```

### Read
```systemverilog
reg.read(status, rdata);
```

### Backdoor Access
```systemverilog
uvm_hdl_deposit("path.to.signal", value);
uvm_hdl_read("path.to.signal", value);
```

### Predict
```systemverilog
reg.predict(value, .path(UVM_BACKDOOR));
```

