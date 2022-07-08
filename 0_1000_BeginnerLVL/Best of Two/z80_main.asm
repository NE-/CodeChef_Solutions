;;;
;; Author: NE- https://github.com/NE-
;; Date: 2022 July 08
;; Purpose: CodeChef "Best of Two" Problem
;
; Notes: 
;  Compiled, ran, and tested with WinAPE_20b2
;  Output only works with numbers less than 10
;
; Bugs:
;  1,3 will display 03, however, 3,1 will display garbage
;;   Problem may be the H flag manipulating A after executing the DAA instruction.
;
;; Usage: call &8000,[even number of test scores where scores are integers less than 101 and greater than 0]
;;;

org &8000

; Check if no arguments
cp 0
jr z,ShowUsage

; Check if even number of arguments
bit 0,a
jr nz,ShowUsage

rrca                       ; Divide test cases by 2 since we are checking pairs
ld (NTestCases), a ; Save number of test cases

; Start comparison
CompareLoop:
  ld a,(IX)   ; Get first parameter
  cp (IX+2) ; Compare with the following parameter
  
  call p, PrintA   ; If positive result, A was larger
  call m, PrintIX ; Else negative; following was larger

  ; Prepare for next pair
  ld a, (NTestCases)
  dec a

  ret z ; If a == 0, we're done
  ret m ; Else if a < 0, we're done
  
  ld (NTestCases), a ; Otherwise, save the new number of test cases

  ; Go to the next set
  inc IXL
  inc IXL
  inc IXL
  inc IXL
jr CompareLoop


ShowUsage:
  ld HL, ShowUsageMsg
  jr PrintStr
ShowUsageMsg: 
  db "Usage: call &8000,[Even number of scores where score >=0 and <= 100]",255

PrintStr:
  ld a,(HL) ; Load address of string to A
  cp 255 
  ret z           ; If we reached 255, that's the end of the string
  call &BB5A
  inc HL         ; Go to next character
jr PrintStr

PrintIX:
  ld a, (IX+2)
  ccf
PrintA:
  ;bit 0,b ; Force H flag to be set. 
  daa ; Adjust A for BCD

  push AF ; Save A
    ; Isolate top nibble
    and %11110000
    ; Shift to bottom nibble
    rrca
    rrca
    rrca
    rrca
    add &30 ; Start at 30h of the CPC ASCII Table
    call &BB5A ; BIOS TXT_OUTPUT
  ; Restore A
  pop AF
  ; Isolate bottom nibble
  and %00001111
  add &30
  call &BB5A ; BIOS TXT_OUTPUT

  ; Print a new line
  ld a, &D ; Carriage Return
  call &BB5A
  ld a, &A ; Line Feed
  call &BB5A
ret

NTestCases: db 0
