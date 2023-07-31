# Challenge Level 2:

## Challenge 1 (Instruction)

**So challenge level 2 is an AAPG generation test and AAPG generation file is given as a part of the program , running the make exposes the problem 
We have to fix the config file to generate the Assembly test*

**Bug Explanation:**

So the level1 of challenge 2 is here:
we have riscv32i.yaml file and after running the make i have got the following errors:

[![Screenshot-2023-07-31-175631.png](https://i.postimg.cc/sxHTHTTq/Screenshot-2023-07-31-175631.png)](https://postimg.cc/0KmGb0R0)


[![Screenshot-2023-07-31-175744.png](https://i.postimg.cc/kg3QMrRw/Screenshot-2023-07-31-175744.png)](https://postimg.cc/QHm9SybW)


**Bug Fix and Explanation:**

The errors we are encountering indicates that the assembly test file test.S contains instructions that are not recognized by the RISC-V assembler. This could be due to instructions that are not part of the RISC-V RV32I instruction set.

To fix this, we need to modify the riscv32i.yaml file to generate assembly tests that only use instructions from the RV32I instruction set.

To resolve the issue of unrecognized instructions, we need to modify the isa-instruction-distribution section in the rv32i.yaml file to ensure that only instructions from the RV32I base integer instruction set are generated.

Here's the updated rv32i.yaml file with the changes:

[![Screenshot-2023-07-31-175921.png](https://i.postimg.cc/J7X3f4Gt/Screenshot-2023-07-31-175921.png)](https://postimg.cc/PNt8ZHbk)


[![Screenshot-2023-07-31-180006.png](https://i.postimg.cc/sgG3c8nF/Screenshot-2023-07-31-180006.png)](https://postimg.cc/CRYyMvTJ)



**Screenshot of Bug Fix:*

[![Screenshot-2023-07-31-171248.png](https://i.postimg.cc/3wJRQSNw/Screenshot-2023-07-31-171248.png)](https://postimg.cc/75dDgNgv)

