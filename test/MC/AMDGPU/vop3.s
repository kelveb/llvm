// RUN: llvm-mc -arch=amdgcn -show-encoding %s | FileCheck %s --check-prefix=SICI
// RUN: llvm-mc -arch=amdgcn -mcpu=SI -show-encoding %s | FileCheck %s --check-prefix=SICI
// RUN: not llvm-mc -arch=amdgcn -mcpu=tonga -show-encoding %s | FileCheck %s --check-prefix=VI
// RUN: not llvm-mc -arch=amdgcn -mcpu=tonga -show-encoding %s 2>&1 | FileCheck %s -check-prefix=NOVI


//===----------------------------------------------------------------------===//
// VOPC Instructions
//===----------------------------------------------------------------------===//

// Test forced e64 encoding

v_cmp_lt_f32_e64 s[2:3], v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x40]

// Test forcing e64 with vcc dst

v_cmp_lt_f32_e64 vcc, v4, v6
// SICI: v_cmp_lt_f32_e64 vcc, v4, v6 ; encoding: [0x6a,0x00,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI: v_cmp_lt_f32_e64 vcc, v4, v6 ; encoding: [0x6a,0x00,0x41,0xd0,0x04,0x0d,0x02,0x00]

//
// Modifier tests:
//

v_cmp_lt_f32 s[2:3] -v4, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -v4, v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x20]
// VI:   v_cmp_lt_f32_e64 s[2:3], -v4, v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x20]

v_cmp_lt_f32 s[2:3]  v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x40]

v_cmp_lt_f32 s[2:3] -v4, -v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -v4, -v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x60]
// VI:   v_cmp_lt_f32_e64 s[2:3], -v4, -v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x60]

v_cmp_lt_f32 s[2:3] |v4|, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], |v4|, v6 ; encoding: [0x02,0x01,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], |v4|, v6 ; encoding: [0x02,0x01,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] v4, |v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, |v6| ; encoding: [0x02,0x02,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, |v6| ; encoding: [0x02,0x02,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] |v4|, |v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], |v4|, |v6| ; encoding: [0x02,0x03,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], |v4|, |v6| ; encoding: [0x02,0x03,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3] -|v4|, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x02,0xd0,0x04,0x0d,0x02,0x20]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, v6 ; encoding: [0x02,0x01,0x41,0xd0,0x04,0x0d,0x02,0x20]

v_cmp_lt_f32 s[2:3] v4, -|v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x02,0xd0,0x04,0x0d,0x02,0x40]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, -|v6| ; encoding: [0x02,0x02,0x41,0xd0,0x04,0x0d,0x02,0x40]

v_cmp_lt_f32 s[2:3] -|v4|, -|v6|
// SICI: v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x02,0xd0,0x04,0x0d,0x02,0x60]
// VI:   v_cmp_lt_f32_e64 s[2:3], -|v4|, -|v6| ; encoding: [0x02,0x03,0x41,0xd0,0x04,0x0d,0x02,0x60]

//
// Instruction tests:
//

v_cmp_f_f32 s[2:3], v4, v6
// SICI: v_cmp_f_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x00,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x40,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lt_f32 s[2:3], v4, v6
// SICI: v_cmp_lt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x02,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x41,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_eq_f32 s[2:3], v4, v6
// SICI: v_cmp_eq_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x04,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_eq_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x42,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_le_f32 s[2:3], v4, v6
// SICI: v_cmp_le_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x06,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_le_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x43,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_gt_f32 s[2:3], v4, v6
// SICI: v_cmp_gt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x08,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_gt_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x44,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_lg_f32 s[2:3], v4, v6
// SICI: v_cmp_lg_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x0a,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_lg_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x45,0xd0,0x04,0x0d,0x02,0x00]

v_cmp_ge_f32 s[2:3], v4, v6
// SICI: v_cmp_ge_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x0c,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_ge_f32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x46,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of v_cmp_*_f32
// TODO: Add tests for v_cmpx_*_f32

v_cmp_f_f64 s[2:3], v[4:5], v[6:7]
// SICI: v_cmp_f_f64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x40,0xd0,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_f64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x60,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of v_cmp_*_f64
// TODO: Add tests for the rest of the floating-point comparision instructions.

v_cmp_f_i32 s[2:3], v4, v6
// SICI: v_cmp_f_i32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0x00,0xd1,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_i32_e64 s[2:3], v4, v6 ; encoding: [0x02,0x00,0xc0,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add test for the rest of v_cmp_*_i32

v_cmp_f_i64 s[2:3], v[4:5], v[6:7]
// SICI: v_cmp_f_i64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0x40,0xd1,0x04,0x0d,0x02,0x00]
// VI:   v_cmp_f_i64_e64 s[2:3], v[4:5], v[6:7] ; encoding: [0x02,0x00,0xe0,0xd0,0x04,0x0d,0x02,0x00]

// TODO: Add tests for the rest of the instructions.

//===----------------------------------------------------------------------===//
// VOP1 Instructions
//===----------------------------------------------------------------------===//

// Test forced e64 encoding with e32 operands

v_mov_b32_e64 v1, v2
// SICI: v_mov_b32_e64 v1, v2 ; encoding: [0x01,0x00,0x02,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_mov_b32_e64 v1, v2 ; encoding: [0x01,0x00,0x41,0xd1,0x02,0x01,0x00,0x00]

// Force e64 encoding for special instructions.
// FIXME, we should be printing the _e64 suffix for v_nop and v_clrexcp.

