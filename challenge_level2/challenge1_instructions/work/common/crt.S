#include "encoding.h"

#if __riscv_xlen == 64
  # define LREG ld
  # define LREGU lwu
  # define SREG sd
  # define REGBYTES 8
  # define FMV fmv.d.x
#else
  # define LREG lw
  # define SREG sw
  # define LREGU lw
  # define REGBYTES 4
  # define FMV fmv.w.x
#endif

  .section ".text.init"
  .globl _start
_start:
  la sp, begin_signature
  LREG  x1, 0*REGBYTES(sp)
  LREG  x3, 1*REGBYTES(sp)
  LREG  x4, 2*REGBYTES(sp)
  LREG  x5, 3*REGBYTES(sp)
  LREG  x6, 4*REGBYTES(sp)
  LREG  x7, 5*REGBYTES(sp)
  LREG  x8, 6*REGBYTES(sp)
  LREG  x9, 7*REGBYTES(sp)
  LREG  x10,8*REGBYTES(sp)
  LREG  x11,9*REGBYTES(sp)
  LREG  x12,10*REGBYTES(sp)
  LREG  x13,11*REGBYTES(sp)
  LREG  x14,12*REGBYTES(sp)
  LREG  x15,13*REGBYTES(sp)
  LREG  x16,14*REGBYTES(sp)
  LREG  x17,15*REGBYTES(sp)
  LREG  x18,16*REGBYTES(sp)
  LREG  x19,17*REGBYTES(sp)
  LREG  x20,18*REGBYTES(sp)
  LREG  x21,19*REGBYTES(sp)
  LREG  x22,20*REGBYTES(sp)
  LREG  x23,21*REGBYTES(sp)
  LREG  x24,22*REGBYTES(sp)
  LREG  x25,23*REGBYTES(sp)
  LREG  x26,24*REGBYTES(sp)
  LREG  x27,25*REGBYTES(sp)
  LREG  x28,26*REGBYTES(sp)
  LREG  x29,27*REGBYTES(sp)
  LREG  x30,28*REGBYTES(sp)
  LREG  x31,29*REGBYTES(sp)

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  li a0, 1
  sw a0, tohost, t0
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  FMV  f0, x1
  FMV  f1, x1
  FMV  f2, x2
  FMV  f3, x3
  FMV  f4, x4
  FMV  f5, x5
  FMV  f6, x6
  FMV  f7, x7
  FMV  f8, x8
  FMV  f9, x9
  FMV  f10, x10
  FMV  f11, x11
  FMV  f12, x12
  FMV  f13, x13
  FMV  f14, x14
  FMV  f15, x15
  FMV  f16, x16
  FMV  f17, x17
  FMV  f18, x18
  FMV  f19, x19
  FMV  f20, x20
  FMV  f21, x21
  FMV  f22, x22
  FMV  f23, x23
  FMV  f24, x24
  FMV  f25, x25
  FMV  f26, x26
  FMV  f27, x27
  FMV  f28, x28
  FMV  f29, x29
  FMV  f30, x30
  FMV  f31, x31
  .align 4
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

  j main

  .align 2
trap_entry:
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause                 # copy the mcause to register a0.
  csrr a1, mepc                   # copy the mepc to register a1.
  lhu  a2, 0(a1)                  # load instruction into reg a1.

  # check the lower 2 bits to see if the instruction is 32-bit or 16-bit.
  andi a2, a2, 0x3;
  li t0, 0x3
  bne a2,t0,inst16

  inst32:                           # is 32-bit instruction then increment by 4
  addi a1,a1,0x4
  beqz x0,1f

inst16:
  addi a1,a1,0x2                  # is 16-bit instruction then increment by 2

1: 
  csrw mepc, a1                   # point mepc to the next instruction.

  # use mcause to update the number of exceptions encountered in the program.

  # Remain in M-mode after eret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  mret

.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:

.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0

# Exception generation numbers
.align 4
.globl ecause_num
ecause_num:
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0

