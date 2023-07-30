#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_RR_OP( 2,  add, 0x00000001, 0x00000001, 0x00000000 );
  TEST_RR_OP( 3,  add, 0x00000002, 0x00000001, 0x00000001 ); // Check positive addition
  TEST_RR_OP( 4,  add, 0xFFFFFFFE, 0xFFFFFFFF, 0x00000001 ); // Check negative addition
  TEST_RR_OP( 5,  add, 0x80000000, 0x7FFFFFFF, 0x00000001 ); // Check addition with overflow

  TEST_RR_OP( 6,  sub, 0x00000000, 0x00000001, 0x00000001 ); // Check positive subtraction
  TEST_RR_OP( 7,  sub, 0xFFFFFFFF, 0x00000001, 0x00000002 ); // Check negative subtraction
  TEST_RR_OP( 8,  sub, 0x7FFFFFFF, 0x80000000, 0x00000001 ); // Check subtraction with overflow

  TEST_RR_OP( 9,  and, 0x00000000, 0xFFFFFFFF, 0x00000000 ); // Check bitwise AND
  TEST_RR_OP( 10, or,  0xFFFFFFFF, 0xFFFFFFFF, 0x00000000 ); // Check bitwise OR
  TEST_RR_OP( 11, xor, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF ); // Check bitwise XOR

  TEST_RR_OP( 12, sll, 0x00000002, 0x00000001, 0x00000001 ); // Check logical left shift
  TEST_RR_OP( 13, srl, 0x00000000, 0x00000001, 0x00000001 ); // Check logical right shift

  // TODO: Add more test cases for other instructions and edge cases

  TEST_PASSFAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
