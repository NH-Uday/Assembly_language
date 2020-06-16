 .MODEL SMALL
 .STACK 100H

 .DATA
   MSG_1  DB  'Enter the hexadecimal number ( max 4-digit ) : $'
   MSG_2  DB  0DH,0AH,'The equivalent 16-bit binary number is : $'
   ILLEGAL   DB  0DH,0AH,'Illegal hex number. Try again : $'
   COUNT     DB  ? 
 .CODE
   MAIN PROC
     MOV AX, @DATA                ; initialize DS
     MOV DS, AX

     LEA DX, MSG_1                ; load and display the string PROMPT_1
     MOV AH,9
     INT 21H

     JMP @START                   ; jump to label @START_2 

     @START_1:                    ; jump label
       LEA DX, ILLEGAL            ; load and display the string ILLEGAL
       MOV AH, 9
       INT 21H

     @START:                      ;
       XOR BX, BX                 ; clear BX
       MOV COUNT, 30H             ; initialize loop counter

     @START_2:                    ; jump label
       MOV AH, 1                  ; set input function
       INT 21H                    ; read a character

       CMP AL, 0DH                ; compare Al with CR
       JNE @SKIP                  ; jump to label @SKIP if AL!=CR

       CMP COUNT, 30H             ; compare COUNT with 0
       JBE @START_1               ; jump to label @START_1 if COUNT<=0
       JMP @END                   ; jump to label @END

       @SKIP:                     ; jump label

       CMP AL, "A"                ; compare AL with "A"
       JB @DECIMAL                ; jump to label @DECIMAL if AL<A

       CMP AL, "F"                ; compare AL with "F"
       JA @START_1                ; jump to label @START_1 if AL>F
       ADD AL, 09H                ; add 9 to AL
       JMP @OK                    ; jump to label @OK

       @DECIMAL:                  ; jump label
         CMP AL, 30H              ; compare AL with 0
         JB @START_1              ; jump to label @START_1 if AL<0

         CMP AL, 39H              ; compare AL with 9
         JA @START_1              ; jump to label @START_1 if AL>9

       @OK:                       ; jump label

       INC COUNT                  ; increment the COUNT variable

       AND AL, 0FH                ; convert the ascii into binary code

       MOV CL, 4                  ; set CL=4
       SHL AL, CL                 ; shift AL towards left by 4 positions

       MOV CX, 4                  ; set CX=4

       @LOOP_1:                   ; loop label
         SHL AL, 1                ; shift AL towards left by 1 position
         RCL BX, 1                ; rotate BX towards left by 1 position
                                  ; through carry
       LOOP @LOOP_1               ; jump to label @LOOP_1 if CX!=0

      CMP COUNT, 34H              ; compare COUNT with 4
      JE @END                     ; jump to label @END if COUNT=4
      JMP @START_2                ; jump to label @START_2

     @END:                        ; jump label

     LEA DX, MSG_2                ; load and display the string PROMPT_2
     MOV AH, 9                    
     INT 21H

     MOV CX, 16                   ; set CX=16
     MOV AH, 2                    ; set output function

     @LOOP_2:                     ; loop label
       SHL BX, 1                  ; shift BX towards left by 1 position
       JC @ONE                    ; jump to label @ONE if CF=1
       MOV DL, 30H                ; set DL=0
       JMP @DISPLAY               ; jump to label @DISPLAY

       @ONE:                      ; jump label
         MOV DL, 31H              ; set DL=1

       @DISPLAY:                  ; jump label
         INT 21H                  ; display a character
     LOOP @LOOP_2                 ; jump to label @LOOP_2 if CX!=0

     MOV AH, 4CH                  ; return control to DOS
     INT 21H
   MAIN ENDP
 END MAIN