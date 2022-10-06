module alu_c #(
        parameter WIDTH = 16
    )
    (
        input logic [WIDTH - 1:0] alu_A_in, alu_B_in,
        input logic  alu_op_in,
        output logic [WIDTH - 1:0] alu_out,
        output logic alu_Z_out, alu_N_out, alu_C_out
    );

    localparam _add = 1'b0, _sub = 1'b1;

    always_comb
    begin
        if(alu_op_in)
            {alu_C_out, alu_out} = alu_A_in - alu_B_in;
        else
            {alu_C_out, alu_out} = alu_A_in + alu_B_in;
        
        if(alu_out=={WIDTH{1'b0}})
            alu_Z_out <= 1'b1;
        else
            alu_Z_out <= 1'b0;

        alu_N_out <= alu_out[WIDTH - 1];
    end
endmodule 