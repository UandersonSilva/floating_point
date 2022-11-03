class scoreboard;
    transaction_port #(input_transaction) scoreboard_tp_in;
    transaction_port #(output_transaction) scoreboard_tp_out;

    event input_read;
    event output_read;

    task run();
        input_transaction  t_in;
        output_transaction t_out, predicted;
        shortreal out_real;

        integer exp_sub;

        forever 
        begin
            predicted = new();

            @(input_read);
            scoreboard_tp_in.read(t_in);

            if(t_in == null)
                $display("%0t [SCOREBOARD]: No input transaction. Null pointer.", $time);
            else
            begin
                out_real = $bitstoshortreal(t_in.a_in) / $bitstoshortreal(t_in.b_in);

                predicted.fpm_out = $shortrealtobits(out_real);

                exp_sub = t_in.a_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH] - t_in.b_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH];
                //$display("%0t [SCOREBOARD]: %d", $time, exp_sub);

                if((t_in.a_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH] == 0) && (t_in.b_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH] == 0))
                begin
                    predicted.overflow_out = 0;
                    predicted.underflow_out = 0;
                end

                else if(exp_sub > 128)
                begin
                    predicted.overflow_out = 1;
                    predicted.underflow_out = 0;
                end
                
                else if(exp_sub < -128)
                begin
                    predicted.overflow_out = 0;
                    predicted.underflow_out = 1;
                end

                else
                begin
                    predicted.overflow_out = 0;
                    predicted.underflow_out = 0;
                end

                $display("%0t", $time, {" [SCOREBOARD]: INPUT:: ", t_in.convert2string()});

                if(t_in.b_in == 0)
                    predicted.dbz_out = 1'b1;
                else
                    predicted.dbz_out = 1'b0;
            end

            @(output_read);
            scoreboard_tp_out.read(t_out);

            if(t_out == null)
                $display("%0t [SCOREBOARD]: No output transaction. Null pointer.", $time);
            else
            begin
                if(predicted.compare(t_out))
                begin
                    //$write("%c[2;34m",27);//blue
                    $display("%c[2;34m", 27, "%0t", $time, {" [SCOREBOARD]: PASS:: ", t_out.convert2string(), " || Predicted => ", predicted.convert2string()});
                    $write("%c[2;0m",27);//standard color
                end
                else
                begin
                    //$display("%c[2;31m",27);//red
                    $display("%c[2;31m", 27, "%0t", $time, {" [SCOREBOARD]: FAIL:: ", t_out.convert2string(), " || Predicted => ", predicted.convert2string()});
                    $write("%c[2;0m",27);//standard color
                end
            end
        end
    endtask : run
endclass : scoreboard