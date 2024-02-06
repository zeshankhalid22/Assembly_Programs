[org 0x100]

jmp start

start:
 mov ah, 0x00 ; service to wait for key press and read key
 int 0x16     ; keyboard interrupt

 ; At this point, AL contains the ASCII value of the key pressed
 ; and AH contains the scan code

 ; Now, let's print the ASCII value of the key pressed
 mov ah, 0x0E ; service to teletype output
 mov bh, 0x00 ; page number
 mov bl, 0x07 ; text attribute (lightgray)
 int 0x10     ; video service interrupt

 ; Terminate the program
 mov ax, 0x4c00
 int 0x21
