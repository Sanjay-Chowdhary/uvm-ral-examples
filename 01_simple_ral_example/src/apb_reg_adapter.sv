// ====================================
// APB Register Adapter
// ====================================

package apb_adapter_pkg;
    import uvm_pkg::*;
    import apb_agent_pkg::*;
    `include "uvm_macros.svh"

    class apb_reg_adapter extends uvm_reg_adapter;
        `uvm_object_utils(apb_reg_adapter)

        function new(string name="apb_reg_adapter");
            super.new(name);
            provides_responses = 1;
        endfunction

        // Convert UVM register transaction to APB transaction
        virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
            apb_transaction apb = apb_transaction::type_id::create("apb");
            apb.addr = rw.addr;
            apb.data = rw.data;
            apb.write = (rw.kind == UVM_WRITE) ? 1 : 0;
            return apb;
        endfunction

        // Convert APB transaction to UVM register transaction
        virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
            apb_transaction apb;
            if (!$cast(apb, bus_item))
                `uvm_fatal("apb_reg_adapter", "Failed to cast to apb_transaction")
            rw.data = apb.read_data;
            rw.status = UVM_IS_OK;
        endfunction
    endclass

endpackage
