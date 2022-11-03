class output_monitor;
    transaction_port #(output_transaction) monitor_tp;
    
    function void read(logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpm_out, logic overflow_out, logic underflow_out, logic dbz_out);
        output_transaction t_out;
        t_out = new();

        t_out.fpm_out       = fpm_out;
        t_out.overflow_out  = overflow_out;
        t_out.underflow_out = underflow_out;
        t_out.dbz_out       = dbz_out;

        monitor_tp.write(t_out);
    endfunction : read
endclass : output_monitor