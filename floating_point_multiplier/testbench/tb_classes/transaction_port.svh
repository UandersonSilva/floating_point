class transaction_port #(parameter type T = input_transaction);
    protected T transaction;

    function void write(T transaction);
        this.transaction = transaction;
    endfunction : write

    function void read(ref T read_transaction);
        read_transaction = transaction.clone();            
    endfunction : read
endclass : transaction_port