v_nop_e64
// SICI: v_nop ; encoding: [0x00,0x00,0x00,0xd3,0x00,0x00,0x00,0x00]
// VI:   v_nop ; encoding: [0x00,0x00,0x40,0xd1,0x00,0x00,0x00,0x00]

v_clrexcp_e64
// SICI: v_clrexcp ; encoding: [0x00,0x00,0x82,0xd3,0x00,0x00,0x00,0x00]
// VI:   v_clrexcp ; encoding: [0x00,0x00,0x75,0xd1,0x00,0x00,0x00,0x00]

//
// Modifier tests:
// 

v_fract_f32 v1, -v2
// SICI: v_fract_f32_e64 v1, -v2 ; encoding: [0x01,0x00,0x40,0xd3,0x02,0x01,0x00,0x20]
// VI:   v_fract_f32_e64 v1, -v2 ; encoding: [0x01,0x00,0x5b,0xd1,0x02,0x01,0x00,0x20]

v_fract_f32 v1, |v2|
// SICI: v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_fract_f32_e64 v1, |v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x00]

v_fract_f32 v1, -|v2|
// SICI: v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x40,0xd3,0x02,0x01,0x00,0x20]
// VI:   v_fract_f32_e64 v1, -|v2| ; encoding: [0x01,0x01,0x5b,0xd1,0x02,0x01,0x00,0x20]

v_fract_f32 v1, v2 clamp
// SICI: v_fract_f32_e64 v1, v2 clamp ; encoding: [0x01,0x08,0x40,0xd3,0x02,0x01,0x00,0x00]
// VI:   v_fract_f32_e64 v1, v2 clamp ; encoding: [0x01,0x80,0x5b,0xd1,0x02,0x01,0x00,0x00]

v_fract_f32 v1, v2 mul:2
// SICI: v_fract_f32_e64 v1, v2 mul:2 ; encoding: [0x01,0x00,0x40,0xd3,0x02,0x01,0x00,0x08]
// VI:   v_fract_f32_e64 v1, v2 mul:2 ; encoding: [0x01,0x00,0x5b,0xd1,0x02,0x01,0x00,0x08]

v_fract_f32 v1, v2, div:2 clamp
// SICI: v_fract_f32_e64 v1, v2 clamp div:2 ; encoding: [0x01,0x08,0x40,0xd3,0x02,0x01,0x00,0x18]
// VI:   v_fract_f32_e64 v1, v2 clamp div:2 ; encoding: [0x01,0x80,0x5b,0xd1,0x02,0x01,0x00,0x18]

// TODO: Finish VOP1

///===---------------------------------------------------------------------===//
// VOP2 Instructions
///===---------------------------------------------------------------------===//

// Test forced e64 encoding with e32 operands

v_add_f32_e64 v1, v3, v5
// SICI: v_add_f32_e64 v1, v3, v5 ; encoding: [0x01,0x00,0x06,0xd2,0x03,0x0b,0x02,0x00]
// VI:   v_add_f32_e64 v1, v3, v5 ; encoding: [0x01,0x00,0x01,0xd1,0x03,0x0b,0x02,0x00]


// TODO: Modifier tests

v_cndmask_b32 v1, v3, v5, s[4:5]
// SICI: v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd2,0x03,0x0b,0x12,0x00]
// VI:   v_cndmask_b32_e64 v1, v3, v5, s[4:5] ; encoding: [0x01,0x00,0x00,0xd1,0x03,0x0b,0x12,0x00]

//TODO: readlane, writelane

v_add_f32 v1, v3, s5
// SICI: v_add_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x06,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_add_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x01,0xd1,0x03,0x0b,0x00,0x00]

v_sub_f32 v1, v3, s5
// SICI: v_sub_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x08,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_sub_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x02,0xd1,0x03,0x0b,0x00,0x00]

v_subrev_f32 v1, v3, s5
// SICI: v_subrev_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0a,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_subrev_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x03,0xd1,0x03,0x0b,0x00,0x00]

v_mac_legacy_f32 v1, v3, s5
// SICI: v_mac_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0c,0xd2,0x03,0x0b,0x00,0x00]
// FIXME: The error message should be: error: instruction not supported on this GPU
// NOVI: error: invalid operand for instruction

v_mul_legacy_f32 v1, v3, s5
// SICI: v_mul_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x0e,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_legacy_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x04,0xd1,0x03,0x0b,0x00,0x00]

v_mul_f32 v1, v3, s5
// SICI: v_mul_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x10,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_f32_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x05,0xd1,0x03,0x0b,0x00,0x00]

v_mul_i32_i24 v1, v3, s5
// SICI: v_mul_i32_i24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x12,0xd2,0x03,0x0b,0x00,0x00]
// VI:   v_mul_i32_i24_e64 v1, v3, s5 ; encoding: [0x01,0x00,0x06,0xd1,0x03,0x0b,0x00,0x00]

///===---------------------------------------------------------------------===//
// VOP3 Instructions
///===---------------------------------------------------------------------===//

// TODO: Modifier tests

v_mad_legacy_f32 v2, v4, v6, v8
// SICI: v_mad_legacy_f32 v2, v4, v6, v8 ; encoding: [0x02,0x00,0x80,0xd2,0x04,0x0d,0x22,0x04]
// VI:   v_mad_legacy_f32 v2, v4, v6, v8 ; encoding: [0x02,0x00,0xc0,0xd1,0x04,0x0d,0x22,0x04]





