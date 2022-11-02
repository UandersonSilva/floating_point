module ofuf_checker #(
        parameter EXP_WIDTH = 8
    )(
        input logic [EXP_WIDTH-1:0] a_exp_in, b_exp_in, exp_sum_in,
        output logic overflow_out, underflow_out
    );

    always_comb
    begin
        if((a_exp_in == {EXP_WIDTH{1'b0}}) && (b_exp_in == {EXP_WIDTH{1'b0}}))
        begin
            overflow_out <= 1'b0;
            underflow_out <= 1'b0;
        end
        else if((a_exp_in > {1'b0, {(EXP_WIDTH-1){1'b1}}} && b_exp_in < {1'b0, {(EXP_WIDTH-1){1'b1}}}) 
                && (exp_sum_in < {1'b0, {(EXP_WIDTH-1){1'b1}}}))
        begin
            overflow_out <= 1'b1;
            underflow_out <= 1'b0;
        end
        else if((a_exp_in < {1'b0, {(EXP_WIDTH-1){1'b1}}} && b_exp_in > {1'b0, {(EXP_WIDTH-1){1'b1}}}) 
                && (exp_sum_in > {1'b1, {(EXP_WIDTH-1){1'b0}}}))
        begin
            overflow_out <= 1'b0;
            underflow_out <= 1'b1;
        end
        else
        begin
            overflow_out <= 1'b0;
            underflow_out <= 1'b0;
        end
    end
endmodule