# Read only data
.section ".rodata"
.globl rodata
rodata:
    	.dword 0x5b707269762d6d6f
	.dword 0x64655d0a6d6f6465
	.dword 0x203d206d0a5b6765
	.dword 0x6e6572616c5d0a74
	.dword 0x6f74616c5f696e73
	.dword 0x7472756374696f6e
	.dword 0x73203d2031303030
	.dword 0x0a726567735f6e6f
	.dword 0x745f757365203d20
	.dword 0x78312c78320a6375
	.dword 0x73746f6d5f747261
	.dword 0x705f68616e646c65
	.dword 0x72203d2046616c73
	.dword 0x650a636f64655f73
	.dword 0x746172745f616464
	.dword 0x72657373203d2032
	.dword 0x3134373438333634
	.dword 0x380a64656661756c
	.dword 0x745f70726f677261
	.dword 0x6d5f65786974203d
	.dword 0x20547275650a6465
	.dword 0x6c65676174696f6e
	.dword 0x203d20300a5b6973
	.dword 0x612d696e73747275
	.dword 0x6374696f6e2d6469
	.dword 0x7374726962757469
	.dword 0x6f6e5d0a72656c5f
	.dword 0x737973203d20300a
	.dword 0x72656c5f7379732e
	.dword 0x637372203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e6374726c203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e636f6d
	.dword 0x70757465203d2031
	.dword 0x30300a72656c5f72
	.dword 0x763332692e646174
	.dword 0x61203d20300a7265
	.dword 0x6c5f72763332692e
	.dword 0x66656e6365203d20
	.dword 0x300a72656c5f7276
	.dword 0x3634692e636f6d70
	.dword 0x757465203d20300a
	.dword 0x72656c5f72763634
	.dword 0x692e64617461203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6261
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6261203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6262203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a6262203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6263
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6273203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6265203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a6265203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6266
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6266203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a626d203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6270203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a6270
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6272203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a6272203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6274203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a6274
	.dword 0x203d20300a72656c
	.dword 0x5f727633326d203d
	.dword 0x20300a72656c5f72
	.dword 0x7636346d203d2030
	.dword 0x0a72656c5f727633
	.dword 0x3261203d20300a72
	.dword 0x656c5f7276363461
	.dword 0x203d20300a72656c
	.dword 0x5f7276333266203d
	.dword 0x20300a72656c5f72
	.dword 0x76363466203d2030
	.dword 0x0a72656c5f727633
	.dword 0x3264203d20300a72
	.dword 0x656c5f7276363464
	.dword 0x203d20300a72656c
	.dword 0x5f7276632e637472
	.dword 0x6c203d20300a7265
	.dword 0x6c5f7276632e636f
	.dword 0x6d70757465203d20
	.dword 0x300a72656c5f7276
	.dword 0x632e7370203d2030
	.dword 0x0a72656c5f727663
	.dword 0x2e64617461203d20
	.dword 0x300a72656c5f7276
	.dword 0x632e666461746120
	.dword 0x3d20300a72656c5f
	.dword 0x72763332632e636f
	.dword 0x6d70757465203d20
	.dword 0x300a72656c5f7276
	.dword 0x3332632e6374726c
	.dword 0x203d20300a72656c
	.dword 0x5f72763332632e66
	.dword 0x64617461203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34632e636f6d7075
	.dword 0x7465203d20300a72
	.dword 0x656c5f7276363463
	.dword 0x2e64617461203d20
	.dword 0x300a5b666c6f6174
	.dword 0x2d726f756e64696e
	.dword 0x675d0a726e65203d
	.dword 0x2031300a72747a20
	.dword 0x3d2031300a72646e
	.dword 0x203d2031300a7275
	.dword 0x70203d2031300a72
	.dword 0x6d6d203d2031300a
	.dword 0x5b6272616e63682d
	.dword 0x636f6e74726f6c5d
	.dword 0x0a6261636b776172
	.dword 0x642d70726f626162
	.dword 0x696c697479203d20
	.dword 0x302e350a626c6f63
	.dword 0x6b2d73697a65203d
	.dword 0x20370a5b72656375
	.dword 0x7273696f6e2d6f70
	.dword 0x74696f6e735d0a72
	.dword 0x6563757273696f6e
	.dword 0x2d656e61626c6520
	.dword 0x3d2046616c73650a
	.dword 0x726563757273696f
	.dword 0x6e2d646570746820
	.dword 0x3d2031300a726563
	.dword 0x757273696f6e2d63
	.dword 0x616c6c73203d2035
	.dword 0x0a5b616363657373
	.dword 0x2d73656374696f6e
	.dword 0x735d0a626567696e
	.dword 0x5f7369676e617475
	.dword 0x7265203d20307838
	.dword 0x303039313030302c
	.dword 0x3078383030393530
	.dword 0x30302c72770a5b63
	.dword 0x73722d7365637469
	.dword 0x6f6e735d0a736563
	.dword 0x74696f6e73203d20
	.dword 0x3078303130303a30
	.dword 0x786466662c203078
	.dword 0x3332352c20307835
	.dword 0x30303a3078666666
	.dword 0x0a5b757365722d66
	.dword 0x756e6374696f6e73
	.dword 0x5d0a66756e633120
	.dword 0x3d207b303a226164
	.dword 0x642078302c78302c
	.dword 0x7830227d0a5b7377
	.dword 0x697463682d707269
	.dword 0x762d6d6f6465735d
	.dword 0x0a7377697463685f
	.dword 0x6d6f646573203d20
	.dword 0x46616c73650a6e75
	.dword 0x6d5f737769746368
	.dword 0x6573203d20300a5b
	.dword 0x692d63616368655d
	.dword 0x0a6e756d5f63616c
	.dword 0x6c73203d20300a6e
	.dword 0x756d5f6279746573
	.dword 0x5f7065725f626c6f
	.dword 0x636b203d2031360a
	.dword 0x6e756d5f626c6f63
	.dword 0x6b73203d20380a6e
	.dword 0x756d5f6379636c65
	.dword 0x73203d2031300a5b
	.dword 0x642d63616368655d
	.dword 0x0a6e756d5f63616c
	.dword 0x6c73203d20300a6e
	.dword 0x756d5f6279746573
	.dword 0x5f7065725f626c6f
	.dword 0x636b203d2031360a
	.dword 0x6e756d5f626c6f63
	.dword 0x6b73203d20380a6e
	.dword 0x756d5f6379636c65
	.dword 0x73203d2031300a5b
	.dword 0x657863657074696f
	.dword 0x6e2d67656e657261
	.dword 0x74696f6e5d0a6563
	.dword 0x617573653030203d
	.dword 0x20300a6563617573
	.dword 0x653031203d20300a
	.dword 0x6563617573653032
	.dword 0x203d20300a656361
	.dword 0x7573653033203d20
	.dword 0x300a656361757365
	.dword 0x3034203d20300a65
	.dword 0x6361757365303520
	.dword 0x3d20300a65636175
	.dword 0x73653036203d2030
	.dword 0x0a65636175736530
	.dword 0x37203d20300a6563
	.dword 0x617573653038203d
	.dword 0x20300a6563617573
	.dword 0x653039203d20300a
	.dword 0x6563617573653130
	.dword 0x203d20300a656361
	.dword 0x7573653131203d20
	.dword 0x300a656361757365
	.dword 0x3132203d20300a65
	.dword 0x6361757365313320
	.dword 0x3d20300a65636175
	.dword 0x73653134203d2030
	.dword 0x0a5b646174612d68
	.dword 0x617a617264735d0a
	.dword 0x7261775f70726f62
	.dword 0x203d20302e350a77
	.dword 0x61725f70726f6220
	.dword 0x3d20302e350a7761
	.dword 0x775f70726f62203d
	.dword 0x20302e350a6e756d
	.dword 0x5f726567735f6c6f
	.dword 0x6f6b626568696e64
	.dword 0x203d20330a5b7072
	.dword 0x6f6772616d2d6d61
	.dword 0x63726f5d0a707265
	.dword 0x5f70726f6772616d
	.dword 0x5f6d6163726f203d
	.dword 0x206164642078302c
	.dword 0x78302c78300a706f
	.dword 0x73745f70726f6772
	.dword 0x616d5f6d6163726f
	.dword 0x203d206164642078
	.dword 0x302c78302c78300a
	.dword 0x7072655f6272616e
	.dword 0x63685f6d6163726f
	.dword 0x203d206164642078
	.dword 0x302c78302c78300a
	.dword 0x706f73745f627261
	.dword 0x6e63685f6d616372
	.dword 0x6f203d2061646420
	.dword 0x78302c78302c7830
	.dword 0x0a65636175736530
	.dword 0x30203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653031203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653032203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303320
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x34203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653035203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653036203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303720
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x38203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653039203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653130203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365313120
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736531
	.dword 0x32203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653133203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653134203d20
	.dword 0x72616e646f6d0a5b
	.dword 0x73656c662d636865
	.dword 0x636b696e675d0a72
	.dword 0x617465203d203130
	.dword 0x300a746573745f70
	.dword 0x6173735f6d616372
	.dword 0x6f203d206c612020
	.dword 0x2020202073702c20
	.dword 0x626567696e5f7369
	.dword 0x676e61747572653b
	.dword 0x2061646469202020
	.dword 0x2073702c2073702c
	.dword 0x20322a5245474259
	.dword 0x5445533b206c6920
	.dword 0x202020202074312c
	.dword 0x2030786666666666
	.dword 0x3b20535245472020
	.dword 0x202074312c20302a
	.dword 0x5245474259544553
	.dword 0x287370290a746573
	.dword 0x745f6661696c5f6d
	.dword 0x6163726f203d2061
	.dword 0x64642078302c7830
	.byte 0x2c
	.byte 0x78
	.byte 0x30
	.byte 0xa
