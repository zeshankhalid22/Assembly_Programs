; Program to print a  number on Screen(Video memory) Using Function Calling(Stacks)

[org 0x0100]

jmp start

num dw 14678

clrscr:
    push es
    push ax
    push di

    mov  ax, 0xb800 ; base address of extra segment (video memory)
    mov  es, ax
    mov  di, 0  ; for indexing

    nextloc:
        mov  word [es:di], 0x0720   ; print space, black background
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di
    pop  ax
    pop  es
    ret


print:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push di
    push es

    ; now split the digits and push it on the top of stack

    mov ax, [bp+4]  ; moving data into ax

    mov bx, 10  ; as we divide by 10
    mov cx, 0   ; counter for how many digits

    nextDigit:
        xor dx, dx  ; clear dx if it has any value

        div bx  ;ax =  ax / bx (quotient in ax), dl = ax % bx,  remainder in dl
        ; why in dl? bcz remainder will be very small number (0-9), which will be stored in lower byte of dx, dh will remain 00

        add dl, 0x30    ; get it's ascii value

        push dx ; push dx(word) on top of stack, why not dl? bcz stack count 2 byte as memory unit
        inc cx

        cmp ax, 0
        jnz nextDigit


        ; let's print it
        mov ax, 0xb800  ; base address of extra segment (video memory)
        mov es, ax

        mov di, 0   ; for indexing
        printNextPos:
            pop dx  ; mov stack.top() into dx   , already in ASCII
            ; in dl, we have the value(which was remainder of some division) to be printed out (0-9)

            ; in dh, we can insert attributes for the number to be printed out
            ;mov dh, 0x07    ; simple black background
            mov dh, 0x04    ; for red forground
            ; [ you can change attributes according to what you want]

            mov [es:di], dx ; print dx on es(video memory) at di location
            add di, 2   ; increment counter for printing on next index/memory block

            loop printNextPos    ; loop until cx become 0

        ; now we are done

        ;let's pop the registers in reverse order

    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp

    ret 2   ; pop ip, pop (paramter 1)


start:
    call clrscr ; clear out screen before printing


    mov ax, [num] ; moving nums location into ax
    push ax
    call print




mov ax, 0x4c00
int 0x21
