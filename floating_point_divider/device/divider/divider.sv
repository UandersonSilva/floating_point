`include "alu_c.sv"
`include "mux_2x1.sv"

module divider #(
        parameter WIDTH = 16
    )(
        input logic [WIDTH - 1:0] dividend_in, divisor_in,
        output logic [WIDTH - 1:0] quotient_out, remainder_out,
        output logic dbz_out
    );

    logic [WIDTH-1:0] alu_a [WIDTH-1:0];
    logic [WIDTH-1:0] alu_out [WIDTH-1:0];
    logic [WIDTH-1:0] selected_out [WIDTH-1:0];
    logic [WIDTH-1:0] alu_co;
    
    assign alu_a[WIDTH-1] = dividend_in;

    alu_c #(WIDTH) alu_cl(
        .alu_A_in(alu_a[WIDTH-1]),
        .alu_B_in(divisor_in),
        .alu_op_in(1'b1),
        .alu_out(alu_out[WIDTH-1]),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out(alu_co[WIDTH-1])
    );

    mux_2x1 #(WIDTH) mux_l(
        .in_0(alu_out[WIDTH-1]),
        .in_1(alu_a[WIDTH-1]),
        .sel_2x1_in(alu_co[WIDTH-1]),
        .mux_2x1_out(selected_out[WIDTH-1])
    );

    generate
        genvar i;

        for(i = WIDTH - 2; i >= 1; i--)
        begin : multi_generation
            assign alu_a[i] = {selected_out[i+1][WIDTH-2:0], 1'b0};

            alu_c #(WIDTH) alu_cn(
                .alu_A_in(alu_a[i]),
                .alu_B_in(divisor_in),
                .alu_op_in(1'b1),
                .alu_out(alu_out[i]),
                .alu_Z_out(),
                .alu_N_out(),
                .alu_C_out(alu_co[i])
            );

            mux_2x1 #(WIDTH) mux_n(
                .in_0(alu_out[i]),
                .in_1(alu_a[i]),
                .sel_2x1_in(alu_co[i]),
                .mux_2x1_out(selected_out[i])
            );
        end : multi_generation
    endgenerate

    assign alu_a[0] = {selected_out[1][WIDTH-2:0], 1'b0};

    alu_c #(WIDTH) alu_c0(
        .alu_A_in(alu_a[0]),
        .alu_B_in(divisor_in),
        .alu_op_in(1'b1),
        .alu_out(alu_out[0]),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out(alu_co[0])
    );

    mux_2x1 #(WIDTH) mux_0(
        .in_0(alu_out[0]),
        .in_1(alu_a[0]),
        .sel_2x1_in(alu_co[0]),
        .mux_2x1_out(selected_out[0])
    );

    assign quotient_out  = ~(alu_co);
    assign remainder_out = selected_out[0];
    assign dbz_out = (divisor_in == {WIDTH{1'b0}}) ? 1'b1 : 1'b0;

endmodule