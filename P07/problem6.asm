.MODEL SMALL
 .STACK 100H

 .DATA
   PROMPT_1  DB  0DH,0AH,'Enter the first Hex number ( 0000 - FFFF ) : $'
   PROMPT_2  DB  0DH,0AH,'Enter the second Hex number ( 0000 - FFFF ) : $'
   PROMPT_3  DB  0DH,0AH,'The SUM of given Hex numbers in Hex form is : $'
   ILLEGAL   DB  0DH,0AH,'Illegal character. Try again.$'

   COUNT     DB  ?
   VALUE     DW  ?

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
       LEA DX, PROMPT_1           ; load and display the string PROMPT_1
       MOV AH, 9
       INT 21H

       XOR BX, BX                 ; clear BX
       MOV COUNT, 30H             ; initialize loop counter

     @START_3:                    ; jump label
       MOV AH, 1                  ; set input function
       INT 21H                    ; read a character

       CMP AL, 0DH                ; compare AL with CR
       JNE @SKIP_1                ; jump to label @SKIP_1 if AL!=CR

       CMP COUNT, 30H             ; compare COUNT with 0
       JBE @START_1               ; jump to label @START_1 if COUNT<=0
       JMP @END_1                 ; jump to label @END

       @SKIP_1:                   ; jump label

       CMP AL, "A"                ; compare AL with "A"
       JB @DECIMAL_1              ; jump to label @DECIMAL_1 if AL<A

       CMP AL, "F"                ; compare AL with "F"
       JA @START_1                ; jump to label @START_1 if AL>F
       ADD AL, 09H                ; add 9 to AL
       JMP @OK_1                  ; jump to label @OK_1

       @DECIMAL_1:                ; jump label
         CMP AL, 30H              ; compare AL with 0
         JB @START_1              ; jump to label @START_1 if AL<0

         CMP AL, 39H              ; compare AL with 9
         JA @START_1              ; jump to label @START_1 if AL>9

       @OK_1:                     ; jump label

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

       CMP COUNT, 34H             ; compare COUNT with 4
       JE @END_1                  ; jump to label @END_1 if COUNT=4
       JMP @START_3               ; jump to label @START_3

       @END_1:                    ; jump label

       MOV VALUE, BX              ; set VALUE=BX

       LEA DX, PROMPT_2           ; load and display the string PROMPT_2
       MOV AH, 9
       INT 21H

       XOR BX, BX                 ; clear BX
       MOV COUNT, 30H             ; initialize loop counter

       @START_4:                  ; jump label
         MOV AH, 1                ; set input function
         INT 21H                  ; read a character

         CMP AL, 0DH              ; compare AL with CR
         JNE @SKIP_2              ; jump to label @SKIP_2 if AL!=CR

         CMP COUNT, 30H           ; compare COUNT with 0
         JBE @START_1             ; jump to label @START_1 if COUNT<=0
         JMP @END_2               ; jump to label @END_2

         @SKIP_2:                 ; jump label

         CMP AL, "A"              ; compare AL with "A"
         JB @DECIMAL_2            ; jump to label @DECIMAL_2 if AL<A

         CMP AL, "F"              ; compare AL with "F"
         JA @JUMP                 ; jump to label @JUMP if AL>F
         ADD AL, 09H              ; add 9 to AL
         JMP @OK_2                ; jump to label @OK_2

         @DECIMAL_2:              ; jump label
           CMP AL, 30H            ; compare AL with 0
           JB @JUMP               ; jump to label @JUMP if AL<0

           CMP AL, 39H            ; compare AL with 9
           JA @JUMP               ; jump to label @JUMP if AL>9
           JMP @OK_2              ; jump to label @OK_2 

         @JUMP:                   ; jump label
           JMP @START_1           ; jump to label @START_1

         @OK_2:                   ; jump label

         INC COUNT                ; increment the COUNT variable

         AND AL, 0FH              ; convert the ascii into binary code

         MOV CL, 4                ; set CL=4
         SHL AL, CL               ; shift AL towards left by 4 positions

         MOV CX, 4                ; set CX=4

         @LOOP_2:                 ; loop label
           SHL AL, 1              ; shift AL towards left by 1 position
           RCL BX, 1              ; rotate BX towards left by 1 position
                                  ; through carry
         LOOP @LOOP_2             ; jump to label @LOOP_2 if CX!=0

         CMP COUNT, 34H           ; compare COUNT with 4
         JE @END_2                ; jump to label @END_2 if COUNT=4
         JMP @START_4             ; jump to label @START_4

       @END_2:                    ; jump label

     LEA DX, PROMPT_3             ; load and display the string PROMPT_3
     MOV AH, 9
     INT 21H

     ADD BX, VALUE                ; add BX and VALUE
     JNC @SKIP                    ; jump to label @SKIP if CF=1
     MOV AH, 2                    ; set output function
     MOV DL, 31H                  ; set DL=1
     INT 21H                      ; print a character
 
     @SKIP:                       ; jump label

     MOV COUNT, 30H               ; set COUNT=0

     @LOOP_3:                     ; loop label
       XOR DL, DL                 ; clear DL
       MOV CX, 4                  ; set CX=4

       @LOOP_4:                   ; loop label
         SHL BX, 1                ; shift BX towards left by 1 position
         RCL DL, 1                ; rotate DL towards left by 1 position
                                  ; through carry
       LOOP @LOOP_4               ; jump to label @LOOP_4 if CX!=0

       MOV AH, 2                  ; set output function

       CMP DL, 9                  ; compare DL with 9
       JBE @NUMERIC_DIGIT         ; jump to label @NUMERIC_DIGIT if DL<=9
       SUB DL, 9                  ; convert it to number i.e. 1,2,3,4,5,6
       OR DL, 40H                 ; convert number to letter i.e. A,B...F
       JMP @DISPLAY               ; jump to label @DISPLAY

       @NUMERIC_DIGIT:            ; jump label
         OR DL, 30H               ; convert decimal to ascii code

       @DISPLAY:                  ; jump label
         INT 21H                  ; print the character

       INC COUNT                  ; increment COUNT variable
       CMP COUNT, 34H             ; compare COUNT with 4
       JNE @LOOP_3                ; jump to label @LOOP_3 if COUNT!=4

     @END:                        ; jump label

     MOV AH, 4CH                  ; return control to DOS
     INT 21H
   MAIN ENDP
 END MAIN