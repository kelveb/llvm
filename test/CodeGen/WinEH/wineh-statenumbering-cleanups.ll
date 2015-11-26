; RUN: sed -e s/.Cxx:// %s | opt -mtriple=x86-pc-windows-msvc -S -x86-winehstate | FileCheck %s
; RUN: sed -e s/.SEH:// %s | opt -mtriple=x86-pc-windows-msvc -S -x86-winehstate | FileCheck %s

declare i32 @__CxxFrameHandler3(...)
declare i32 @_except_handler3(...)
declare void @dummy_filter()

declare void @f(i32)

; CHECK-LABEL: define void @test2(
;Cxx: define void @test2(i1 %b) personality i32 (...)* @__CxxFrameHandler3 {
;SEH: define void @test2(i1 %b) personality i32 (...)* @_except_handler3 {
entry:
  ; CHECK: entry:
  ; CHECK:   store i32 1
  ; CHECK:   invoke void @f(i32 1)
  invoke void @f(i32 1)
    to label %exit unwind label %cleanup.pad
cleanup.pad:
  %cleanup = cleanuppad none []
  br i1 %b, label %left, label %right
left:
  cleanupret %cleanup unwind label %catch.pad
right:
  cleanupret %cleanup unwind label %catch.pad
catch.pad:
  %cs1 = catchswitch none, unwind to caller [label %catch.body]
catch.body:
;Cxx: %catch = catchpad %cs1 [i8* null, i32 u0x40, i8* null]
;SEH: %catch = catchpad %cs1 [void ()* @dummy_filter]
  catchret %catch to label %exit
exit:
  ret void
}

; CHECK-LABEL: define void @test3(
;Cxx: define void @test3() personality i32 (...)* @__CxxFrameHandler3 {
;SEH: define void @test3() personality i32 (...)* @_except_handler3 {
entry:
  ; CHECK: entry:
  ; CHECK:   store i32 0
  ; CHECK:   invoke void @f(i32 1)
  invoke void @f(i32 1)
    to label %exit unwind label %cleanup.pad
cleanup.pad:
  ; CHECK: cleanup.pad:
  ; CHECK:   store i32 1
  ; CHECK:   invoke void @f(i32 0)
  %cleanup = cleanuppad none []
  invoke void @f(i32 0)
    to label %unreachable unwind label %catch.pad
unreachable:
  unreachable
catch.pad:
  %cs1 = catchswitch none, unwind to caller [label %catch.body]
catch.body:
;Cxx: %catch = catchpad %cs1 [i8* null, i32 u0x40, i8* null]
;SEH: %catch = catchpad %cs1 [void ()* @dummy_filter]
  catchret %catch to label %exit
exit:
  ret void
}
