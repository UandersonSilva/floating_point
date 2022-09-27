class input_monitor;
    transaction_port #(input_transaction) monitor_tp;

    function void read(logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, logic [EXP_WIDTH+MANTISSA_WIDTH:0] b_in);
        input_transaction t_in;
        t_in = new();

        t_in.a_in = a_in;
        t_in.b_in = b_in;

        monitor_tp.write(t_in);
    endfunction : read
endclass : input_monitor