class factorial_test extends base_test;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] previous_in;

    task run;
        super.run();

        data_i = new();
        data_i.a_in = $shortrealtobits(1.0);
        data_i.b_in = $shortrealtobits(1.0);
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        previous_in = $shortrealtobits(1.0);

        while($bitstoshortreal(previous_in) < 10.0)
        begin
            previous_in = $shortrealtobits($bitstoshortreal(previous_in) + 1.0);
            
            data_i = new();
            data_i.a_in = previous_in;
            data_i.b_in = previous_out;

            super.insert_data();
      
            @(data_i.done);

            super.obtain_data();
        end
    endtask : run
endclass : factorial_test