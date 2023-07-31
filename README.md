# RISCV_CTB_CHALLENGES :

**Welcome to the RISC-V CTB Challenge!
In this hackathon, we will be working with the RISC-V architecture and assembly programming to verify and test RISC-V processors. For this challenge, we will be using Vyoma's UpTick Pro tool to set up the verification environment and Spike for simulation. Our focus will be on the RV32I ISA (Instruction Set Architecture).*



## Challenge Level 1: Logical,Loop,Illegal

### 1)Logical:

Screnshot of the Bug:

<img width="332" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/53c7a165-afc9-4589-bfcd-c46cef859cf8">


**Bug Explanation:**
During the challenge, we encountered a logical bug in the "add" instruction implementation.

1) **test.S:15855: Error: illegal operands 'and s7, ra, z4'**

The instruction here is : and s7, ra, z4.
The error message indicates that there is an issue with the operands used in this instruction.
The and instruction is a bitwise AND operation, and it expects three registers as operands: and dest, source1, source2.
s7, ra, and z4 are register names, and the assembler is reporting that there's something wrong with how they are used in this instruction.

2) **test.S:25584: Error: illegal operands 'andi s5, t1, s0'**

The instruction here is andi s5, t1, s0.
The error message again indicates an issue with the operands used in this instruction.
The andi instruction is an immediate bitwise AND operation, and it also expects three registers as operands: andi dest, source1, imm.
s5, t1, and s0 are register names, and the assembler is reporting that there's a problem with how they are used in this instruction.

**Common reasons for these types of errors could be:*

Incorrect register names or typos.
Incorrect syntax in the instructions.

**Bug Fix Explanation :**

1)The error message test.S:15855: Error: illegal operands 'and s7, ra, z4' indicates that there's an issue with the usage of register z4. Since z4 is a zero register and cannot be written to, it cannot be used as a source or destination in an instruction like and.

To resolve this issue, you should use a valid general-purpose register (e.g., x0, x1, ..., x31) instead of z4 in the instruction at line 15855.

2)In RISC-V assembly, immediate instructions like andi expect a constant immediate value as one of the operands. The immediate value is a fixed constant value that is used in the operation, and it is not represented by a register.

**Screenshot of Bug Fix:*

**Fixed Instruction:*
and s7, ra, t0
&
andi s5, t1, 42

<img width="699" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/f7c7bafc-936f-476d-9931-b6bd63e2343f">



### 2)Loop:


**Bug Explanation:**

We have an test file which runs without exiting the spike here the test performs addition operation and self checks for 3 set of test cases

Analysisng Test.S file here :

<img width="245" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/1857aeaa-42b2-4a10-8f45-cae55dae9f5b">


Here the test file is designed to perform addition operations and check the results against expected values. However, there seems to be an issue with the comparison and failure detection in the loop.


**Bug Fix Solution:**

To fix the test, we need to adjust the comparison and failure detection logic in the loop. The current code uses beq instruction to check if t3 (the expected sum) is equal to t4 (the computed sum). However, beq only branches when the two operands are equal. In this case, we need to branch when they are not equal, indicating a failure.

Here's the fixed code for the loop:

