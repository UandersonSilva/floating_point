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

    initial
    begin
        string test_name;

        base_test t0;
        
        $value$plusargs("TEST=%s", test_name);

        case(test_name)
            "INITIAL_TEST":
            begin
                initial_test selected;
                selected = new();
                t0 = selected;
            end
            
            "RANDOM_TEST":
            begin
                random_test selected;
                selected = new();
                t0 = selected;
            end

            default:
            begin
                random_test selected;
                selected = new();
                t0 = selected;
                test_name = $sformatf("DEFAULT(RANDOM_TEST)");
            end
        endcase

        t0.env_r.fpa_if = fpa_if;

        $display("%c[2;35m", 27, "[TB_TOP] Running %s", test_name);
        $display("%c[0m", 27);
        
        t0.run();
        #2;
        $finish;
    end
endmodule : fpa_tb_top