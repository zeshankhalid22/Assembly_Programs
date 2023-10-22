[org 0x0100]

    jmp start

    message: db 'Hi there! I am learning Assembly language.', 0    ; 0 for string termination

STRLEN:
    push bp
    mov  bp,sp
    push es
    push cx
    push di

    ; [bp+4] = ax(message)
    ; [bp+6] = ds(address of data segement)

    les di, [bp+4]  ; load [bp+4] in di, also [bp+4+2] = [bp+6] in ES
    mov cx, 0xffff  ; max possible length, as cx gonna decrement

    mov al, 0   ; store null terminating point

    ; repeat untill not equal , scan string byte
    repne scasb     ;  compare [ES:DI] (which is address of String) with AL untill they are not equal
                    ;  increment DI by 2, then again compare
                    ; for example String 'ABC'0
                    ; cmp A <--> 0  , inc  DI by 2,   dec cx by 1
                    ; cmp B <--> 0  , - - - - - - - - - - - - -
                    ; cmp C <--> 0
                    ; cmp 0 <--> 0

     ; now cx will be decrement N (length) times,
     mov ax, 0xffff
     sub ax, cx     ; now ax will have amount of value decremented from cx

    dec  ax ; exclude null (0) from the length

    pop  di
    pop  cx
    pop  es
    pop  bp
    ret  4

clrscr:
    push es
    push ax
    push cx
    push di

    mov ax, 0xb800  ; base address of video memory
    mov es, ax
    xor di, di  ; make di 0

    mov ah, 0x07    ; attributes of value to be printed,
    mov al, 0x20    ; ASCII value to be printed

    mov cx, 2000    ; maximum location till we printed

    cld     ; clear direction flag, to enable auto-increment mode for CX
    rep stosw   ; rep cx times, mov SOURCE in DESTINATION
        ; SOURCE is AX, DESTINATION is [ES:DI],     inc DI by 2 also

    pop di
    pop  cx
    pop  ax
    pop  es
    ret

printLength:
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
    call clrscr

    push ds
    mov  ax, message
    push ax
    call STRLEN


    push ax ; length is in ax, push and print it
    call printLength



    mov ax, 0x4c00
    int 0x21
