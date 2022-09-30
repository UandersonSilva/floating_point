`include "../device/fp_adder.sv"
`include "fpa_tb_pkg.sv"
`include "fpa_interface.sv"

module fpa_tb_top;
    import fpa_tb_pkg::*;

    fpa_interface fpa_if();

    fp_adder #(EXP_WIDTH, MANTISSA_WIDTH) fpa0(
        .a_in(fpa_if.a_in), 
        .b_in(fpa_if.b_in), 
        .fpa_out(fpa_if.fpa_out),
        .overflow_out(fpa_if.overflow_out),
        .underflow_out(fpa_if.underflow_out)
    );

    initial_test t0;

    initial
    begin
        t0 = new();
        t0.env_r.fpa_if = fpa_if;
        t0.run();
        #2;
        $finish;
    end
endmodule : fpa_tb_top