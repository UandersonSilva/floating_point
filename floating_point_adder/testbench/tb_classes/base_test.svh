class base_test;
    mailbox #(data_item) data_mbox;
    data_item data_i;
    
    env env_r;

    logic [EXP_WIDTH+MANTISSA_WIDTH:0] previous_out;
    logic previous_overflow, previous_underflow;

    function new();
        data_mbox = new();
        env_r     = new();
    endfunction : new

    task insert_data();
        if(data_i == null)
            $display("%0t [TEST]: No data item inserted.", $time);
        else
            data_mbox.put(data_i);
    endtask : insert_data

    task obtain_data();
        data_mbox.get(data_i);

        previous_out       = data_i.fpa_out;
        previous_overflow  = data_i.overflow_out;
        previous_underflow = data_i.underflow_out;

        ->data_i.done;
    endtask : obtain_data

    virtual task run();
        env_r.data_mbox = data_mbox;
        fork
            env_r.run();
        join_none
    endtask : run
endclass : base_test