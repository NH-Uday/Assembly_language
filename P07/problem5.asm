.MODEL SMALL
 .STACK 100H

 .DATA
   PROMPT_1  DB  0DH,0AH,'Enter the first binary number ( max 8-digits ) : $'
   PROMPT_2  DB  0DH,0AH,'Enter the second binary number ( max 8-digits ) : $'
   PROMPT_3  DB  0DH,0AH,'The SUM of given binary numbers in binary form is : $'
   ILLEGAL   DB  0DH,0AH,'Illegal character. Try again.$'

 .CODE
   MAIN PROC
     MOV AX, @DATA                ; initialize DS
     MOV DS, AX

     JMP @START_2                 ; jump to label @START_2

     @START_1:                    ; jump label
       LEA DX, ILLEGAL            ; load and display the string ILLEGAL 
       MOV AH, 9
       INT 21H

     @START_2:                    ; jump label
       XOR BX, BX                 ; clear BX

       LEA DX, PROMPT_1           ; load and display the string PROMPT_1
       MOV AH, 9
       INT 21H

       MOV CX, 8                  ; initialize loop counter
       MOV AH, 1                  ; set input function

       @LOOP_1:                   ; loop label
         INT 21H                  ; read a character

         CMP AL, 0DH              ; compare AL with CR
         JNE @SKIP_1              ; jump to label @SKIP_1 if AL!=0DH

         CMP CX, 30h                ; compare CX with 8
         JBE @START_1              ; jump to label @START_1 if CX=8
         JMP @EXIT_LOOP_1         ; jump to label @EXIT_LOOP_1

         @SKIP_1:                 ; jump label
           AND AL, 0FH            ; convert ascii into decimal code
           SHL BL, 1              ; shift BL towards left by 1 position
           OR BL, AL              ; set the LSB of BL with LASB of AL
       LOOP @LOOP_1               ; jump to label @LOOP_1 if CX!=0

       @EXIT_LOOP_1:              ; jump label

       LEA DX, PROMPT_2           ; load and display the string PROMPT_2
       MOV AH, 9
       INT 21H

       MOV CX, 8                  ; initialize loop counter
       MOV AH, 1                  ; set input function

       @LOOP_2:                   ; loop label
         INT 21H                  ; read a character

         CMP AL, 0DH              ; compare AL with CR
         JNE @SKIP_2              ; jump to label @SKIP_2 if AL!=0DH

         CMP CX, 30h                ; compare CX with 8
         JBE @START_1              ; jump to label @START_2 if CX=8
         JMP @EXIT_LOOP_2         ; jump to label @EXIT_LOOP_2

         @SKIP_2:                 ; jump label
           AND AL, 0FH            ; convert ascii into decimal code
           SHL BH, 1              ; shift BH towards left by 1 position
           OR BH, AL              ; set the LSB of BH with LASB of AL
       LOOP @LOOP_2               ; jump to label @LOOP_2 if CX!=0

       @EXIT_LOOP_2:              ; jump label

       LEA DX, PROMPT_3           ; load and display the string PROMPT_3
       MOV AH, 9
       INT 21H

       ADD BL, BH                 ; add BL and BH
       JNC @SKIP                  ; jump to label @SKIP if CF=1
         MOV AH, 2                ; print the digit 1 i.e. carry
         MOV DL, 31H
         INT 21H

       @SKIP:                     ; jump label

       MOV CX, 8                  ; initialize loop counter
       MOV AH, 2                  ; set output function

       @LOOP_3:                   ; loop label
         SHL BL, 1                ; shift BL towards left by 1 position
         JC @ONE                  ; jump to label @ONE if CF=1
         MOV DL, 30H              ; set DL=0
         JMP @DISPLAY             ; jump to label @DISPLAY
               
         @ONE:                    ; jump label
           MOV DL, 31H            ; set DL=1

         @DISPLAY:                ; jump label
           INT 21H                ; print the character
       LOOP @LOOP_3               ; jump to label @LOOP_3 if CX!=0

     MOV AH, 4CH                  ; return control to DOS
     INT 21H
   MAIN ENDP
 END MAIN