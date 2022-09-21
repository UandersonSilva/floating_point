module number_complementer #(
    parameter WIDTH = 16
)(
    input logic [WIDTH - 1:0] number_in,
    input logic complement_in,
    output logic [WIDTH - 1:0] number_out
);
    assign number_out = (number_in ^ {WIDTH{complement_in}}) + complement_in;
endmodule