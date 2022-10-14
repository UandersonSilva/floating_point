class data_item;
    rand logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpm_out;
    logic overflow_out, underflow_out;

    event done;

    function bit compare(data_item compared);
        bit same = 0;
        if(compared == null)
            $display("%0t [DATA ITEM]: Null pointer. Comparison aborted.", $time);
        else
            same = (compared.a_in == a_in) &&
                   (compared.b_in == b_in) &&
                   (compared.fpm_out == fpm_out) && 
                   (compared.overflow_out == overflow_out) &&
                   (compared.underflow_out == underflow_out);

        return same;
    endfunction : compare

    function void copy(data_item copied);
        a_in          = copied.a_in;
        b_in          = copied.b_in;
        fpm_out       = copied.fpm_out;
        overflow_out  = copied.overflow_out;
        underflow_out = copied.underflow_out;
    endfunction : copy

    function data_item clone();
        data_item cloned;
        cloned = new();

        cloned.a_in          = a_in;
        cloned.b_in          = b_in;
        cloned.fpm_out       = fpm_out;
        cloned.overflow_out  = overflow_out;
        cloned.underflow_out = underflow_out;

        return cloned;
    endfunction : clone

    function string convert2string_b();
        string s;
        s = $sformatf("a_in: %32b b_in: %32b => fpm_out: %32b overflow_out: %b underflow_out: %b",
                    a_in, b_in, fpm_out, overflow_out, underflow_out);

        return s;
    endfunction : convert2string_b

    function string convert2string();
        string s;
        s = $sformatf("a_in: %f b_in: %f => fpm_out: %f overflow_out: %b underflow_out: %b",
                $bitstoshortreal(a_in), $bitstoshortreal(b_in), $bitstoshortreal(fpm_out), overflow_out, underflow_out);

        return s;
    endfunction : convert2string

endclass : data_item