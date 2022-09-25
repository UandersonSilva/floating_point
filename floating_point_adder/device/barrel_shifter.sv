module barrel_shifter #(
        parameter WIDTH = 16,
        parameter AMOUNT_WIDTH = 8;
    )(
        input logic [WIDTH - 1:0] data_in,
        input logic [AMOUNT_WIDTH - 1:0] amount_in,
        input logic shift_dir_in,
        output logic [WIDTH - 1:0] data_out
    );

    always_comb
    begin
        if(amount_in > WIDTH)
            data_out <= {WIDTH{1'b0}};
        else
        begin
            if(shift_dir_in)
                data_out <= data_in >> amount_in;
            else
                data_out <= data_in << amount_in;
        end
    end
endmodule