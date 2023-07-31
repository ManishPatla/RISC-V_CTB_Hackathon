# RV32I ISA Test

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 1,  add, 0x00000001, 0x00000001, 0x00000000 );
  TEST_RR_OP( 2,  add, 0xFFFFFFFF, 0x00000001, 0xFFFFFFFE );
  TEST_RR_OP( 3,  sub, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 4,  sub, 0xFFFFFFFF, 0x00000001, 0x00000002 );
  TEST_RR_OP( 5,  mul, 0x00000000, 0x00000001, 0x00000000 );
  TEST_RR_OP( 6,  mul, 0x00000001, 0x00000001, 0x00000001 );
  TEST_RR_OP( 7,  mul, 0xFFFFFFFE, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_OP( 8,  mul, 0xFFFFFFFE, 0xFFFFFFFF, 0x00000002 );
  TEST_RR_OP( 9,  div, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 10, div, 0xFFFFFFFF, 0x00000001, 0xFFFFFFFE );
  TEST_RR_OP( 11, divu, 0x00000001, 0x00000001, 0x00000001 );
  TEST_RR_OP( 12, divu, 0x7FFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE );
  TEST_RR_OP( 13, rem, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 14, rem, 0x00000000, 0x00000001, 0x00000002 );
  TEST_RR_OP( 15, rem, 0xFFFFFFFF, 0x00000001, 0xFFFFFFFE );
  TEST_RR_OP( 16, remu, 0x00000000, 0x00000001, 0x00000001 );
  TEST_RR_OP( 17, remu, 0x00000001, 0x00000001, 0x00000002 );
  TEST_RR_OP( 18, remu, 0xFFFFFFFF, 0x00000001, 0xFFFFFFFE );

  #-------------------------------------------------------------
  # Logical tests
  #-------------------------------------------------------------

  TEST_RR_OP( 19, and, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 20, and, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_OP( 21, and, 0x00000000, 0xFFFFFFFF, 0x00000000 );
  TEST_RR_OP( 22, or, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 23, or, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_RR_OP( 24, or, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF );
  TEST_RR_OP( 25, xor, 0x00000000, 0x00000000, 0x00000000 );
  TEST_RR_OP( 26, xor, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000 );
  TEST_RR_OP( 27, xor, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF );
  TEST_R_OP( 28,  lui, 0x00000000, 0x00000000 );
  TEST_R_OP( 29,  lui, 0xFFFFFFFF, 0xFFFFFFFF );

  #-------------------------------------------------------------
  # Control transfer tests
  #-------------------------------------------------------------

  TEST_IMM_OP( 30,  auipc, x1, 0x00001000 );
  TEST_IMM_OP( 31,  auipc, x1, 0xFFFFF000 );
  TEST_IMM_OP( 32,  auipc, x1, 0x80000000 );
  TEST_IMM_OP( 33,  auipc, x1, 0x7FFFFFFF );

  TEST_IMM_OP( 34,  lui, x1, 0x00001000 );
  TEST_IMM_OP( 35,  lui, x1, 0xFFFFF000 );
  TEST_IMM_OP( 36,  lui, x1, 0x80000000 );
  TEST_IMM_OP( 37,  lui, x1, 0x7FFFFFFF );

  TEST_BRANCH_OP( 38,  beq, 1 );
  TEST_BRANCH_OP( 39,  bne, 1 );
  TEST_BRANCH_OP( 40,  blt, 1 );
  TEST_BRANCH_OP( 41,  bltu, 1 );
  TEST_BRANCH_OP( 42,  bge, 1 );
  TEST_BRANCH_OP( 43,  bgeu, 1 );

  #-------------------------------------------------------------
  # Memory access tests
  #-------------------------------------------------------------

  TEST_LD_OP( 44, lb, 0x00000000, 0xFF, 0xFFFFFFFF );
  TEST_LD_OP( 45, lbu, 0x00000000, 0xFF, 0xFFFFFFFF );
  TEST_LD_OP( 46, lh, 0x00000000, 0xFFFF, 0xFFFFFFFF );
  TEST_LD_OP( 47, lhu, 0x00000000, 0xFFFF, 0xFFFFFFFF );
  TEST_LD_OP( 48, lw, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF );

  TEST_ST_OP( 49, sb, 0xFFFFFFFF, 0x000000FF, 0xFFFFFFFF );
  TEST_ST_OP( 50, sh, 0xFFFFFFFF, 0x0000FFFF, 0xFFFFFFFF );
  TEST_ST_OP( 51, sw, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF );

  #-------------------------------------------------------------
  # System call test
  #-------------------------------------------------------------

  TEST_SYSTEMCALL_OP( 52, 1 ); // Print integer value
  TEST_SYSTEMCALL_OP( 53, 2 ); // Exit

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
