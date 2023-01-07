# Floating Point Multiplier
This device performs the multiplication of two 32-bit floating point numbers.  
To do that, the fp_divider executes the following steps:  
 - Determine the floating point representation fields of the two inputs;  
 ![fp fields](../alib/fp_fields.svg)
 - Check if any input number (expoent and mantissa fields) is equal to 0. If so, the additional implicit bit will be 0. Otherwise, it will be equal to 1;  
 ![fpm imp_bit](../alib/fpd_implicit_bit.svg)  
 - Sum the expoents of the two numbers and subtract the result by bias value (127);  
 ![fpm eadd](../alib/fpm_eadd.svg)  
 - Multiply the manstissas (with the implicit bit defined earlier);  
 ![fpm multiplication](../alib/fpm_multiplication.svg)   
 - Define the output signal bit (Sa **xor** Sb);  
 ![fpm signal](../alib/fpd_signal.svg)   
 - Normalize the result, finding the leading 1 and either shifting right and incrementing the expoent or shifting left and decrementing the expoent;  
 ![fpm normalize](../alib/fpm_normalize.svg)   
 - Round off the bits shifted out due to the normalization proccess if necessary.  
![fpm result](../alib/fpm_result.svg)   

 ## Structure

 ![fpa structure](../alib/fp_multiplier_structure.svg)