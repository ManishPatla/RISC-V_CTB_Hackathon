# riscv_ctb_challenges

Challenge Level 1: Logical,Loop,Illegal

1)Logical:

Screnshot of the Bug:

<img width="332" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/53c7a165-afc9-4589-bfcd-c46cef859cf8">


Bug Explanation:
During the challenge, we encountered a logical bug in the "add" instruction implementation.

1)
##test.S:15855: Error: illegal operands 'and s7, ra, z4'

The instruction here is : and s7, ra, z4.
The error message indicates that there is an issue with the operands used in this instruction.
The and instruction is a bitwise AND operation, and it expects three registers as operands: and dest, source1, source2.
s7, ra, and z4 are register names, and the assembler is reporting that there's something wrong with how they are used in this instruction.

2)
##test.S:25584: Error: illegal operands 'andi s5, t1, s0'

The instruction here is andi s5, t1, s0.
The error message again indicates an issue with the operands used in this instruction.
The andi instruction is an immediate bitwise AND operation, and it also expects three registers as operands: andi dest, source1, imm.
s5, t1, and s0 are register names, and the assembler is reporting that there's a problem with how they are used in this instruction.

##Common reasons for these types of errors could be:

Incorrect register names or typos.
Incorrect syntax in the instructions.

Bug Fix Explanation :

1)The error message test.S:15855: Error: illegal operands 'and s7, ra, z4' indicates that there's an issue with the usage of register z4. Since z4 is a zero register and cannot be written to, it cannot be used as a source or destination in an instruction like and.

To resolve this issue, you should use a valid general-purpose register (e.g., x0, x1, ..., x31) instead of z4 in the instruction at line 15855.

2)In RISC-V assembly, immediate instructions like andi expect a constant immediate value as one of the operands. The immediate value is a fixed constant value that is used in the operation, and it is not represented by a register.

Screenshot of Bug Fix:

Fixed Instruction:
and s7, ra, t0
&
andi s5, t1, 42

<img width="699" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/f7c7bafc-936f-476d-9931-b6bd63e2343f">



2)Loop:


Bug Explanation:

We have an test file which runs without exiting the spike here the test performs addition operation and self checks for 3 set of test cases

Analysisng Test.S file here :

<img width="245" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/1857aeaa-42b2-4a10-8f45-cae55dae9f5b">


Here the test file is designed to perform addition operations and check the results against expected values. However, there seems to be an issue with the comparison and failure detection in the loop.


Bug Fix Solution:

To fix the test, we need to adjust the comparison and failure detection logic in the loop. The current code uses beq instruction to check if t3 (the expected sum) is equal to t4 (the computed sum). However, beq only branches when the two operands are equal. In this case, we need to branch when they are not equal, indicating a failure.

Here's the fixed code for the loop:

loop:
  lw t1, (t0)
  lw t2, 4(t0)
  lw t3, 8(t0)
  add t4, t1, t2
  addi t0, t0, 12

  bne t3, t4, fail   # Branch if the expected sum is not equal to the computed sum

  # Decrement the test case counter
  li t6, -1
  add t5, t5, t6

  bnez t5, loop      # If t5 is not zero, continue to the next test case

test_end:
test_end:


#The changes made here:

We used the bne (branch not equal) instruction to check if t3 is not equal to t4.
If the condition is true (the expected sum is not equal to the computed sum), it jumps to the fail label.
We also introduced a test case counter using t5 (initialized to 3) to keep track of the number of remaining test cases.
After each iteration, we decrement the test case counter using sub t5, t5, 1.
If the test case counter t5 is not zero (bnez t5, loop), we continue to the next test case.
The loop now iterates through all the test cases and performs the addition operation correctly while checking for failures. If there's any mismatch between the expected and computed sums, the test will jump to the fail label.

Screenshot of the Bug Fix:
























....................................................................................................


