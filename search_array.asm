[org 0x100]

mov bx, 0

search_start:
mov ax, [Array + bx]
cmp ax, value
je found

inc bx
inc bx

cmp bx, 10    ; if value not found till size
je not_found

jmp search_start

found:
 mov dx, [Array + bx]	; storing address where value found
mov ax, 0x4c00
int 0x21

not_found:
mov ax, 0x4c00
int 0x21

Array: dw 1000, 2020, 1500, 4500, 1050
value: dw 4500

