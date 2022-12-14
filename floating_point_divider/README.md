# Floating Point Divider
This device performs the division of two 32-bit floating point numbers.  
To do that, the fp_divider executes the following steps:  
 - Determine the floating point representation fields of the two inputs;  
 ![fp fields](../alib/fp_fields.svg)
 - Check if any input number (expoent and mantissa fields) is equal to 0. If so, the additional implicit bit will be 0. Otherwise, it will be equal to 1;  
 ![fpd imp_bit](../alib/fpd_implicit_bit.svg)  
 - Subtract the expoents of the two numbers and sum the result by bias value (127);  
 ![fpd sub](../alib/fpd_sub.svg)  
 - Divide the manstissas (with the implicit bit defined earlier) using fixed point mode;  
 ![fpd division](../alib/fpd_division.svg)   
 - Define the output signal bit (Sa **xor** Sb);  
 ![fpd signal](../alib/fpd_signal.svg)   
 - Normalize the result, finding the leading 1 and either shifting right and incrementing the expoent or shifting left and decrementing the expoent;  
 ![fpd normalize](../alib/fpd_normalize.svg)   
 - Round off the bits shifted out due to the normalization proccess if necessary.  
![fpd result](../alib/fpd_result.svg)   

 ## Structure

 ![fpa structure](../alib/fp_divider_structure.svg)