[org 0x0100]

jmp start

count db 0

; keyboard interrupt service routine
kbisr:
    push ax
    in al, 0x60 ; read scan code from keyboard port
    cmp al, 0x1C ; compare with 'Enter' key scan code
        je end_read

    inc byte[count]

    mov al, 0x20
    out 0x20, al ; send EOI to PIC
    pop ax
    iret

end_read:
    mov al, 0x20
    out 0x20, al ; send EOI to PIC

    pop ax
    xor ax,ax

    mov al, count ; load count in ax
    add al, '0' ; convert to ASCII by adding '0'
    mov ah, 0x06

    mov bx, 0xb800 ; video memory segment
    mov es, bx ; point es to video memory
    mov bx, 100 ; offset in video memory
    mov [es:bx], ax

    jmp end_program


start:
    cli ; disable interrupts
    mov ax, 0
    mov es, ax ; point es to IVT base
    mov word [es:9*4], kbisr ; store offset at n*4
    mov [es:9*4+2], cs ; store segment at n*4+2
    sti ; enable interrupts

L1:
    jmp L1

end_program:
    mov ax, 0x4C00 ; DOS function to terminate program
    int 0x21
