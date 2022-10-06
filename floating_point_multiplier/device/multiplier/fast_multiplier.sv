`include "alu_c.sv"


module fast_multiplier #(
        parameter WIDTH = 16
    )(
        input [WIDTH-1:0] multiplicand_in,
        input [WIDTH-1:0] multiplier_in,
        output [2*WIDTH-1:0] product_out
    );

    logic [WIDTH-1:0] alu_a [WIDTH-2:0];
    logic [WIDTH-1:0] alu_b [WIDTH-2:0];
    logic [WIDTH-3:0] alu_co;


    assign alu_b[0] = multiplicand_in & {WIDTH{multiplier_in[0]}};
    assign alu_a[0] = multiplicand_in & {WIDTH{multiplier_in[1]}};
    assign product_out[0] = alu_b[0][0];

    alu_c #(WIDTH) alu_c0(
        .alu_A_in(alu_a[0]),
        .alu_B_in({1'b0, alu_b[0][WIDTH-1:1]}),
        .alu_op_in(1'b0),
        .alu_out(alu_b[1]),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out(alu_co[0])
    );

    generate
        genvar i;

        for(i = 1; i < WIDTH - 2; i++)
        begin : multi_generation
            assign alu_a[i] = multiplicand_in & {WIDTH{multiplier_in[i+1]}};
            assign product_out[i] = alu_b[i][0];

            alu_c #(WIDTH) alu_cn(
                .alu_A_in(alu_a[i]),
                .alu_B_in({alu_co[i-1], alu_b[i][WIDTH-1:1]}),
                .alu_op_in(1'b0),
                .alu_out(alu_b[i+1]),
                .alu_Z_out(),
                .alu_N_out(),
                .alu_C_out(alu_co[i])
            );
        end : multi_generation
    endgenerate

    assign alu_a[WIDTH-2] = multiplicand_in & {WIDTH{multiplier_in[WIDTH-1]}};
    assign product_out[WIDTH-2] = alu_b[WIDTH-2][0];

    alu_c #(WIDTH) alu_cl(
        .alu_A_in(alu_a[WIDTH-2]),
        .alu_B_in({alu_co[WIDTH-3], alu_b[WIDTH-2][WIDTH-1:1]}),
        .alu_op_in(1'b0),
        .alu_out(product_out[2*WIDTH-2:WIDTH-1]),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out(product_out[2*WIDTH-1])
    );
   
endmodule