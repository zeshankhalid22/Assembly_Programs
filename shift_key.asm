[org 0x0100]

jmp start
old_isr: dd 0

kbIsr:
    push ax
    push es

    mov ax, 0xb800
    mov es, ax

    in al, 0x60    ; read char form keyboard port
    cmp al, 0x2a    ; if left shift key
        jne nextCmp ; else jmp
    mov byte[es:0], 'L' ; yes print LEFT on top

    nextCmp:
        cmp al, 0x36    ; if right shift key
            jne noMatch ; else
        mov byte[es:0], 'R' ; yes print RIGHT on top

    noMatch:
       ; mov al, 0x20
       ; out 0x20, al    ; send EOI (end of interrupt) to PIC

        pop es
        pop ax
	jmp far [cs:old_isr]	; call the original ISR
        ;iret
	

start:
    xor ax, ax
    mov es, ax      ; point es to IVT Table

    mov ax, [es:9*4]
    mov [old_isr], ax ; save offset of old ISR

    mov ax, [es:9*4+2]
    mov [old_isr+2], ax

    cli         ; disable interrupts
    mov word[es:9*4],kbIsr      ; changing IVT offset
    mov     [es:9*4+2], cs      ; offset change
    sti         ; enable interrupts

L1:
    mov ah, 0   ; service 0, get keystroke
    int 0x16    ; BIOS keyboard service

    cmp al, 27  ; if ESC key pressed
        jne L1      ; else

    ; restore previous state of ISR
    mov ax, [old_isr]
    mov bx, [old_isr+2]
    cli
    mov [es:9*4], ax
    mov [es:9*4+2], bx
    sti

    mov ax, 0x4c00
    int 21h

