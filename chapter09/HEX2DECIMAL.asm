.model small
.stack 100h
.data

msg1 db 10,13,10,13,'ENTER 1 TO 4 HEX DIGITS:$'
msg2 db 10,13,'IN DECIMAL IS IT:$'
msg3 db 10,13,10,13,'DO YOU WANT TO DO IT AGAIN (Y/N)?$'
msg4 db 10,13,'ILLEGAL CHARACTER- ENTER 0-9 OR A-F:$'

hex  db 5,?,5 dup(?) ;VARIABLE WITH 3 SECTIONS.
buffer  db 6 dup('$') ;RESULT COULD HAVE 5 DIGITS.

.code
  mov  ax, @data
  mov  ds, ax

again:

;CLEAR BUFFER (IN CASE IT HOLDS PREVIOUS RESULT).
  call clear_buffer

;DISPLAY 'ENTER 1 TO 4 HEX DIGITS:$'
  mov  ah, 9
  lea  dx, msg1
  int  21h

;CAPTURE HEX NUMBER AS STRING.
  mov  ah, 0ah
  lea  dx, hex
  int  21h

;CONVERT HEX-STRING TO NUMBER.
  lea  si, hex+2        ;CHARS OF THE HEX-STRING.
  mov  bh, [si-1]       ;SECOND BYTE IS LENGTH.
  call hex2number       ;NUMBER RETURNS IN AX.

;CONVERT NUMBER TO DECIMAL-STRING TO DISPLAY.
  lea  si, buffer
  call number2string    ;STRING RETURNS IN SI (BUFFER).

;DISPLAY 'IN DECIMAL IS IT:$'
  mov  ah, 9
  lea  dx, msg2
  int  21h            

;DISPLAY NUMBER AS STRING.
  mov  ah, 9
  lea  dx, buffer
  int  21h

illegal: ;JUMP HERE WHEN INVALID CHARACTER FOUND.

;DISPLAY 'DO YOU WANT TO DO IT AGAIN (Y/N)?$' 
  mov  ah, 9
  lea  dx, msg3
  int  21h

;CAPTURE KEY.
  mov  ah, 1
  int  21h
  cmp  al,'y'
  je   again
  cmp  al,'Y'
  je   again

;TERMINATE PROGRAM.  
  mov  ax, 4c00h
  int  21h 
 
;FILL VARIABLE "BUFFER" WITH "$".
;EVERYTIME THE USER WANTS TO DO IT AGAIN, THE
;PREVIOUS RESULT MUST BE CLEARED.

clear_buffer proc
  lea  si, buffer
  mov  al, '$'
  mov  cx, 5  
clearing:
  mov  [si], al
  inc  si
  loop clearing

  ret
clear_buffer endp

 
;INPUT  : BH = STRING LENGTH (1..4).
;         SI = OFFSET HEX-STRING.
;OUTPUT : AX = NUMBER.

hex2number proc
      MOV  AX, 0       ;THE NUMBER.
   Ciclo:

;     SHL  AX, 4       ;SHIFT LEFT LOWER 4 BITS.
;SHIFT LEFT AL AND AH MANUALLY 4 TIMES TO SIMULATE SHL AX,4.
      shl  al, 1
      rcl  ah, 1
      shl  al, 1
      rcl  ah, 1
      shl  al, 1
      rcl  ah, 1
      shl  al, 1
      rcl  ah, 1

      MOV  BL, [ SI ]  ;GET ONE HEX CHAR FROM STRING.

      call validate

      CMP  BL, 'A'     ;BL = 'A'..'F' : LETTER.
      JAE  letterAF    ;BL = '0'..'9' : DIGIT.
   ;CharIsDigit09.
      SUB  BL, 48      ;CONVERT DIGIT TO NUMBER.
      JMP  continue   
   letterAF:               
      SUB  BL, 55      ;CONVERT LETTER TO NUMBER.
   continue: 
      OR   AL, BL      ;CLEAR UPPER 4 BITS.
      INC  SI          ;NEXT HEX CHAR.
      DEC  BH          ;BH == 0 : FINISH.
      JNZ  Ciclo       ;BH != 0 : REPEAT.
   Fin:
      RET
hex2number endp

  
;INPUT : BL = HEX CHAR TO VALIDATE.

validate proc
    cmp bl, '0'
    jb  error     ;IF BL < '0'
    cmp bl, 'F'
    ja  error     ;IF BL > 'F'
    cmp bl, '9'
    jbe ok        ;IF BL <= '9'
    cmp bl, 'A'
    jae ok        ;IF BL >= 'A'
error:    
    pop  ax       ;REMOVE CALL VALIDATE.
    pop  ax       ;REMOVE CALL HEX2NUMBER.
;DISPLAY 'ILLEGAL CHARACTER- ENTER 0-9 OR A-F$'
    mov  ah, 9
    lea  dx, msg4
    int  21h
    jmp  illegal  ;GO TO 'DO YOU WANT TO DO IT AGAIN (Y/N)?$'
ok:    
    ret
validate endp

  
;INPUT : AX = NUMBER TO CONVERT TO DECIMAL.
;        SI = OFFSET STRING.
;ALGORITHM : EXTRACT DIGITS ONE BY ONE, STORE
;THEM IN STACK, THEN EXTRACT THEM IN REVERSE
;ORDER TO CONSTRUCT STRING.

number2string proc
  mov  bx, 10 ;DIGITS ARE EXTRACTED DIVIDING BY 10.
  mov  cx, 0 ;COUNTER FOR EXTRACTED DIGITS.
cycle1:       
  mov  dx, 0 ;NECESSARY TO DIVIDE BY BX.
  div  bx ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER.
  push dx ;PRESERVE DIGIT EXTRACTED FOR LATER.
  inc  cx ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
  cmp  ax, 0  ;IF NUMBER IS
  jne  cycle1 ;NOT ZERO, LOOP. 
;NOW RETRIEVE PUSHED DIGITS.
  lea  si, buffer
cycle2:  
  pop  dx        
  add  dl, 48 ;CONVERT DIGIT TO CHARACTER.
  mov  [ si ], dl
  inc  si
  loop cycle2  

  ret
number2string endp  

end