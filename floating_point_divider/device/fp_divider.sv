`include "divider/divider.sv"
`include "normalizer.sv"
`include "ofuf_checker.sv"
`include "rounder.sv"

module fp_divider #(
        parameter EXP_WIDTH = 8,
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in,
        output logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpd_out,
        output logic underflow_out, overflow_out, dbz_out
    );

    logic [EXP_WIDTH] exp_sub, exp_result, normal_exp;
    logic [MANTISSA_WIDTH+1:0] quotient, remainder;
    logic [MANTISSA_WIDTH:0] normal_m;
    logic [MANTISSA_WIDTH-1:0] rounded_m;
    logic underflow, underflow_n0, a_add_bit, b_add_bit;

    alu_c #(EXP_WIDTH) e_sub(
        .alu_A_in(a_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH]),
        .alu_B_in(b_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH]),
        .alu_op_in(1'b1),
        .alu_out(exp_sub),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out()
    );

    alu_c #(EXP_WIDTH) bias_add(
        .alu_A_in(exp_sub),
        .alu_B_in({1'b0, {(EXP_WIDTH-1){1'b1}}}),
        .alu_op_in(1'b0),
        .alu_out(exp_result),
        .alu_Z_out(),
        .alu_N_out(),
        .alu_C_out()
    );

    ofuf_checker #(EXP_WIDTH) ofuf0(
        .a_exp_in(a_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH]), 
        .b_exp_in(b_in[EXP_WIDTH+MANTISSA_WIDTH-1:MANTISSA_WIDTH]), 
        .exp_sum_in(exp_result),
        .overflow_out(overflow_out), 
        .underflow_out(underflow)
    );

    assign a_add_bit = (a_in[EXP_WIDTH+MANTISSA_WIDTH-1:0] == {(EXP_WIDTH+MANTISSA_WIDTH){1'b0}}) ? 1'b1 : 1'b0;
    assign b_add_bit = (b_in[EXP_WIDTH+MANTISSA_WIDTH-1:0] == {(EXP_WIDTH+MANTISSA_WIDTH){1'b0}}) ? 1'b1 : 1'b0;

    divider #(MANTISSA_WIDTH+2) fd0(
        .dividend_in({1'b0, ~a_add_bit, a_in[MANTISSA_WIDTH-1:0]}), 
        .divisor_in({1'b0, ~b_add_bit, b_in[MANTISSA_WIDTH-1:0]}),
        .quotient_out(quotient), 
        .remainder_out(remainder),
        .dbz_out(dbz_out)
    );

    normalizer #(EXP_WIDTH, MANTISSA_WIDTH) n0(
        .expoent_in(exp_result),
        .result_in({quotient, remainder}),
        .normal_e_out(normal_exp),
        .normal_m_out(normal_m),
        .underflow_out(underflow_n0)
    );

    rounder #(MANTISSA_WIDTH) r0(
        .normal_m_in(normal_m),
        .rounded_m_out(rounded_m)
    );

    assign signal = a_in[EXP_WIDTH+MANTISSA_WIDTH] ^ b_in[EXP_WIDTH+MANTISSA_WIDTH];
    assign fpd_out = {signal, normal_exp, rounded_m};
    assign underflow_out = underflow | underflow_n0;

endmodule