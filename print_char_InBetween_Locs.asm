; The program will Print a CHAR from startingLocation till endingLocation

[org 0x0100]

jmp start

; These Variables can be modified according  to need
    charToPrint db '$'
    ; Starting Address should be less than ending Address
    startingLocation dw 1500
    endingLocation dw 2500

printHalfScreen:
    push bp
    mov bp, sp  ; fixing bp to access parameters easily

    ; Local Variables
    push ax
    push bx
    push cx

    ; adding video Memory Address
    mov ax, 0xb800
    mov es, ax

    ; Loading parameters
    mov cx, [bp+4]  ; counter
    mov di, [bp+6]  ; offset address
    mov ax, [bp+8]  ; value to print


    rep stosw   ; AX -> [ES:DI], inc DI,2
    ; rep until cx became 0

    pop cx
    pop bx
    pop ax
    pop bp
    ret

start:
    call clrscr


    mov al, [charToPrint] ; value, * $ % or whatever
    ; property for printing
    mov ah, 0x01    ; blue foreground

    ; loeading offsets
    mov cx, [startingLocation]
    mov bx, [endingLocation]

    ; check whether endingLocation > startingLocation
    cmp cx, bx  ; BX - CX
        jg END      ; if BX < CX , then END
    ;  otherwise

    ; counter of how many words
    sub bx, cx  ; BX = BX - CX      ,e.g 500 - 300 = 200
    mov cx, BX
    shr cx, 1             ; e.g 200 / 2 = 100, so 100 counters of words from 300 to onward till 500

    mov bx, [startingLocation]

    ;Pushing Parameters
    push ax ; value with property
    push bx ; startingLocation
    push cx ; counter from startingLocation to endingLocation


    call printHalfScreen


END:
mov ax,0x4c00
int 0x21        ; Terminate the Program

clrscr:
    push es
    push ax
    push di

    mov  ax, 0xb800
    mov  es, ax
    mov  di, 0

    nextloc:
        mov  word [es:di], 0x0720
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di
    pop  ax
    pop  es
    ret


