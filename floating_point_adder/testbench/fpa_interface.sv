interface fpa_interface();
    import fpa_tb_pkg::*;

    logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpa_out;
    logic overflow_out, underflow_out, clock;

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
            logic [EXP_WIDTH+MANTISSA_WIDTH:0] ia_in,
            logic [EXP_WIDTH+MANTISSA_WIDTH:0] ib_in,
            logic [EXP_WIDTH+MANTISSA_WIDTH:0] ifpa_out,
            logic overflow,
            logic underflow
        );
        @(clock);
       
        a_in = ia_in;
        b_in = ib_in;
        
        #2;
        ifpa_out  = fpa_out;
        overflow  = overflow_out;
        underflow = underflow_out;
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
        output_monitor_r.read(fpa_out, overflow_out, underflow_out);
        -> output_read;
    end
endinterface : fpa_interface