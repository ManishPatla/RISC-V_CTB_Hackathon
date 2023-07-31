## RISC-V Core (RV32I) Design : "RSIC-V_STEEL_CORE"

Here,

We have chosen a OpenSource RISCV Core which supports RV32I and Verilator for simulation as our Source.

We focus on inserting bugs into our design Riscv_Steel_Core.V , and write the test cases to expose the Bugs. 

**Explanation of the Bugs introduced into Riscv_Steel_Core.v:**

**Bug 1: Incorrect CSR Write Data*
In the always @* begin : csr_data_out_mux block, introduced a bug that causes incorrect CSR data to be read from the csr_data_out register.


[![Screenshot-2023-07-31-180054.png](https://i.postimg.cc/fWg4rCSM/Screenshot-2023-07-31-180054.png)](https://postimg.cc/mhM6cQSn)


**Bug 2: Incorrect Load Data*
In the always @* begin : load_size_mux block, introduced a bug that causes incorrect data to be loaded from memory for byte and half-word loads.

[![Screenshot-2023-07-31-180121.png](https://i.postimg.cc/pr36X0K8/Screenshot-2023-07-31-180121.png)](https://postimg.cc/CnHNcsPL)


**Bug 3: Incorrect Branch Condition*
In the always @* begin : branch_condition_satisfied_mux block,  introduced a bug that causes incorrect branch condition determination.

[![Screenshot-2023-07-31-180153.png](https://i.postimg.cc/pTWTqChD/Screenshot-2023-07-31-180153.png)](https://postimg.cc/nsWpLv1z)


Test cases to expose these Bugs:

Here,
We focus on test cases that cover different instruction types, load/store instructions, and branches.

[![Screenshot-2023-07-31-180544.png](https://i.postimg.cc/6QGSFxRK/Screenshot-2023-07-31-180544.png)](https://postimg.cc/XZ4QyhQ1)




[![Screenshot-2023-07-31-180621.png](https://i.postimg.cc/pXXSRF8q/Screenshot-2023-07-31-180621.png)](https://postimg.cc/vDkhvD0V)

**This test file "test.S" contains three tests, each designed to expose one of the bugs we introduced earlier. It uses the RISC-V assembly language to write the test cases for the bugs in the design. The test cases aim to execute specific instructions that trigger the bugs and then verify the results by comparing them with the expected values.*


