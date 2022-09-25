module normalizer #(
        parameter EXP_WIDTH = 8,
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [EXP_WIDTH - 1:0] expoent_in,
        input logic [MANTISSA_WIDTH+1:0] result_in,
        output logic [EXP_WIDTH - 1:0] normal_e_out,
        output logic [MANTISSA_WIDTH:0] normal_m_out
    );

    logic [MANTISSA_WIDTH + 2:0] result;

    always_comb
    begin
        result = {result_in, 1'b0};

        if(result_in[MANTISSA_WIDTH:0] == {(MANTISSA_WIDTH+1){1'b0}})
        begin
            normal_e_out <= {1'b0, {(EXP_WIDTH-1){1'b1}}};
            normal_m_out <= result_in[MANTISSA_WIDTH:0];
        end
        else if(result[MANTISSA_WIDTH+2])
        begin
            result = result >> 1;
            normal_e_out <= expoent_in + 1;
            normal_m_out <= result[MANTISSA_WIDTH:0];
        end
        else
        begin
            for(int i = MANTISSA_WIDTH+1; i>=0; i--)
            begin
                if(result[i])
                begin
                    result = result << MANTISSA_WIDTH+1 - i;
                    normal_e_out <= expoent_in - (MANTISSA_WIDTH+1 - i);
                    normal_m_out <= result[MANTISSA_WIDTH:0];
                    break;
                end
            end
        end 
    end
endmodule