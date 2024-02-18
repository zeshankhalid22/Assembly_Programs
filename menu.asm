[org 0x100]

jmp start

menu_message: db 'Waiting for keypress . . .'
message: db 'You pressed a key!'

start:


    main_loop:
	mov ah, 0x13	; Screen output Code
	mov al, 1		; Sub-code text output
	mov bh, 0		; page number
	mov bl, 6		; text attribute

	mov dh, 0x05	; row number
	mov dl, 0x04	; column number

	mov cx, 26		; string length
	push cs
	pop es
	mov bp, menu_message

	int 0x10		; video service interrupt call
;
    ; Wait for a keypress
    mov ah, 0x00
    int 0x16
;
    ; Clear the screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10
;
    ; Display the message
    mov ah, 0x0E
    mov dx, message
    int 0x10

    ; Wait for a keypress to continue or terminate
    mov ah, 0x00
    int 0x16

    ; Check if ESC (ASCII 27) key is pressed to exit the program
    cmp al, 27
    je exit_program

    ; Clear the screen and continue the loop
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    jmp main_loop

    exit_program:
    ; Terminate the program
    mov ax, 0x4C00
    int 0x21


