# Floating Point Adder
This device performs the sum of two 32-bit floating point numbers.  
To do that, the fp_adder executes the following steps:
 - Determine the floating point representation fields of the two inputs;
 ![fp fields](../alib/fp_fields.svg)
 - Subtract the expoent fields (represented using excess-127) to find the greatest one;

## Structure

![fpa structure](../alib/fp_adder_structure.svg)

