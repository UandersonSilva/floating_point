class output_transaction;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpa_out;
    logic overflow_out, underflow_out;

    function bit compare(output_transaction compared);
        bit same = 0;
        shortreal real_out, compared_real_out;

        if(compared == null)
            $display("%0t [OUTPUT TRANSACTION]: Null pointer. Comparison aborted.", $time);
        else
        begin
            real_out = $bitstoshortreal(fpa_out);
            compared_real_out = $bitstoshortreal(compared.fpa_out);

            if(compared_real_out >= 0)
            begin
                if((compared_real_out >= 0.98*real_out) && (compared_real_out <= 1.02*real_out))
                    same = 1'b1;
                else
                    same = 0;
            end
            else
            begin
                if((compared_real_out <= 0.98*real_out) && (compared_real_out >= 1.02*real_out))
                    same = 1'b1;
                else
                    same = 0;
            end

            same = same && 
                   (compared.overflow_out == overflow_out) &&
                   (compared.underflow_out == underflow_out);
        end

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