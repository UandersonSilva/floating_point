module alu_c #(
        parameter WIDTH = 16
    )
    (
        input logic [WIDTH - 1:0] alu_A_in, alu_B_in,
        input logic  alu_op_in,
        output logic [WIDTH - 1:0] alu_out,
        output logic alu_Z_out, alu_N_out, alu_C_out
    );

    always_comb
    begin
        //{alu_C_out, alu_out} = alu_A_in + (alu_B_in^{WIDTH{alu_op_in}}) + alu_op_in;

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