// ====================================
// APB Driver and Sequencer
// ====================================

package apb_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // ============ APB TRANSACTION ============
    class apb_transaction extends uvm_object;
        rand logic [7:0]  addr;
        rand logic [7:0]  data;
        rand logic        write;
        logic [7:0]  read_data;

        `uvm_object_utils(apb_transaction)

        function new(string name="apb_transaction");
            super.new(name);
        endfunction

        function string convert2string();
            if (write)
                return $sformatf("APB_WR: addr=0x%02h, data=0x%02h", addr, data);
            else
                return $sformatf("APB_RD: addr=0x%02h, data=0x%02h", addr, read_data);
        endfunction
    endclass

    // ============ APB SEQUENCER ============
    class apb_sequencer extends uvm_sequencer #(apb_transaction);
        `uvm_component_utils(apb_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

    // ============ APB DRIVER ============
    class apb_driver extends uvm_driver #(apb_transaction);
        `uvm_component_utils(apb_driver)

        virtual apb_if apb_vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            if (!uvm_config_db #(virtual apb_if)::get(this, "", "apb_vif", apb_vif))
                `uvm_fatal("APB_DRV", "Failed to get APB interface")
        endfunction

        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                apb_transaction req, rsp;
                
                seq_item_port.get_next_item(req);

                if (req.write) begin
                    drive_write(req.addr, req.data);
                    `uvm_info("APB_DRV", $sformatf("Write: addr=0x%02h, data=0x%02h", req.addr, req.data), UVM_MEDIUM)
                end
                else begin
                    drive_read(req.addr, req.read_data);
                    `uvm_info("APB_DRV", $sformatf("Read: addr=0x%02h, data=0x%02h", req.addr, req.read_data), UVM_MEDIUM)
                end

                rsp = apb_transaction::type_id::create("rsp");
                rsp.copy(req);
                seq_item_port.item_done(rsp);
            end
        endtask

        virtual task drive_write(logic [7:0] addr, logic [7:0] data);
            @(apb_vif.cb);
            apb_vif.cb.psel   <= 1;
            apb_vif.cb.pwrite <= 1;
            apb_vif.cb.paddr  <= addr;
            apb_vif.cb.pwdata <= data;
            @(apb_vif.cb);
            apb_vif.cb.penable <= 1;
            wait(apb_vif.cb.pready);
            @(apb_vif.cb);
            apb_vif.cb.psel    <= 0;
            apb_vif.cb.penable <= 0;
        endtask

        virtual task drive_read(logic [7:0] addr, output logic [7:0] data);
            @(apb_vif.cb);
            apb_vif.cb.psel   <= 1;
            apb_vif.cb.pwrite <= 0;
            apb_vif.cb.paddr  <= addr;
            @(apb_vif.cb);
            apb_vif.cb.penable <= 1;
            wait(apb_vif.cb.pready);
            data = apb_vif.cb.prdata;
            @(apb_vif.cb);
            apb_vif.cb.psel    <= 0;
            apb_vif.cb.penable <= 0;
        endtask
    endclass

endpackage
