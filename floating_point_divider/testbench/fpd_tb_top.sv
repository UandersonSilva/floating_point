`include "../device/fp_divider.sv"
`include "fpd_tb_pkg.sv"
`include "fpd_interface.sv"

module fpd_tb_top;
    import fpd_tb_pkg::*;

    fpd_interface fpd_if();

    fp_divider #(EXP_WIDTH, MANTISSA_WIDTH) fpd0(
        .a_in(fpd_if.a_in), 
        .b_in(fpd_if.b_in), 
        .fpd_out(fpd_if.fpd_out),
        .overflow_out(fpd_if.overflow_out),
        .underflow_out(fpd_if.underflow_out),
        .dbz_out(fpd_if.dbz_out)
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

            "OFUF_TEST":
            begin
                ofuf_test selected;
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

        t0.env_r.fpd_if = fpd_if;

        $display("%c[2;35m", 27, "[TB_TOP] Running %s", test_name);
        $display("%c[0m", 27);
        
        t0.run();
        #5;
        $finish;
    end
endmodule : fpd_tb_top