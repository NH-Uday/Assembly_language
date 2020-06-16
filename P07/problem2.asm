.MODEL SMALL
.STACK 100H

 .DATA
   MSG_1  DB  0DH,0AH,'Enter the character : $'
   MSG_2  DB  0DH,0AH,'The ASCII code of the given number in HEX form is : $'

 .CODE
   MAIN PROC
     MOV AX, @DATA                ; initialize DS  
     MOV DS, AX

START:                            ; jump label 
       LEA DX,MSG_1               ; load and display the string PROMPT_1
       MOV AH, 9
       INT 21H

       MOV AH,1                   ; read a character
       INT 21H

       MOV BL,AL                  ; move AL to BL
                                  
       CMP BL,0DH                 ; compare BL with CR
       JE END                     ; jump to label @END if BL=CR
       
       LEA DX,MSG_2               ; load and display the string PROMPT_2
       MOV AH, 9
       INT 21H

       XOR DX, DX                 ; clear DX
       MOV CX, 4                  ; move 4 to CX

LOOP_1:                           ; loop label
         SHL BL, 1                ; shift BL towards left by 1 position
         RCL DL, 1                ; rotate DL towards left by 1 position
                                  ; through carry
       LOOP LOOP_1                ; jump to label @LOOP_1 if CX!=0

       MOV CX, 4                  ; move 4 to CX

LOOP_2:                           ; loop label
         SHL BL, 1                ; shift BL towards left by 1 position
         RCL DH, 1                ; rotate DH towards left by 1 position
                                  ; through carry
       LOOP LOOP_2                ; jump to label @LOOP_2 if CX!=0                                  
       MOV BX, DX                 ; move DX to BX
       MOV CX, 2                  ; initialize loop counter

LOOP_3:                           ; loop label
         CMP CX, 1                ; compare CX wiht 1
         JE SECOND_DIGIT          ; jump to label @SECOND_DIGIT if CX=1
         MOV DL, BL               ; move BL to DL
         JMP  NEXT                ; jump to label @NEXT

SECOND_DIGIT:                     ; jump label
           MOV DL, BH             ; move BH to DL

NEXT:                             ; jump label

         MOV AH, 2                ; set output function
         CMP DL, 9                ; compare DL with 9
         JBE NUMERIC_DIGIT        ; jump to label @NUMERIC_DIGIT if DL<=9
         SUB DL, 9                ; convert it to number i.e. 1,2,3,4,5,6
         OR DL, 40H               ; convert number to letter i.e. A,B...F
         JMP DISPLAY              ; jump to label @DISPLAY

NUMERIC_DIGIT:                    ; jump label
           OR DL, 30H             ; convert decimal to ascii code

DISPLAY:                          ; jump label
       INT 21H                    ; print the character
       LOOP LOOP_3                ; jump to label @LOOP_3 if CX!=0

       JMP START                  ; jump to label @START
END:                              ; jump label
       MOV AH, 4CH                  ; return control to DOS
       INT 21H
   MAIN ENDP
 END MAIN