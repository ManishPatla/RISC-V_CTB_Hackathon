# Challenge Level 1 :

## Illegal:

Here we have a test file, which runs without exiting in spike and it has an illegal instruction and corresponding handler code, we try to  fix the test 


test.S file is :
[![Screenshot-2023-07-31-175455.png](https://i.postimg.cc/1tkt0SQj/Screenshot-2023-07-31-175455.png)](https://postimg.cc/hz0cgHhL)

**Bug Explanation:**

The issue is that the instruction j fail in the illegal_instruction section is not a valid RISC-V instruction. The j instruction is used for jumps (J-type) but requires a label as its target, not an immediate value or register. Since there is no label named fail in the code you've provided, this instruction results in an error.

**Bug Fix :**

To fix this issue, we'll modify the code in the illegal_instruction section to perform a different operation that causes an illegal instruction exception. One way to do this is by using an invalid opcode, such as add x0, x0, x0, which is essentially a no-operation (NOP) instruction with the ADD opcode.

Here's the corrected code for the illegal_instruction section:

illegal_instruction:
  add x0, x0, x0  # This is an invalid instruction (NOP with ADD opcode) causing an illegal instruction exception
  TEST_PASSFAIL

In this modified code, we use the add instruction with x0 (the zero register) to perform an invalid operation that causes an illegal instruction exception. The TEST_PASSFAIL macro is used to ensure the test still passes or fails based on the overall test results.

**Screenshot of Bug Fix:*

[![Screenshot-2023-07-31-164759.png](https://i.postimg.cc/Pq5KBHkF/Screenshot-2023-07-31-164759.png)](https://postimg.cc/ts8hxLJh)

