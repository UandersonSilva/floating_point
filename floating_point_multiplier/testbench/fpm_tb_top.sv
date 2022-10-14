`include "../device/fp_multiplier.sv"
`include "fpm_tb_pkg.sv"
`include "fpm_interface.sv"

module fpm_tb_top;
    import fpm_tb_pkg::*;

    fpm_interface fpm_if();

    fp_multiplier #(EXP_WIDTH, MANTISSA_WIDTH) fpm0(
        .a_in(fpm_if.a_in), 
        .b_in(fpm_if.b_in), 
        .fpm_out(fpm_if.fpm_out),
        .overflow_out(fpm_if.overflow_out),
        .underflow_out(fpm_if.underflow_out)
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

            "FACTORIAL_TEST":
            begin
                factorial_test selected;
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

        t0.env_r.fpm_if = fpm_if;

        $display("%c[2;35m", 27, "[TB_TOP] Running %s", test_name);
        $display("%c[0m", 27);
        
        t0.run();
        #5;
        $finish;
    end
endmodule : fpm_tb_top