[![Screenshot-2023-07-31-175248.png](https://i.postimg.cc/dQhr8Q84/Screenshot-2023-07-31-175248.png)](https://postimg.cc/fkhVsNq9)

#The changes made here:

We used the bne (branch not equal) instruction to check if t3 is not equal to t4.
If the condition is true (the expected sum is not equal to the computed sum), it jumps to the fail label.
We also introduced a test case counter using t5 (initialized to 3) to keep track of the number of remaining test cases.
After each iteration, we decrement the test case counter using sub t5, t5, 1.
If the test case counter t5 is not zero (bnez t5, loop), we continue to the next test case.
The loop now iterates through all the test cases and performs the addition operation correctly while checking for failures. If there's any mismatch between the expected and computed sums, the test will jump to the fail label.

**Screenshot of the Bug Fix:*

[![Screenshot-2023-07-31-170552.png](https://i.postimg.cc/ZKRJwBWG/Screenshot-2023-07-31-170552.png)](https://postimg.cc/Jtfwnhcx)


### 3) Illegal:

Here we have a test file, which runs without exiting in spike and it has an illegal instruction and corresponding handler code, we try to  fix the test 


test.S file is :
[![Screenshot-2023-07-31-175455.png](https://i.postimg.cc/1tkt0SQj/Screenshot-2023-07-31-175455.png)](https://postimg.cc/hz0cgHhL)

**Bug Explanation:**

The issue is that the instruction j fail in the illegal_instruction section is not a valid RISC-V instruction. The j instruction is used for jumps (J-type) but requires a label as its target, not an immediate value or register. Since there is no label named fail in the code you've provided, this instruction results in an error.

**Bug Fix :**

To fix this issue, we'll modify the code in the illegal_instruction section to perform a different operation that causes an illegal instruction exception. One way to do this is by using an invalid opcode, such as add x0, x0, x0, which is essentially a no-operation (NOP) instruction with the ADD opcode.

Here's the corrected code for the illegal_instruction section:

**illegal_instruction:*
  add x0, x0, x0  # This is an invalid instruction (NOP with ADD opcode) causing an illegal instruction exception
  TEST_PASSFAIL

In this modified code, we use the add instruction with x0 (the zero register) to perform an invalid operation that causes an illegal instruction exception. The TEST_PASSFAIL macro is used to ensure the test still passes or fails based on the overall test results.

**Screenshot of Bug Fix:*

[![Screenshot-2023-07-31-164759.png](https://i.postimg.cc/Pq5KBHkF/Screenshot-2023-07-31-164759.png)](https://postimg.cc/ts8hxLJh)


**Challenge Level 2**

1) Level 2 (Instruction)

So challenge level 2 is an AAPG generation test and AAPG generation file is given as a part of the program , running the make exposes the problem 
We have to fix the config file to generate the Assembly test 

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


## Challenge Level 2 : Exceptions

**This is an AAPG  generation test setup*
Here with expereince from the previous challenge ,we create a AAPG config file to generate  a test with 10 illegal exceptions with the correct handler code 

To generate a test with 10 illegal exceptions and the correct handler code using AAPG, we will need to modify the AAPG configuration file (rv32i.yaml) accordingly. Specifically, we need to define the handler code for each illegal exception and ensure that the test runs successfully on Spike.

**i)Yaml File Creation:**

Here the The YAML file serves as a configuration file that provides instructions to AAPG on how to generate a random RISC-V program.
The YAML file was created manually to configure the behavior of the Automated Assembly Program Generator (AAPG) tool.
It contains various sections, each specifying different aspects of the program generation process. The sections and their respective options are defined with the help of keys and values in the YAML format.

The configuration file is created using a text editor, and each section is organized hierarchically using indentation. The values specified in the YAML file influence the frequency and distribution of instructions, privilege modes, data access sections, CSR (Control and Status Register) sections, recursion options, self-checking settings, exception generation, cache thrashing, and more.

**ii) Exceptions Generation Explanation:**

In the YAML file, there is a section called exception-generation, which is responsible for controlling the generation of exceptions in the random RISC-V program. Each exception cause is represented by a key (e.g., ecause00, ecause01, etc.) and its corresponding value determines the number of exceptions generated for that particular cause.

Here's an explanation of how exceptions are generated based on the exception-generation section:

For ecause00, ecause01, and ecause02, the value is set to 10. This means that AAPG will generate 10 exceptions for each of these exception causes (10 exceptions for ecause00, 10 for ecause01, and 10 for ecause02). These causes are considered as illegal instruction exceptions.

For ecause03 to ecause14, the value is set to 0. This means that AAPG will not generate any exceptions for these causes. They are effectively disabled in the generated random RISC-V program.

By setting the values accordingly in the exception-generation section, you can control which exceptions are generated in the random program. In this case, the YAML file has been set up to generate 10 illegal instruction exceptions (ecause00, ecause01, and ecause02) and disable the other exceptions (ecause03 to ecause14).

Overall, the exception-generation section allows us to tailor the exception generation behavior according to your testing or verification requirements.

**Screenshot of bug fixed:*

[![Screenshot-263.png](https://i.postimg.cc/3N7SRvvn/Screenshot-263.png)](https://postimg.cc/ZB7Fs0jd)


## Challenge Level 3:

**Opensource RISC-V Design Core: RiscV_Steel_Core*

Here,

We focus on inserting bugs into our design Riscv_Steel_Core.V , and write test cases to expose the Bugs 

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






