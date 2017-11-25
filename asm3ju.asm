.386

Data1 segment para use16
	I1 db ?
	I2 db ?
	I3 db ?
	A1 dw 4 dup (5 dup (6 dup (0)))
	adress dd Code2Beg
Data1 ends

Code1 segment para use16
	assume CS:Code1, DS:Data1
Code1Beg:
	mov AX, Data1
	mov DS, AX
	mov I1, 0
	mov I2, 0
	mov I3, 0
	mov DX, 0
	
	_do:
			inc DX
			xor AX, AX
			mov Al, I1
			imul BX, AX, 5*6*2
			mov Al, I2
			imul ECX, AX, 6*2
			mov Al, I3
			mov SI, AX
			lea DI, [ECX+ESI*2]
			
			mov Al, I1
			add Al, I2
			add Al, I3

			test  eax,1
			jz    _Even

			mov Al, I1
			test  eax,1
			jz    _Odd

			mov Al, I3
			test  eax,1
			jz    _Odd

			mov Al, I3
			test  eax,1
			jz    _Odd
			jmp _continue

			_Odd:
			lea AX, A1[BX+DI]
			mov A1[BX+DI], AX
			jmp _continue				

			_Even:
			mov A1[BX+DI], DS 

			_continue:
			
			inc I3
			cmp I3, 6
			jl _do
		mov I3, 0
		inc I2
		cmp I2, 5
		jl _do
	mov I2, 0
	inc I1
	cmp I1, 4
	jl _do

	mov DX, 0
	jmp dword ptr adress
Code1 ends

Data2 segment para use16
	A2 dw 4 dup (5 dup (6 dup (0)))
Data2 ends

Code2 segment use16
	assume CS:Code2, DS:Data1, ES:Data2
Code2Beg:
	mov AX, Data1
	mov DS, AX
	mov AX, Data2
	mov ES, AX
	
	mov CX, 4*5*6*2
	lea DI, A2
	lea SI, A1

	cld
	rep movsw

	lea DI, A2

	mov DX, 0 ;количество совпалений
	mov AX, Data1

	mov CX, 4*5*6*2

	cld
	_find:
		repne scasw
		jcxz _exit
		inc DX
		jmp _find
	
	_exit:
	mov	AX,	4c00h
	int	21h
Code2 ends
end Code1Beg