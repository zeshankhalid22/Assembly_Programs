[org 0x100]

jmp start

num dw 122
reverse dw 1



start:

mov ax, [num]
xor dx, dx

; for the first time,
;multiplication with 10 will not needed.

mov bx, 10
div bx
mov [reverse], dx




Reversing:
; to multiply reversed value with 10

xor dx, dx
mov bx, 10
div bx  ; -> AX = AX/10,  DX = DX%10



; 10 = 1010b
; let 5(101b) * 10(1010b)
;    000
;   101x     (shl 1)
;  000xx    +(shl 1)
; 101xxx    +(bx)
; 101010    <- ans (15)


; Mul by 10 Starts
mov bx, [reverse]   ; copy reverse
shl word[reverse], 1
shl bx, 3
add [reverse], bx
; Finally Multiplied by 10


; add remainder DX in reverse
add [reverse], dx

cmp ax, 0
jnz Reversing

;now compare reversed and actual number
mov ax, [num]
cmp [reverse], ax
jne end

Palindrome:
mov ax, 1

end:
mov ax, 0



; terminator
mov ax, 0x4c00
int 0x21
