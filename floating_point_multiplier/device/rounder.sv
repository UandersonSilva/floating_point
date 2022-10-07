module rounder #(
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [MANTISSA_WIDTH:0] normal_m_in,
        output logic [MANTISSA_WIDTH - 1:0] rounded_m_out
    );

    logic [MANTISSA_WIDTH:0] normal_m;

    always_comb
    begin
        normal_m = normal_m_in;

        if(normal_m_in[2:0] < 5)
            normal_m = normal_m;
        else
            normal_m++;
    end

    assign rounded_m_out = normal_m[MANTISSA_WIDTH:1];
endmodule