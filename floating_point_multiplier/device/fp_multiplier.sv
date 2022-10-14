`include "multiplier/fast_multiplier.sv"
`include "ofuf_checker.sv"
`include "normalizer.sv"
`include "rounder.sv"

module fp_multiplier #(
        parameter EXP_WIDTH = 8,
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [EXP_WIDTH + MANTISSA_WIDTH:0] a_in, b_in,
        output logic [EXP_WIDTH + MANTISSA_WIDTH:0] fpm_out,
        output logic overflow_out, underflow_out
    );

    logic a_signal, b_signal, carry, ofuf_overflow, overflow, underflow;
    logic [EXP_WIDTH - 1:0] a_exp, b_exp, a_exp_nobias, result_exp, normal_exp;
    logic [MANTISSA_WIDTH - 1:0] a_mantissa, b_mantissa, rounded_mantissa;
    logic [MANTISSA_WIDTH:0] normal_mantissa;
    logic [2*(MANTISSA_WIDTH+1) - 1:0] product_mantissa;

    assign a_signal   = a_in[EXP_WIDTH+MANTISSA_WIDTH];
    assign a_exp      = a_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH];
    assign a_mantissa = a_in[MANTISSA_WIDTH - 1:0];

    assign b_signal   = b_in[EXP_WIDTH+MANTISSA_WIDTH];
    assign b_exp      = b_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH];
    assign b_mantissa = b_in[MANTISSA_WIDTH - 1:0];

    alu_c #(EXP_WIDTH) bias_sub(
        .alu_A_in(a_exp),
        .alu_B_in({1'b0, {(EXP_WIDTH-1){1'b1}}}),
        .alu_op_in(1'b1),
        .alu_out(a_exp_nobias),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out()
    );

    alu_c #(EXP_WIDTH) e_add(
        .alu_A_in(a_exp_nobias),
        .alu_B_in(b_exp),
        .alu_op_in(1'b0),
        .alu_out(result_exp),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out()
    );

    assign zero_a = (a_in[EXP_WIDTH+MANTISSA_WIDTH-1:0] == {(EXP_WIDTH+MANTISSA_WIDTH){1'b0}}) ? 1'b1 : 1'b0;
    assign zero_b = (b_in[EXP_WIDTH+MANTISSA_WIDTH-1:0] == {(EXP_WIDTH+MANTISSA_WIDTH){1'b0}}) ? 1'b1 : 1'b0; 

    fast_multiplier #(MANTISSA_WIDTH+1) m0(
        .multiplicand_in({~(zero_a), a_mantissa}),
        .multiplier_in({~(zero_b), b_mantissa}),
        .product_out(product_mantissa)
    );

    normalizer #(EXP_WIDTH, MANTISSA_WIDTH) n0(
        .expoent_in(result_exp),
        .result_in(product_mantissa),
        .normal_e_out(normal_exp),
        .normal_m_out(normal_mantissa),
        .overflow_out(overflow)
    );

    ofuf_checker #(EXP_WIDTH) ofuf0(
        .a_exp_in(a_exp),
        .b_exp_in(b_exp),
        .exp_sum_in(result_exp),
        .overflow_out(ofuf_overflow),
        .underflow_out(underflow)
    );

    rounder #(MANTISSA_WIDTH) r0(
        .normal_m_in(normal_mantissa),
        .rounded_m_out(rounded_mantissa)
    );

    assign fpm_out[EXP_WIDTH+MANTISSA_WIDTH] = a_signal ^ b_signal;
    assign fpm_out[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = normal_exp;
    assign fpm_out[MANTISSA_WIDTH - 1:0] = rounded_mantissa;
    
    assign overflow_out  = ofuf_overflow | overflow;
    assign underflow_out = underflow;
endmodule