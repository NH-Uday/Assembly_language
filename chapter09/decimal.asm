include 'emu8086.inc'
.model small
.stack 100h
.data
  n db 0
  count db 0
.code
main proc
    
   mov ax,@data
   mov ds,ax
   xor cx,cx
   xor dx,dx
   call decimal_input
   printn
   mov ah,2
   int 21h
   printn
   mov n,dl
   call decimal_output
   mov ah,4ch 
   int 21h 
    
    main endp
decimal_input proc
    print "input" 
for:
    mov ah,1
    int 21h
    cmp al,0dh    
    je end
    sub al,48
    mov n,al
    mov al,10
    mul dl
    add al,n
    mov dl,al
    inc count
    jmp for
end:



    ret
    decimal_input endp
decimal_output proc
    print "output"
    xor cx,cx
    mov cl,count
    
    mov bl,10
    xor ah,ah
    mov al,n
for2:
    div bl
    xor dx,dx
    mov dl,ah
    add dl,48
    push dx
    loop for2
    
    xor cx,cx
    mov cl,count
    mov ah,2

for3:
    pop dx
    int 21h
    loop for3
    ret
    decimal_output endp 
end main