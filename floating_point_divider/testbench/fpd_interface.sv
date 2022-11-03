interface fpd_interface();
    import fpd_tb_pkg::*;

    logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpd_out;
    logic overflow_out, underflow_out, dbz_out, clock;

    input_monitor  input_monitor_r;
    output_monitor output_monitor_r;

    event input_read;
    event output_read;

    initial
    begin
        clock = 0;
        forever 
        begin
           #10;
           clock = ~clock;
        end
    end

    task send_data(
            input logic [EXP_WIDTH+MANTISSA_WIDTH:0] ia_in,
            input logic [EXP_WIDTH+MANTISSA_WIDTH:0] ib_in,
            output logic [EXP_WIDTH+MANTISSA_WIDTH:0] ifpd_out,
            output logic overflow,
            output logic underflow,
            output logic dbz
        );
        @(clock);
       
        a_in = ia_in;
        b_in = ib_in;
        
        #2;
        ifpd_out  = fpd_out;
        overflow  = overflow_out;
        underflow = underflow_out;
        dbz       = dbz_out;
    endtask : send_data

    always @(clock)
    begin : input_monitor_read
        #1;
        input_monitor_r.read(a_in, b_in);
        -> input_read;
    end

    always @(clock)
    begin : output_monitor_read
        #2;
        output_monitor_r.read(fpd_out, overflow_out, underflow_out, dbz_out);
        -> output_read;
    end
endinterface : fpd_interface