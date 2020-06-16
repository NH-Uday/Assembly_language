.model small
.stack 100h
.data
.code
main proc
    
    mov ah,2
    int 21h
    
    xor cx,cx
    
    mov ah,1
    int 21h
while:    
    cmp al,0dh
    je end_w
    
    push ax
    inc cx
    
    int 21h
    jmp while
end_w:
    mov ah,2
    mov dl,0dh
    int 21h
    mov dl,0ah
    int 21h
    jcxz exit
top:
    pop dx
    int 21h
    loop top
exit:
    mov ah,4ch
    int 21h
main endp
end main