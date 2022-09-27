class output_transaction;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpa_out;
    logic overflow_out, underflow_out;

    function bit compare(output_transaction compared);
        bit same = 0;
        if(compared == null)
            $display("%0t [OUTPUT TRANSACTION]: Null pointer. Comparison aborted.", $time);
        else
            same = (compared.fpa_out == fpa_out) && 
                   (compared.overflow_out == overflow_out) &&
                   (compared.underflow_out == underflow_out);

        return same;
    endfunction : compare

    function void copy(output_transaction copied);
        fpa_out       = copied.fpa_out;
        overflow_out  = copied.overflow_out;
        underflow_out = copied.underflow_out;
    endfunction : copy

    function output_transaction clone();
        output_transaction cloned;
        cloned = new();

        cloned.fpa_out       = fpa_out;
        cloned.overflow_out  = overflow_out;
        cloned.underflow_out = underflow_out;

        return cloned;
    endfunction : clone

    function string convert2string_b();
        string s;
        s = $sformatf("fpa_out: %32b overflow_out: %b underflow_out: %b", fpa_out, overflow_out, underflow_out);

        return s;
    endfunction : convert2string_b

    function string convert2string();
        string s;
        s = $sformatf("fpa_out: %f overflow_out: %b underflow_out: %b", $bitstoshortreal(fpa_out), overflow_out, underflow_out);

        return s;
    endfunction : convert2string

endclass : output_transaction