ORG 100h            ; Standard 16-bit DOS executable format

section .data
num dw 1234         ; The number to reverse
reversed dw 0       ; Variable to store the reversed number

section .text
    mov ax, [num]   ; Load the number into AX
    xor bx, bx       ; Initialize BX to 0 (to accumulate reversed number)

reverse_loop:
    mov cx, 10       ; Load divisor 10 into CX
    mul cx           ; Multiply AX by 10
    add bx, dx       ; Add the low byte of the result to BX
    xor dx, dx       ; Clear DX
    and ax, 0FFFh    ; Mask out the upper bits of AX
    jnz reverse_loop ; If not zero, continue looping

    ; Now BX contains the reversed number

    mov [reversed], bx ; Store the reversed number in the 'reversed' variable

exit:
    mov ah, 4Ch       ; Exit to DOS
    int 21h

