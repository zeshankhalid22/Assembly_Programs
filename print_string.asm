 
[org 0x0100]

jmp _main

message db "Hello, Intel x86 Assembly", 0  ; null terminating string


_main:

; Load base addres of video memory
mov ax, 0x0b800
mov es, ax
mov di, 1500    ; Destination from where you wanna start printing

mov si, message ; source address of string to be printed
mov ah, 0x05    ; attribute for characters to be printed on memory  (pink foreground)

print_string:
    mov al, byte[si]    ; Load Source Address of String into AL
    inc si  ;  move SI to next Address
    cmp al, 0   ; check if AL contain NULL terminating char
        jz Done ; exit the loop

    ; mov AX to [DI:DI]
    mov [es:di], ax ;print AL with property(AH) on [ES:DI] and inc DI,2
    add di, 2

jmp print_string    ; continue printig


Done:

mov ax, 0x4c00
int 21h
