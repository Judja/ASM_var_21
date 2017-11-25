code SEGMENT
	ASSUME cs:code

	begin:

; we have to convert 76543210 to 21003306
	mov dl, 10101010b	;set value for first operand
						;program will convert it to 01001100
						;10101010 is AAh
						;01001100 is 4Ch
						;01011100 is 5C
						;4CAAh value in DX is expected

	mov bl, dl	;we will use bl register as a buffer
	mov dh, 0

; in this block, we write xxxxx210 to 210xxxxx
	mov cx, 5
loop_1:
	shl bl, 1
	loop loop_1
	and bl, 11100000b
	or dh, bl

; here we write 7xxxxxxx to xxx7xxxx
	mov bl, dl
	mov cl, 3
	shr bl, cl
	and bl, 00010000b
	or dh, bl

; here we write xxxx3xxx to xxxx33xx
	mov bl, dl
	and bl, 00001000b
	or dh, bl
	shr bl, 1
	or dh, bl

; here we write xxxxxxx0 to xxxxxx0x
	mov bl, dl
	shl bl, 1
	and bl, 00000010b
	or dh, bl

; here we write x6xxxxxx to xxxxxxx6
	mov cx, 6
loop_2:
	shr bl, 1
	loop loop_2
	and bl, 00000001b
	or dh, bl

	nop

	mov ah, 4Ch
	int 21h
code ENDS
	end begin