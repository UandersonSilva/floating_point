class data_item;
    rand logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpd_out;
    logic overflow_out, underflow_out, dbz_out;

    event done;

    function bit compare(data_item compared);
        bit same = 0;
        if(compared == null)
            $display("%0t [DATA ITEM]: Null pointer. Comparison aborted.", $time);
        else
            same = (compared.a_in == a_in) &&
                   (compared.b_in == b_in) &&
                   (compared.fpd_out == fpd_out) && 
                   (compared.overflow_out == overflow_out) &&
                   (compared.underflow_out == underflow_out) &&
                   (compared.dbz_out == dbz_out);

        return same;
    endfunction : compare

    function void copy(data_item copied);
        a_in          = copied.a_in;
        b_in          = copied.b_in;
        fpd_out       = copied.fpd_out;
        overflow_out  = copied.overflow_out;
        underflow_out = copied.underflow_out;
        dbz_out       = copied.dbz_out;
    endfunction : copy

    function data_item clone();
        data_item cloned;
        cloned = new();

        cloned.a_in          = a_in;
        cloned.b_in          = b_in;
        cloned.fpd_out       = fpd_out;
        cloned.overflow_out  = overflow_out;
        cloned.underflow_out = underflow_out;
        cloned.dbz_out       = dbz_out;

        return cloned;
    endfunction : clone

    function string convert2string_b();
        string s;
        s = $sformatf("a_in: %32b b_in: %32b => fpd_out: %32b overflow_out: %b underflow_out: %b dbz_out: %b",
                    a_in, b_in, fpd_out, overflow_out, underflow_out, dbz_out);

        return s;
    endfunction : convert2string_b

    function string convert2string();
        string s;
        s = $sformatf("a_in: %f b_in: %f => fpd_out: %f overflow_out: %b underflow_out: %b dbz_out: %b",
                $bitstoshortreal(a_in), $bitstoshortreal(b_in), $bitstoshortreal(fpd_out), overflow_out, underflow_out, dbz_out);

        return s;
    endfunction : convert2string

endclass : data_item