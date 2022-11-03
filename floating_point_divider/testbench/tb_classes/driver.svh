class driver;
    virtual fpd_interface fpd_if;
    mailbox #(data_item) data_mbox;

    task run();
        data_item data_i;

        forever
        begin
            data_mbox.get(data_i);
            
            #1;
            if(data_i == null)
                $display("%0t [DRIVER]: No data item.", $time);
            else
            begin
                fpd_if.send_data(data_i.a_in, 
                                 data_i.b_in,  
                                 data_i.fpd_out, 
                                 data_i.overflow_out,
                                 data_i.underflow_out,
                                 data_i.dbz_out
                                );
                ->data_i.done;

                @(data_i.done);
            end
        end
    endtask : run

endclass : driver