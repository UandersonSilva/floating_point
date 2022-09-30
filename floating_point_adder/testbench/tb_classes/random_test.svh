class random_test extends base_test;
    task run;
        super.run();
      
        repeat(9)
        begin            
            data_i = new();

            data_i.a_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(110, 130);
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            data_i.b_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(110, 130);
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            
            super.insert_data();

            @(data_i.done);

            super.obtain_data();
        end
    endtask : run
endclass : random_test