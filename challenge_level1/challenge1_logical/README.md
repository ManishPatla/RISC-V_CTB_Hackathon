# Challenge Level 1:

## Logical :

Screnshot of the Bug:

<img width="332" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/53c7a165-afc9-4589-bfcd-c46cef859cf8">

**Bug Explanation:**
During the challenge, we encountered a logical bug in the "add" instruction implementation.

1) ### test.S:15855: Error: illegal operands 'and s7, ra, z4'

The instruction here is : and s7, ra, z4.
The error message indicates that there is an issue with the operands used in this instruction.
The and instruction is a bitwise AND operation, and it expects three registers as operands: and dest, source1, source2.
s7, ra, and z4 are register names, and the assembler is reporting that there's something wrong with how they are used in this instruction.

2) ### test.S:25584: Error: illegal operands 'andi s5, t1, s0'

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

Fixed Instruction:
and s7, ra, t0
&
andi s5, t1, 42

<img width="699" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/f7c7bafc-936f-476d-9931-b6bd63e2343f">


**Verification Strategy Used**:
**combination of manual code review and functional testing*
Overall, the verification strategy here used a combination of manual inspection and automated functional testing to identify and fix the logical bug in the RISC-V assembly code. This approach enables effective bug detection and reporting, leading to continuous improvement in the design and verification process.
