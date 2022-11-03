class output_transaction;
    logic [EXP_WIDTH+MANTISSA_WIDTH:0] fpm_out;
    logic overflow_out, underflow_out, dbz_out;

    function bit compare(output_transaction compared);
        bit same = 0;
        shortreal real_out, compared_real_out;

        if(compared == null)
            $display("%0t [OUTPUT TRANSACTION]: Null pointer. Comparison aborted.", $time);
        else
        begin
            real_out = $bitstoshortreal(fpm_out);
            compared_real_out = $bitstoshortreal(compared.fpm_out);

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
                   (compared.underflow_out == underflow_out) &&
                   (compared.dbz_out == dbz_out);
        end

        return same;
    endfunction : compare

    function void copy(output_transaction copied);
        fpm_out       = copied.fpm_out;
        overflow_out  = copied.overflow_out;
        underflow_out = copied.underflow_out;
        dbz_out       = copied.dbz_out;
    endfunction : copy

    function output_transaction clone();
        output_transaction cloned;
        cloned = new();

        cloned.fpm_out       = fpm_out;
        cloned.overflow_out  = overflow_out;
        cloned.underflow_out = underflow_out;
        cloned.dbz_out       = dbz_out;

        return cloned;
    endfunction : clone

    function string convert2string_b();
        string s;
        s = $sformatf("fpm_out: %32b overflow_out: %b underflow_out: %b dbz_out: %b", 
            fpm_out, overflow_out, underflow_out, dbz_out);

        return s;
    endfunction : convert2string_b

    function string convert2string();
        string s;
        s = $sformatf("fpm_out: %f overflow_out: %b underflow_out: %b dbz_out: %b", 
            $bitstoshortreal(fpm_out), overflow_out, underflow_out, dbz_out);

        return s;
    endfunction : convert2string

endclass : output_transaction