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

[![Screenshot-2023-07-31-170552.png](https://i.postimg.cc/ZKRJwBWG/Screenshot-2023-07-31-170552.png)](https://postimg.cc/Jtfwnhcx)


3) Illegal:

Here we have a test file, which runs without exiting in spike and it has an illegal instruction and corresponding handler code, we try to  fix the test 


test.S file is :

 
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  .align 2
  .option norvc

  li TESTNUM, 2
illegal_instruction:
  .word 0              
  j fail
  TEST_PASSFAIL

  .align 8
  .global mtvec_handler
mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause
  bne t0, t1, fail
  csrr t0, mepc

  mret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END


Bug Explanation:

The issue is that the instruction j fail in the illegal_instruction section is not a valid RISC-V instruction. The j instruction is used for jumps (J-type) but requires a label as its target, not an immediate value or register. Since there is no label named fail in the code you've provided, this instruction results in an error.

Bug Fix :

To fix this issue, we'll modify the code in the illegal_instruction section to perform a different operation that causes an illegal instruction exception. One way to do this is by using an invalid opcode, such as add x0, x0, x0, which is essentially a no-operation (NOP) instruction with the ADD opcode.

Here's the corrected code for the illegal_instruction section:

illegal_instruction:
  add x0, x0, x0  # This is an invalid instruction (NOP with ADD opcode) causing an illegal instruction exception
  TEST_PASSFAIL

In this modified code, we use the add instruction with x0 (the zero register) to perform an invalid operation that causes an illegal instruction exception. The TEST_PASSFAIL macro is used to ensure the test still passes or fails based on the overall test results.

Screenshot of Bug Fix:

[![Screenshot-2023-07-31-164759.png](https://i.postimg.cc/Pq5KBHkF/Screenshot-2023-07-31-164759.png)](https://postimg.cc/ts8hxLJh)


**Challenge Level 2**

1) Level 2 (Instruction)

So challenge level 2 is an AAPG generation test and AAPG generation file is given as a part of the program , running the make exposes the problem 
We have to fix the config file to generate the Assembly test 

Bug Explanation:

So the level1 of challenge 2 is here:
we have riscv32i.yaml file and after running the make i have got the following errors:


test.S: Assembler messages:
test.S:159: Error: unrecognized opcode `divuw t6,t3,s0'
test.S:165: Error: unrecognized opcode `remw s0,s8,s2'
test.S:169: Error: unrecognized opcode `remw s6,t1,a1'
test.S:170: Error: unrecognized opcode `mulw s6,s9,s6'
test.S:176: Error: unrecognized opcode `divw s8,t4,s0'
test.S:178: Error: unrecognized opcode `mulw s8,a6,a3'
test.S:184: Error: unrecognized opcode `mulw t5,t1,s6'
test.S:185: Error: unrecognized opcode `divw a3,s9,s9'
test.S:201: Error: unrecognized opcode `mulw s9,a7,t0'
test.S:203: Error: unrecognized opcode `mulw s9,a2,a7'
test.S:206: Error: unrecognized opcode `remuw s4,s7,t3'
test.S:208: Error: unrecognized opcode `mulw gp,s8,t1'
test.S:222: Error: unrecognized opcode `divw s6,a7,a4'
test.S:224: Error: unrecognized opcode `divw t1,s5,a2'
test.S:231: Error: unrecognized opcode `divuw a3,s6,s0'
test.S:232: Error: unrecognized opcode `divuw a6,s9,s0'
test.S:234: Error: unrecognized opcode `divw s0,a0,t2'
test.S:236: Error: unrecognized opcode `divw s9,t1,s6'
test.S:237: Error: unrecognized opcode `remw s6,t2,t0'
test.S:239: Error: unrecognized opcode `divuw s8,s0,s9'
test.S:243: Error: unrecognized opcode `divw s5,s0,s6'
test.S:247: Error: unrecognized opcode `remw s9,s0,s6'
test.S:252: Error: unrecognized opcode `divw s0,s6,s6'
test.S:261: Error: unrecognized opcode `divw s9,s6,s6'
test.S:272: Error: unrecognized opcode `divw s9,t0,a7'
test.S:284: Error: unrecognized opcode `divuw s0,s4,s4'
test.S:287: Error: unrecognized opcode `remuw s2,t6,a3'
test.S:294: Error: unrecognized opcode `remuw s0,t5,t0'
test.S:295: Error: unrecognized opcode `mulw s8,a1,a0'
test.S:297: Error: unrecognized opcode `divw s1,s6,s0'
test.S:299: Error: unrecognized opcode `divuw s0,a4,t0'
test.S:300: Error: unrecognized opcode `remw s1,s9,s6'
test.S:302: Error: unrecognized opcode `divuw s9,s9,s6'
test.S:303: Error: unrecognized opcode `divw s4,s9,s6'
test.S:308: Error: unrecognized opcode `divuw s9,a6,s5'
test.S:310: Error: unrecognized opcode `divuw s0,s0,s0'
test.S:323: Error: unrecognized opcode `divw s8,s6,s6'
test.S:328: Error: unrecognized opcode `mulw s0,s0,s6'
test.S:329: Error: unrecognized opcode `divw s0,zero,t0'
test.S:330: Error: unrecognized opcode `remuw t1,s9,s6'
test.S:331: Error: unrecognized opcode `remw s9,a3,tp'
test.S:332: Error: unrecognized opcode `remuw s6,s8,zero'
test.S:342: Error: unrecognized opcode `remuw a2,a5,s3'
test.S:343: Error: unrecognized opcode `mulw gp,s6,s9'
test.S:369: Error: unrecognized opcode `remw s6,t5,a0'
test.S:375: Error: unrecognized opcode `remuw s4,s2,s2'
test.S:378: Error: unrecognized opcode `divw s2,s6,s6'
test.S:392: Error: unrecognized opcode `mulw s4,zero,a6'
test.S:403: Error: unrecognized opcode `remuw tp,a1,zero'
test.S:428: Error: unrecognized opcode `remw t3,t4,s1'
test.S:429: Error: unrecognized opcode `divw s7,s8,s2'
test.S:431: Error: unrecognized opcode `remuw s9,tp,a4'
test.S:433: Error: unrecognized opcode `divw a7,s7,a1'
test.S:436: Error: unrecognized opcode `remuw s0,s2,a3'
test.S:440: Error: unrecognized opcode `divw a3,s10,a7'
test.S:448: Error: unrecognized opcode `divuw s0,s0,s9'
test.S:450: Error: unrecognized opcode `remuw s6,s9,s0'
test.S:452: Error: unrecognized opcode `remuw s6,a5,s11'
test.S:455: Error: unrecognized opcode `remuw a7,gp,zero'
test.S:465: Error: unrecognized opcode `remw s0,s6,s6'
test.S:481: Error: unrecognized opcode `remuw s9,s6,s6'
test.S:483: Error: unrecognized opcode `divw s6,a0,a7'
test.S:489: Error: unrecognized opcode `remw s3,s10,t4'
test.S:491: Error: unrecognized opcode `divuw s9,t3,s5'
test.S:498: Error: unrecognized opcode `remuw s6,s0,s0'
test.S:500: Error: unrecognized opcode `divw s9,s2,a0'
test.S:503: Error: unrecognized opcode `divw s0,t1,a1'
test.S:504: Error: unrecognized opcode `mulw s6,s0,s6'
test.S:507: Error: unrecognized opcode `divw s1,a2,s5'
test.S:509: Error: unrecognized opcode `remuw a7,s0,s0'
test.S:518: Error: unrecognized opcode `remuw s10,a2,t2'
test.S:519: Error: unrecognized opcode `mulw s4,s0,s6'
test.S:525: Error: unrecognized opcode `mulw a0,s0,s9'
test.S:526: Error: unrecognized opcode `remuw a2,s5,s8'
test.S:527: Error: unrecognized opcode `remw s6,s0,s0'
test.S:528: Error: unrecognized opcode `mulw s6,s9,s6'
test.S:535: Error: unrecognized opcode `divw s6,a3,gp'
test.S:538: Error: unrecognized opcode `divuw a3,t2,t6'
test.S:541: Error: unrecognized opcode `divuw tp,t4,t6'
test.S:542: Error: unrecognized opcode `mulw s0,s6,s0'
test.S:544: Error: unrecognized opcode `remw s0,s6,s6'
test.S:547: Error: unrecognized opcode `remw t5,tp,a5'
test.S:553: Error: unrecognized opcode `divw s0,s0,s0'
test.S:554: Error: unrecognized opcode `divuw s0,s0,s0'
test.S:557: Error: unrecognized opcode `remuw s8,s9,s6'
test.S:558: Error: unrecognized opcode `remw tp,s6,s0'
test.S:563: Error: unrecognized opcode `remuw s9,a6,tp'
test.S:566: Error: unrecognized opcode `mulw zero,s4,zero'
test.S:571: Error: unrecognized opcode `divuw t3,s3,a2'
test.S:576: Error: unrecognized opcode `remw s10,s6,s9'
test.S:578: Error: unrecognized opcode `mulw s0,a1,a0'
test.S:585: Error: unrecognized opcode `divuw s6,s9,s0'
test.S:589: Error: unrecognized opcode `divuw s6,s0,s6'
test.S:591: Error: unrecognized opcode `divuw tp,t2,s4'
test.S:592: Error: unrecognized opcode `mulw s6,a1,t4'
test.S:594: Error: unrecognized opcode `divw s0,s6,s9'
test.S:604: Error: unrecognized opcode `divuw a0,s9,s0'
test.S:620: Error: unrecognized opcode `divw s6,a4,tp'
test.S:621: Error: unrecognized opcode `divuw s0,s6,s6'
test.S:623: Error: unrecognized opcode `remw t1,s1,gp'
test.S:624: Error: unrecognized opcode `remuw zero,t3,s2'
test.S:632: Error: unrecognized opcode `remw s3,s9,s6'
test.S:639: Error: unrecognized opcode `divuw a2,s4,s5'
test.S:640: Error: unrecognized opcode `divw s6,s9,s6'
test.S:653: Error: unrecognized opcode `divw t3,s9,s6'
test.S:654: Error: unrecognized opcode `remw a6,s8,a0'
test.S:656: Error: unrecognized opcode `remw s5,a2,a6'
test.S:657: Error: unrecognized opcode `divuw s9,a5,a5'
test.S:660: Error: unrecognized opcode `divuw s6,s0,s0'
test.S:661: Error: unrecognized opcode `divuw s0,s9,s0'
test.S:663: Error: unrecognized opcode `remuw s9,s6,s9'
test.S:664: Error: unrecognized opcode `mulw a6,s10,a3'
test.S:665: Error: unrecognized opcode `divuw s11,a3,s10'
test.S:667: Error: unrecognized opcode `mulw zero,s9,s0'
test.S:668: Error: unrecognized opcode `mulw s11,s6,s6'
test.S:671: Error: unrecognized opcode `divuw s0,zero,a5'
test.S:672: Error: unrecognized opcode `mulw a7,s0,s9'
test.S:674: Error: unrecognized opcode `remw tp,t3,s11'
test.S:678: Error: unrecognized opcode `divw s6,s0,s9'
test.S:682: Error: unrecognized opcode `divw gp,s9,s0'
test.S:686: Error: unrecognized opcode `divw s0,t1,gp'
test.S:689: Error: unrecognized opcode `divw t5,s0,s9'
test.S:690: Error: unrecognized opcode `remw a4,tp,t0'
test.S:691: Error: unrecognized opcode `divuw a3,s0,s6'
test.S:693: Error: unrecognized opcode `remuw s2,s6,s6'
test.S:694: Error: unrecognized opcode `remw s8,t6,s5'
test.S:696: Error: unrecognized opcode `divw s0,s9,s6'
test.S:700: Error: unrecognized opcode `remuw a3,s0,s0'
test.S:702: Error: unrecognized opcode `mulw s9,s6,s6'
test.S:704: Error: unrecognized opcode `remw s4,t5,zero'
test.S:706: Error: unrecognized opcode `mulw t5,s7,s5'
test.S:707: Error: unrecognized opcode `divuw t5,s6,s6'
test.S:708: Error: unrecognized opcode `remw tp,tp,a6'
test.S:714: Error: unrecognized opcode `divuw s0,s2,t4'
test.S:717: Error: unrecognized opcode `divw s7,s9,s6'
test.S:718: Error: unrecognized opcode `divuw t0,s7,t2'
test.S:727: Error: unrecognized opcode `mulw s9,a7,a5'
test.S:735: Error: unrecognized opcode `remuw t6,a6,s3'
test.S:738: Error: unrecognized opcode `remuw a5,s6,s0'
test.S:739: Error: unrecognized opcode `divw a7,s9,s0'
test.S:740: Error: unrecognized opcode `divuw s1,t4,s5'
test.S:741: Error: unrecognized opcode `divw a7,s9,s6'
test.S:742: Error: unrecognized opcode `divw s0,s3,a6'
test.S:763: Error: unrecognized opcode `remw s9,s9,s6'
test.S:764: Error: unrecognized opcode `remuw zero,s0,s9'
test.S:767: Error: unrecognized opcode `divuw a2,t1,a7'
test.S:768: Error: unrecognized opcode `remuw s9,s3,a4'
test.S:772: Error: unrecognized opcode `divuw s6,s6,s9'
test.S:777: Error: unrecognized opcode `remuw t5,s6,s9'
test.S:779: Error: unrecognized opcode `divuw t0,s9,s9'
test.S:782: Error: unrecognized opcode `divw s9,s6,s9'
test.S:786: Error: unrecognized opcode `remuw s6,s1,a3'
test.S:788: Error: unrecognized opcode `mulw a3,tp,t4'
test.S:793: Error: unrecognized opcode `divuw t1,s6,s0'
test.S:794: Error: unrecognized opcode `divuw t2,s6,s9'
test.S:796: Error: unrecognized opcode `remw s6,s9,s0'
test.S:801: Error: unrecognized opcode `remuw s6,s0,s6'
test.S:805: Error: unrecognized opcode `remuw s3,s9,s9'
test.S:806: Error: unrecognized opcode `remuw t3,s0,s6'
test.S:809: Error: unrecognized opcode `divuw s11,s9,s9'
test.S:810: Error: unrecognized opcode `divuw s6,s6,s9'
test.S:811: Error: unrecognized opcode `remw a6,s4,s8'
test.S:819: Error: unrecognized opcode `remuw a7,tp,s1'
test.S:821: Error: unrecognized opcode `remuw t2,gp,zero'
test.S:832: Error: unrecognized opcode `remw s10,s6,s9'
test.S:833: Error: unrecognized opcode `remuw a1,t3,zero'
test.S:839: Error: unrecognized opcode `remw s9,a5,a7'
test.S:853: Error: unrecognized opcode `mulw s0,s0,s6'
test.S:854: Error: unrecognized opcode `remuw s9,a3,t5'
test.S:869: Error: unrecognized opcode `divw a0,s6,s0'
test.S:877: Error: unrecognized opcode `mulw s0,a1,s2'
test.S:879: Error: unrecognized opcode `divuw s3,tp,s10'
test.S:883: Error: unrecognized opcode `mulw s0,s11,s7'
test.S:887: Error: unrecognized opcode `mulw a1,t2,s10'
test.S:888: Error: unrecognized opcode `divuw s0,s0,s0'
test.S:894: Error: unrecognized opcode `mulw a5,s6,s9'
test.S:899: Error: unrecognized opcode `divuw s9,s9,s9'
test.S:911: Error: unrecognized opcode `divw s11,s5,a4'
test.S:913: Error: unrecognized opcode `remuw s9,gp,s7'
test.S:914: Error: unrecognized opcode `divuw s0,a0,a2'
test.S:922: Error: unrecognized opcode `mulw tp,s0,s0'
test.S:929: Error: unrecognized opcode `divuw s6,s0,s6'
test.S:933: Error: unrecognized opcode `remuw zero,s3,s11'
test.S:934: Error: unrecognized opcode `divuw s0,s1,t0'
test.S:935: Error: unrecognized opcode `divuw zero,s6,s9'
test.S:936: Error: unrecognized opcode `divuw a0,s9,s6'
test.S:945: Error: unrecognized opcode `remuw s9,s1,a4'
test.S:946: Error: unrecognized opcode `remw s6,t4,t3'
test.S:947: Error: unrecognized opcode `divw a4,a5,s3'
test.S:949: Error: unrecognized opcode `divw gp,a6,a1'
test.S:952: Error: unrecognized opcode `mulw a5,s9,s0'
test.S:958: Error: unrecognized opcode `remw s0,s0,s6'
test.S:961: Error: unrecognized opcode `mulw s9,a5,s2'
test.S:967: Error: unrecognized opcode `remuw s0,s6,s0'
test.S:972: Error: unrecognized opcode `divw a1,s9,s6'
test.S:973: Error: unrecognized opcode `divuw t1,s6,s0'
test.S:979: Error: unrecognized opcode `divw s6,a6,s10'
test.S:986: Error: unrecognized opcode `remuw s4,s0,s6'
test.S:987: Error: unrecognized opcode `remw s6,s0,s0'
test.S:989: Error: unrecognized opcode `divw s6,s6,s0'
test.S:992: Error: unrecognized opcode `mulw t2,s6,s6'
test.S:995: Error: unrecognized opcode `divuw a7,s6,s6'
test.S:1013: Error: unrecognized opcode `remuw s3,s11,s11'
test.S:1015: Error: unrecognized opcode `remuw s0,s6,s6'
test.S:1016: Error: unrecognized opcode `divw t1,s3,s2'
test.S:1019: Error: unrecognized opcode `mulw s9,t1,s4'
test.S:1024: Error: unrecognized opcode `mulw s0,s0,s0'
test.S:1028: Error: unrecognized opcode `remw s6,s10,a7'
test.S:1030: Error: unrecognized opcode `remuw zero,t1,a7'
test.S:1031: Error: unrecognized opcode `divuw s9,a5,a5'
test.S:1032: Error: unrecognized opcode `mulw t4,zero,a4'
test.S:1039: Error: unrecognized opcode `mulw s8,s9,s6'
test.S:1049: Error: unrecognized opcode `remuw s10,s0,s9'
test.S:1053: Error: unrecognized opcode `remuw s6,s9,s6'
test.S:1054: Error: unrecognized opcode `remw s9,s2,s4'
test.S:1062: Error: unrecognized opcode `remuw s8,t5,s8'
test.S:1066: Error: unrecognized opcode `mulw s0,s5,a1'
test.S:1068: Error: unrecognized opcode `divuw s0,s6,s0'
test.S:1072: Error: unrecognized opcode `remw s9,s10,s1'
test.S:1075: Error: unrecognized opcode `mulw s6,t0,s1'
test.S:1079: Error: unrecognized opcode `remw s6,s0,s6'
test.S:1080: Error: unrecognized opcode `remw t1,a5,t0'
test.S:1093: Error: unrecognized opcode `divuw s0,s11,t5'
test.S:1097: Error: unrecognized opcode `remw s11,zero,zero'
test.S:1099: Error: unrecognized opcode `mulw s6,s9,s9'
test.S:1102: Error: unrecognized opcode `divuw s9,t3,s5'
test.S:1120: Error: unrecognized opcode `remw s6,a5,t2'
test.S:1131: Error: unrecognized opcode `divuw s1,s6,s0'
test.S:1134: Error: unrecognized opcode `divw s5,s6,s9'
test.S:1145: Error: unrecognized opcode `divuw s0,s0,s6'
test.S:1147: Error: unrecognized opcode `remw t3,s8,a4'
test.S:1148: Error: unrecognized opcode `remuw s9,s9,s9'
test.S:1150: Error: unrecognized opcode `mulw s6,s9,s9'
test.S:1163: Error: unrecognized opcode `divw gp,s11,a4'
test.S:1166: Error: unrecognized opcode `mulw s3,t3,s10'
test.S:1169: Error: unrecognized opcode `mulw zero,s6,s9'
test.S:1174: Error: unrecognized opcode `divw a4,s3,t1'
test.S:1180: Error: unrecognized opcode `remuw s9,s1,a7'
test.S:1183: Error: unrecognized opcode `remw s9,a7,a3'
test.S:1185: Error: unrecognized opcode `mulw a1,s9,s0'
test.S:1186: Error: unrecognized opcode `remuw s6,s6,s6'
test.S:1188: Error: unrecognized opcode `mulw s0,s6,s6'
test.S:1198: Error: unrecognized opcode `mulw s0,s3,t5'
test.S:1200: Error: unrecognized opcode `divw s9,s6,s0'
test.S:1208: Error: unrecognized opcode `remw a3,s0,s9'
test.S:1212: Error: unrecognized opcode `mulw s6,s0,s0'
test.S:1215: Error: unrecognized opcode `divw t2,s0,s0'
test.S:1218: Error: unrecognized opcode `mulw s7,s8,a3'
test.S:1219: Error: unrecognized opcode `remw s4,s0,s6'
test.S:1223: Error: unrecognized opcode `divw a6,s0,s0'
make: *** [Makefile:11: compile] Error 1


Bug Fix and Explanation:

The errors we are encountering indicates that the assembly test file test.S contains instructions that are not recognized by the RISC-V assembler. This could be due to instructions that are not part of the RISC-V RV32I instruction set.

To fix this, we need to modify the riscv32i.yaml file to generate assembly tests that only use instructions from the RV32I instruction set.

To resolve the issue of unrecognized instructions, we need to modify the isa-instruction-distribution section in the rv32i.yaml file to ensure that only instructions from the RV32I base integer instruction set are generated.

Here's the updated rv32i.yaml file with the changes:

priv-mode:
  mode: m

general:
  total_instructions: 1000
  regs_not_use: x1,x2
  custom_trap_handler: false
  code_start_address: 0x80000000
  default_program_exit: true
  delegation: 0x0

isa-instruction-distribution:
  rel_sys: 0
  rel_sys.csr: 0
  rel_rv32i.ctrl: 0
  rel_rv32i.compute: 100    # Set this to 100 to generate only RV32I base integer instructions
  rel_rv32i.data: 0
  rel_rv32i.fence: 0
  rel_rv64i.compute: 0
  rel_rv64i.data: 0
  rel_rv32i.zba: 0
  rel_rv64i.zba: 0
  rel_rv32i.zbb: 0
  rel_rv64i.zbb: 0
  rel_rv32i.zbc: 0
  rel_rv32i.zbs: 0
  rel_rv32i.zbe: 0
  rel_rv64i.zbe: 0
  rel_rv32i.zbf: 0
  rel_rv64i.zbf: 0
  rel_rv64i.zbm: 0
  rel_rv32i.zbp: 0
  rel_rv64i.zbp: 0
  rel_rv32i.zbr: 0
  rel_rv64i.zbr: 0
  rel_rv32i.zbt: 0
  rel_rv64i.zbt: 0
  rel_rv32m: 0
  rel_rv64m: 0
  rel_rv32a: 0
  rel_rv64a: 0
  rel_rv32f: 0
  rel_rv64f: 0
  rel_rv32d: 0
  rel_rv64d: 0

# Compressed instructions

  rel_rvc.ctrl: 0
  rel_rvc.compute: 0
  rel_rvc.sp: 0
  rel_rvc.data: 0
  rel_rvc.fdata: 0

  rel_rv32c.compute: 0
  rel_rv32c.ctrl: 0
  rel_rv32c.fdata: 0

  rel_rv64c.compute: 0
  rel_rv64c.data: 0

float-rounding:
  rne: 10
  rtz: 10
  rdn: 10
  rup: 10
  rmm: 10

branch-control:
  backward-probability: 0.5
  block-size: 7

recursion-options:
  recursion-enable: false
  recursion-depth: 10
  recursion-calls: 5


Screenshot of Bug Fix:

[![Screenshot-2023-07-31-171248.png](https://i.postimg.cc/3wJRQSNw/Screenshot-2023-07-31-171248.png)](https://postimg.cc/75dDgNgv)


Challenge Level 2 : Exceptions

This is an AAPG  generation test setup
Here with expereince from the previous challenge ,we create a AAPG config file to generate  a test with 10 illegal exceptions with the correct handler code 

To generate a test with 10 illegal exceptions and the correct handler code using AAPG, we will need to modify the AAPG configuration file (rv32i.yaml) accordingly. Specifically, we need to define the handler code for each illegal exception and ensure that the test runs successfully on Spike.

i)Yaml File Creation:

Here the The YAML file serves as a configuration file that provides instructions to AAPG on how to generate a random RISC-V program.
The YAML file was created manually to configure the behavior of the Automated Assembly Program Generator (AAPG) tool.
It contains various sections, each specifying different aspects of the program generation process. The sections and their respective options are defined with the help of keys and values in the YAML format.

The configuration file is created using a text editor, and each section is organized hierarchically using indentation. The values specified in the YAML file influence the frequency and distribution of instructions, privilege modes, data access sections, CSR (Control and Status Register) sections, recursion options, self-checking settings, exception generation, cache thrashing, and more.

ii) Exceptions Generation Explanation

In the YAML file, there is a section called exception-generation, which is responsible for controlling the generation of exceptions in the random RISC-V program. Each exception cause is represented by a key (e.g., ecause00, ecause01, etc.) and its corresponding value determines the number of exceptions generated for that particular cause.

Here's an explanation of how exceptions are generated based on the exception-generation section:

For ecause00, ecause01, and ecause02, the value is set to 10. This means that AAPG will generate 10 exceptions for each of these exception causes (10 exceptions for ecause00, 10 for ecause01, and 10 for ecause02). These causes are considered as illegal instruction exceptions.

For ecause03 to ecause14, the value is set to 0. This means that AAPG will not generate any exceptions for these causes. They are effectively disabled in the generated random RISC-V program.

By setting the values accordingly in the exception-generation section, you can control which exceptions are generated in the random program. In this case, the YAML file has been set up to generate 10 illegal instruction exceptions (ecause00, ecause01, and ecause02) and disable the other exceptions (ecause03 to ecause14).

Overall, the exception-generation section allows us to tailor the exception generation behavior according to your testing or verification requirements.

Screenshot of bug fixed:

[![Screenshot-263.png](https://i.postimg.cc/3N7SRvvn/Screenshot-263.png)](https://postimg.cc/ZB7Fs0jd)


Challenge Level 3:

**Opensource RISC-V Design Core: RiscV_Steel_Core**

Here,

We focus on inserting bugs into our design Riscv_Steel_Core.V , and write test cases to expose the Bugs 

Explanation of the Bugs introduced into Riscv_Steel_Core.v

Bug 1: Incorrect CSR Write Data
In the always @* begin : csr_data_out_mux block, introduced a bug that causes incorrect CSR data to be read from the csr_data_out register.

always @(posedge clock) begin : csr_data_out_mux
    case (instruction_csr_address_stage3)
      MARCHID:       csr_data_out = 32'h00000018; // RISC-V Steel microarchitecture ID
      MIMPID:        csr_data_out = 32'h00000005; // Version 5 
      CYCLE:         csr_data_out = mcycle    [31:0 ];
      CYCLEH:        csr_data_out = mcycle    [63:32];
      TIME:          csr_data_out = utime     [31:0 ];
      TIMEH:         csr_data_out = utime     [63:32];
      INSTRET:       csr_data_out = minstret  [31:0 ];
      INSTRETH:      csr_data_out = minstret  [63:32];
      MSTATUS:       csr_data_out = mstatus;
      MSTATUSH:      csr_data_out = 32'h00000000;
      MISA:          csr_data_out = 32'h40000100; // RV32I base ISA only
      MIE:           csr_data_out = mie;
      MTVEC:         csr_data_out = mtvec;
      MSCRATCH:      csr_data_out = mscratch;
      MEPC:          csr_data_out = mepc;
      MCAUSE:        csr_data_out = mcause;
      MTVAL:         csr_data_out = mtval;
      MIP:           csr_data_out = mip;
      MCYCLE:        csr_data_out = mcycle; // BUG: Incorrect CSR data assignment, should be [31:0]
      MCYCLEH:       csr_data_out = mcycle    [63:32];
      MINSTRET:      csr_data_out = minstret  [31:0 ];
      MINSTRETH:     csr_data_out = minstret  [63:32];
      default:       csr_data_out = 32'h00000000;
    endcase
end

Bug 2: Incorrect Load Data
In the always @* begin : load_size_mux block, introduced a bug that causes incorrect data to be loaded from memory for byte and half-word loads.

always @* begin : load_size_mux
    case (load_size_stage3)
      LOAD_SIZE_BYTE:
        load_data = {byte_data_upper_bits, data_in}; // BUG: Should load only 8 bits instead of the entire 32 bits
      LOAD_SIZE_HALF:
        load_data = {half_data_upper_bits, data_in}; // BUG: Should load only 16 bits instead of the entire 32 bits
      LOAD_SIZE_WORD:
        load_data = data_in;
      default:
        load_data = data_in;
    endcase
end


Bug 3: Incorrect Branch Condition
In the always @* begin : branch_condition_satisfied_mux block,  introduced a bug that causes incorrect branch condition determination.

always @* begin : branch_condition_satisfied_mux
    case (instruction_funct3)
      FUNCT3_BEQ:
        branch_condition_satisfied =
          is_not_equal; // BUG: Incorrect condition for BEQ, should be is_equal
      FUNCT3_BNE:
        branch_condition_satisfied =
          is_not_equal;
      FUNCT3_BLT:
        branch_condition_satisfied =
          is_less_than;
      FUNCT3_BGE:
        branch_condition_satisfied =
          is_greater_or_equal_than;
      FUNCT3_BLTU:
        branch_condition_satisfied =
          is_less_than_unsigned;
      FUNCT3_BGEU:
        branch_condition_satisfied =
          is_greater_or_equal_than_unsigned;
      default:
        branch_condition_satisfied =
          1'b0;
    endcase
end

Test cases to expose these Bugs:

Here,
We focus on test cases that cover different instruction types, load/store instructions, and branches.


#Test to expose Bug 1: Incorrect CSR Write Data
#Initialize mcycle and mtvec registers
    li t0, 0x1               # Load t0 with value 1
    csrw mcycle, t0          # Write value in t0 to mcycle
    la t1, trap_handler      # Load t1 with the address of the trap handler
    csrw mtvec, t1           # Write address in t1 to mtvec
    csrr t2, mcycleh         # Read from mcycleh (Expecting 0x00000000)
    csrr t3, mcycle          # Read from mcycle  (Expecting 0x00000001)
    bne t2, zero, csr_bug_fail   # If mcycleh is not 0, fail the test
    bne t3, t0, csr_bug_fail      # If mcycle is not 1, fail the test
    csrr t2, mhartid         # Read from mhartid to clear the test (MARCHID is read-only)
    csrr t3, mhartid         # Read from mhartid to clear the test (MARCHID is read-only)
    bne t2, t3, csr_bug_fail      # If t2 and t3 are not the same, fail the test
    j csr_bug_pass           # Jump to the end of the test (pass)

csr_bug_fail:
    li t0, 0                 # Load t0 with 0 to indicate test failure
    j csr_bug_end

csr_bug_pass:
    li t0, 1                 # Load t0 with 1 to indicate test pass

csr_bug_end:
    csrw mscratch, t0        # Store the result in mscratch for verification

#Test to expose Bug 2: Incorrect Load Data
    li t0, 0xABCDEF01        # Load t0 with value 0xABCDEF01
    lb t1, 0(t0)             # Load a byte from address pointed by t0 (Expecting 0xFFFFFF01)
    li t2, 0xFFFFFF01        # Load t2 with expected result
    bne t1, t2, load_bug_fail   # If t1 is not equal to t2, fail the test

    lh t1, 0(t0)             # Load a half-word from address pointed by t0 (Expecting 0xFFFFEF01)
    li t2, 0xFFFFEF01        # Load t2 with expected result
    bne t1, t2, load_bug_fail   # If t1 is not equal to t2, fail the test

    lw t1, 0(t0)             # Load a word from address pointed by t0 (Expecting 0xABCDEF01)
    li t2, 0xABCDEF01        # Load t2 with expected result
    bne t1, t2, load_bug_fail   # If t1 is not equal to t2, fail the test

    j load_bug_pass          # Jump to the end of the test (pass)

load_bug_fail:
    li t0, 0                 # Load t0 with 0 to indicate test failure
    j load_bug_end

load_bug_pass:
    li t0, 1                 # Load t0 with 1 to indicate test pass

load_bug_end:
    csrw mscratch, t0        # Store the result in mscratch for verification

#Test to expose Bug 3: Incorrect Branch Condition
    li t0, 0x1               # Load t0 with value 1
    li t1, 0x2               # Load t1 with value 2
    beq t0, t1, branch_bug_fail   # Branch should not be taken (t0 != t1)
    j branch_bug_pass        # Jump to the end of the test (pass)

branch_bug_fail:
    li t0, 0                 # Load t0 with 0 to indicate test failure
    j branch_bug_end

branch_bug_pass:
    li t0, 1                 # Load t0 with 1 to indicate test pass

branch_bug_end:
    csrw mscratch, t0        # Store the result in mscratch for verification

#Trap handler for CSR Bug test
trap_handler:
    csrr t0, mepc            # Load t0 with the value of mepc (trap return address)
    addi t0, t0, 4           # Increment mepc by 4 (to skip the csrr instruction)
    csrw mepc, t0            # Write back the updated mepc value
    mret                     # Perform mret to return from trap

#Trap handler for Load Bug test
    csrr t0, mepc            # Load t0 with the value of mepc (trap return address)
    addi t0, t0, 4           # Increment mepc by 4 (to skip the lb instruction)
    csrw mepc, t0            # Write back the updated mepc value
    mret                     # Perform mret to return from trap

#Trap handler for Branch Bug test
    csrr t0, mepc            # Load t0 with the value of mepc (trap return address)
    addi t0, t0, 4           # Increment mepc by 4 (to skip the beq instruction)
    csrw mepc, t0            # Write back the updated mepc value
    mret                     # Perform mret to return from trap

This test file "test.S" contains three tests, each designed to expose one of the bugs we introduced earlier. It uses the RISC-V assembly language to write the test cases for the bugs in the design. The test cases aim to execute specific instructions that trigger the bugs and then verify the results by comparing them with the expected values.






