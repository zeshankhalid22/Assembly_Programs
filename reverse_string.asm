[org 0x100]

jmp _main

myString db "HELLO, WORLD", 0

findLength:
    push bp
    mov bp, sp

    mov si, [bp+4]  ; load string


    Count:
        lodsb ; AL <- [ES:SI] , inc SI
        cmp al, 0   ; whether last char
            je reverse_string   ; means length is calculated, now reverse it
        inc cx  ; holds length
        jmp Count  ; continue searching untill NULL, 0 appears

    reverse_string:
        mov si, [bp+4]  ; loading String starting Address again
        mov di, si  ; DI points to last Index of String
        add di, cx
        dec di

    reverse_loop:
        cmp si, di
            jae reversingDone   ; if Si >= Di; we are done

        ; swap characters and SI and DI
        mov al, [si]
        mov bl, [di]
        mov [si], bl
        mov [di], al

        ; mov SI and DI to their next positions
        inc si
        dec di

        jmp reverse_loop

    reversingDone:
        pop bp
        ret 2

_main:

    xor cx, cx  ; clear CX

    mov si, myString
    push si
    call findLength

    ; Now CX have length of reversed String
    ; Let's print Reversed String


    mov si, myString
    mov di, 1680 ; location from where to start print

    ; parameters
    push cx
    push di
    push si
    call printString


mov ax, 0x4c00
int 0x21

printString:
    push bp
    mov bp, sp

    push ax
    push cx
    push si
    push di

    ; First Clear Out The Screen
;   --------------
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, 2000
    cld
    rep stosw
;   -----------

    mov ax, 0xb800
    mov es, ax



    mov si, [bp+4]  ; points to string
    mov di, [bp+6]  ; location where to start printString
    mov cx, [bp+8] ; load length of string
    mov ah, 0x04    ; load attribute for printing

    cld
    nextChar:
        lodsb   ; loads next char in AL
        stosw   ; AX -> [ES:DI]. inc DI,2
        loop nextChar   ; loop untill cx became 0

    pop di
    pop si
    pop cx
    pop ax

    ret 8   ; pop all parameters
