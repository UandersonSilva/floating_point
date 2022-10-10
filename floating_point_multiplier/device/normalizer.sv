module normalizer #(
        parameter EXP_WIDTH = 8,
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [EXP_WIDTH - 1:0] expoent_in,
        input logic [2*(MANTISSA_WIDTH+1) - 1:0] result_in,
        output logic [EXP_WIDTH - 1:0] normal_e_out,
        output logic [MANTISSA_WIDTH:0] normal_m_out,
        output logic overflow_out, underflow_out
    );

    logic [2*(MANTISSA_WIDTH+1)- 1:0] result;
    logic over_under;

    always_latch
    begin
        result = result_in;

        if(result_in == {(2*(MANTISSA_WIDTH+1)){1'b0}})
        begin
            normal_e_out = {(EXP_WIDTH){1'b0}};
            normal_m_out <= result_in[2*(MANTISSA_WIDTH+1)-3:MANTISSA_WIDTH-1];

            over_under = 1'b0;
            overflow_out <= 1'b0;
            underflow_out <= 1'b0;
        end
        else if(result[2*(MANTISSA_WIDTH+1)-1])
        begin
            {over_under, normal_e_out} = expoent_in + 1;
            normal_m_out <= result_in[2*(MANTISSA_WIDTH+1)-2:MANTISSA_WIDTH];

            overflow_out <= over_under;
            underflow_out <= 1'b0;
        end
        else
        begin
            normal_e_out = expoent_in;
            normal_m_out <= result_in[2*(MANTISSA_WIDTH+1)-3:MANTISSA_WIDTH-1];

            over_under = 1'b0;
            overflow_out <= 1'b0;
            underflow_out <= 1'b0;
        end 
    end
endmodule