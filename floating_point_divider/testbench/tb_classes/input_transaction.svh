class input_transaction;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] a_in, b_in;;

    function bit compare(input_transaction compared);
        bit same = 0;
        if(compared == null)
            $display("%0t [INPUT TRANSACTION]: Null pointer. Comparison aborted.", $time);
        else
            same = (compared.a_in == a_in) &&
                   (compared.b_in == b_in);
        return same;
    endfunction : compare

    function void copy(input_transaction copied);
        a_in = copied.a_in;
        b_in = copied.b_in;
    endfunction : copy

    function input_transaction clone();
        input_transaction cloned;
        cloned = new();

        cloned.a_in = a_in;
        cloned.b_in = b_in;

        return cloned;
    endfunction : clone

    function string convert2string_b();
        string s;
        s = $sformatf("a_in: %32b b_in: %32b", a_in, b_in);

        return s;
    endfunction : convert2string_b

    function string convert2string();
        string s;
        s = $sformatf("a_in: %f b_in: %f", $bitstoshortreal(a_in), $bitstoshortreal(b_in));

        return s;
    endfunction : convert2string

endclass : input_transaction