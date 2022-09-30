class initial_test extends base_test;
    task run;
        super.run();

        data_i = new();
        data_i.a_in = $shortrealtobits(0.0);
        data_i.b_in = $shortrealtobits(0.0);
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        data_i = new();
        data_i.a_in = $shortrealtobits(0.5);
        data_i.b_in = $shortrealtobits(0.5); 
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        data_i = new();
        data_i.a_in = $shortrealtobits(2.0);
        data_i.b_in = $shortrealtobits(-0.5); 
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        data_i = new();
        data_i.a_in = $shortrealtobits(-2.0);
        data_i.b_in = $shortrealtobits(0.5); 
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();

        data_i = new();
        data_i.a_in = $shortrealtobits(2.0);
        data_i.b_in = $shortrealtobits(-2.0); 
        super.insert_data();
      
        @(data_i.done);

        super.obtain_data();
    endtask : run
endclass : initial_test