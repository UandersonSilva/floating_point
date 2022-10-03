class fibonacci_test extends base_test;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] previous_in;

    task run;
        super.run();

        data_i = new();
        data_i.a_in = $shortrealtobits(0.0);
        data_i.b_in = $shortrealtobits(1.0);
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        while($bitstoshortreal(previous_out) < 90.0)
        begin
            previous_in = data_i.b_in;
            
            data_i = new();
            data_i.a_in = previous_in;
            data_i.b_in = previous_out;

            super.insert_data();
      
            @(data_i.done);

            super.obtain_data();
        end
    endtask : run
endclass : fibonacci_test