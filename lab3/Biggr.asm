.386
.model flat, C

public Biggr

.code
Biggr proc

push ebp
mov ebp, esp

mov edi, [ebp + 8]
mov esi, [ebp + 12]
xor dx, dx
xor ebx, ebx
mov bx, [ebp + 16]
dec bx
_do:
	mov dl, [edi + ebx]
	mov dh, [esi + ebx]

	cmp dl, dh
	je _continue
	jg _grt
	jl _low
	_continue:
	dec bx
	cmp bx, 0
	jge _do
jmp _low

_grt:
pop ebp
mov al, 1
ret

_low:
pop ebp
mov al, 0
ret

Biggr endp

end
