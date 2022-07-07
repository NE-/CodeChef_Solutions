;;
; Author: NE- https://github.com/NE-
; Date: 2022 July 07
; Purpose: CodeChef "Best of Two" Problem
;
; Notes: 
;  Compiled, ran, and tested with WinAPE_20b2
;  Output only works with numbers less than 10
;
; Usage: call &8000,[even number of test scores where scores are integers less than 101 and greater than 0]
;;

org &8000

; Check if no parameters
  cp 1
  jp m,ShowUsage

; Check if parameters are even
  bit 0, a
  jp nz,ShowUsage
; Checks passed. Begin calculations
  ; Divide text cases by 2 since we only check pairs
  srl A
  ; Save number of test cases
  ld (NTestCases), a
  
CompareLoop:
  ; Get parameter
  ld A,(IX)
  ; Compare with following parameter
  cp (IX+2)
  ; If positive result, A was larger
  call p, PrintA ;; BROKEN subroutine
  ; Else negative, so the following was larger
  call m, PrintIX ;; BROKEN subroutine
  ; Prepare for next 2 cases
  ld a,(NTestCases)
  dec a
  ; If a == 0 then we're done
  ret z
  ; Else if a < 0 then we're done
  ret m
  ; otherwise, 
  ; Save new number of remaining test cases
  ld (NTestCases), a

  ; go to the next set
  inc ixl
  inc ixl
  inc ixl
  inc ixl
  jr CompareLoop
ret

ShowUsage:
  ld hl,ShowUsageMsg
  jp PrintStr
ShowUsageMsg:
  db "Usage: call &8000,[Even number of scores where score <= 100]",255

PrintStr:
  ld a,(hl)
  cp 255
  ret z
  inc hl
  call &BB5A ; BIOS TXT_OUTPUT
jr PrintStr

;; FIXME
PrintA:
  ; Convert to decimal
  ;; Save A
  push AF
    ; Get top nibble
    and %11110000
    srl a
    srl a
    srl a
    srl a
    
    ; Print character
    call &BB5A
    ; Get bottom nibble
    ; restore A
    pop AF
    and %00001111
    ; Print character
    call &BB5A
  ; Carriage return
  ld a, &D
  call &BB5A
  ; Line feed
  ld a,  &A
  call &BB5A
ret
;; FIXME
PrintIX:
  ld (IX+1), A
  ; convert to hex
  add &30
  jr PrintA
ret

NTestCases: db 0