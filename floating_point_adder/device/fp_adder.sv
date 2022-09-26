`include "alu_c.sv"
`include "barrel_shifter.sv"
`include "mux_2x1.sv"
`include "normalizer.sv"
`include "number_complementer.sv"
`include "rounder.sv"

module fp_adder #(
        parameter EXP_WIDTH = 8,
        parameter MANTISSA_WIDTH = 23
    )(
        input logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in,
        output logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpa_out,
        output logic overflow_out, underflow_out
    );

    //Internal Bus
    logic [EXP_WIDTH - 1:0] a_exp, b_exp, selected_exp, normal_exp;
    logic [EXP_WIDTH:0] e_dif, comp_e_dif;
    logic [MANTISSA_WIDTH - 1:0] a_mantissa, b_mantissa, rounded_mantissa; 
    logic [MANTISSA_WIDTH - 1:0] greater_mantissa, lesser_mantissa;
    logic [MANTISSA_WIDTH:0] lesser_ms, result, normal_mantissa;
    logic a_signal, b_signal, sub_N_flag, C_result, selected_signal;
    logic overflow, underflow;

    assign a_signal   = a_in[EXP_WIDTH+MANTISSA_WIDTH];
    assign a_exp      = a_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH];
    assign a_mantissa = a_in[MANTISSA_WIDTH - 1:0];

    assign b_signal   = b_in[EXP_WIDTH+MANTISSA_WIDTH];
    assign b_exp      = b_in[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH];
    assign b_mantissa = b_in[MANTISSA_WIDTH - 1:0];

    //Internal components
    mux_2x1 #(EXP_WIDTH) e_mux(
        .in_0(a_exp),
        .in_1(b_exp),
        .sel_2x1_in(e_dif[EXP_WIDTH]),
        .mux_2x1_out(selected_exp)
    );

    mux_2x1 #(MANTISSA_WIDTH) greater_mux(
        .in_0(a_mantissa),
        .in_1(b_mantissa),
        .sel_2x1_in(e_dif[EXP_WIDTH]),
        .mux_2x1_out(greater_mantissa)
    );

    mux_2x1 #(MANTISSA_WIDTH) lesser_mux(
        .in_0(a_mantissa),
        .in_1(b_mantissa),
        .sel_2x1_in(~e_dif[EXP_WIDTH]),
        .mux_2x1_out(lesser_mantissa)
    );

    alu_c #(EXP_WIDTH) e_sub(
        .alu_A_in({1'b0, a_exp}), 
        .alu_B_in({1'b0, b_exp}),
        .alu_op_in(1'b1),
        .alu_out(e_dif[EXP_WIDTH-1:0]),
        .alu_Z_out(), 
        .alu_N_out(), 
        .alu_C_out(e_dif[EXP_WIDTH])
    );

    number_complementer #(EXP_WIDTH+1) e_dif_comp(
        .number_in(e_dif),
        .complement_in(e_dif[EXP_WIDTH]),
        .number_out(comp_e_dif)
    );

    barrel_shifter #(
        .WIDTH(MANTISSA_WIDTH+1), 
        .AMOUNT_WIDTH(EXP_WIDTH+1)
    ) lesser_shifter(
        .data_in({1'b1, lesser_mantissa}),
        .amount_in(comp_e_dif),
        .shift_dir_in(1'b1),
        .data_out(lesser_ms)
    );

    alu_c #(MANTISSA_WIDTH+1) m_alu(
        .alu_A_in({1'b1, greater_mantissa}), 
        .alu_B_in(lesser_ms),
        .alu_op_in(a_signal^b_signal),
        .alu_out(result),
        .alu_Z_out(), 
        .alu_N_out(), 
        .alu_C_out(C_result)
    );

    normalizer #(EXP_WIDTH, MANTISSA_WIDTH) n0(
        .expoent_in(selected_exp),
        .result_in({C_result, result}),
        .normal_e_out(normal_exp),
        .normal_m_out(normal_mantissa),
        .overflow_out(overflow), 
        .underflow_out(underflow)
    );

    rounder #(MANTISSA_WIDTH) m0(
        .normal_m_in(normal_mantissa),
        .rounded_m_out(rounded_mantissa)
    );

    mux_2x1 #(1) signal_mux(
        .in_0(a_signal),
        .in_1(b_signal),
        .sel_2x1_in(e_dif[EXP_WIDTH]),
        .mux_2x1_out(selected_signal)
    );

    assign fpa_out[EXP_WIDTH+MANTISSA_WIDTH] = selected_signal;
    assign fpa_out[EXP_WIDTH+MANTISSA_WIDTH - 1:MANTISSA_WIDTH] = normal_exp;
    assign fpa_out[MANTISSA_WIDTH - 1:0] = rounded_mantissa;
    
    assign overflow_out  = overflow;
    assign underflow_out = underflow;

endmodule