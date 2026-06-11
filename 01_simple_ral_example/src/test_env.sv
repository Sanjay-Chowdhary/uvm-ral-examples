// ====================================
// Test Environment
// ====================================

package test_env_pkg;
    import uvm_pkg::*;
    import ral_pkg::*;
    import apb_agent_pkg::*;
    import apb_adapter_pkg::*;
    `include "uvm_macros.svh"

    class simple_test_env extends uvm_env;
        `uvm_component_utils(simple_test_env)

        simple_reg_block    regmodel;
        apb_sequencer       apb_seq;
        apb_driver          apb_drv;
        apb_reg_adapter     adapter;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            // Create register model
            regmodel = simple_reg_block::type_id::create("regmodel", this);
            regmodel.build();

            // Create APB components
            apb_seq = apb_sequencer::type_id::create("apb_seq", this);
            apb_drv = apb_driver::type_id::create("apb_drv", this);
            adapter = apb_reg_adapter::type_id::create("adapter", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            
            // Connect driver to sequencer
            apb_drv.seq_item_port.connect(apb_seq.seq_item_export);
            
            // Connect APB interface to driver
            if (!uvm_config_db #(virtual apb_if)::get(this, "", "apb_vif", apb_drv.apb_vif))
                `uvm_fatal("simple_test_env", "Failed to get APB interface")

            // Connect register model to APB sequencer
            regmodel.default_map.set_sequencer(apb_seq, adapter);
        endfunction
    endclass

endpackage
