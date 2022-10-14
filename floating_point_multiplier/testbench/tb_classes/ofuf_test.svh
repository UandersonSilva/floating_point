class ofuf_test extends base_test;
    task run;
        super.run();
      
        repeat(5)//overflow
        begin            
            data_i = new();

            data_i.a_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(160, 230);
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            data_i.b_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(180, 230);
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            
            super.insert_data();

            @(data_i.done);

            super.obtain_data();
        end

        repeat(5)//underflow
        begin            
            data_i = new();

            data_i.a_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(10, 60);
            data_i.a_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            data_i.b_in[MANTISSA_WIDTH - 1:0] = $urandom;
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = $urandom_range(10, 60);
            data_i.b_in[EXP_WIDTH+MANTISSA_WIDTH] = $urandom;
            
            super.insert_data();

            @(data_i.done);

            super.obtain_data();
        end
    endtask : run
endclass : ofuf_test