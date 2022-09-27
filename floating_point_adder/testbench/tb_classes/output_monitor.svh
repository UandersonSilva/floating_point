class output_monitor;
    transaction_port #(output_transaction) monitor_tp;
    
    function void read(logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpa_out, logic overflow_out, logic underflow_out);
        output_transaction t_out;
        t_out = new();

        t_out.fpa_out       = fpa_out;
        t_out.overflow_out  = overflow_out;
        t_out.underflow_out = underflow_out;

        monitor_tp.write(t_out);
    endfunction : read
endclass : output_monitor