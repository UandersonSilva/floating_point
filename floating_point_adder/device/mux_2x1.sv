module mux_2x1 #(
        parameter WIDTH = 16
    )
    (
        input logic [WIDTH - 1:0] in_1, in_0,
        input logic sel_2x1_in,
        output logic [WIDTH - 1:0] mux_2x1_out
    );

    always_comb
    begin
        if(sel_2x1_in)
            mux_2x1_out <= in_1;
        else
            mux_2x1_out <= in_0;
    end
endmodule
