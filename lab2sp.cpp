#include <stdio.h>
#include <stdlib.h>

void cpp_f();
void asm_f();
void asm_opt_f();

int i, m;

int main() {
	cpp_f();
	asm_f();
	asm_opt_f();
	system("pause");
	return 0;
}

void cpp_f() {
	int A[9];
	m = 0;
	i = 8;

	do {
		m = 8 * i;
		switch (i) {
		case 2: m += 4; break;
		case 0: m = 17; break;
		case 7: m -= 4; break;
		case 1: m = 4; break;
		default: m++;
		}
		A[i] = m;
		i--;
	} while (i>-1);

	for (i = 0; i<9; i++)
		printf("%d ", A[i]);
	printf("\n");
}

void asm_opt_f() {
	int A[9];
	_asm
	{
		mov eax, 8

		_while:
		mov ebx, eax
			shl ebx, 3

			cmp eax, 2
			je SHORT case_2
			cmp eax, 0
			je SHORT case_0
			cmp eax, 7
			je SHORT case_7
			cmp eax, 1
			je SHORT case_1
			inc ebx
			jmp SHORT endswitch

			case_2 :
		add ebx, 4
			jmp SHORT endswitch
			case_0 :
		mov ebx, 17
			jmp SHORT endswitch
			case_7 :
		sub ebx, 4
			jmp SHORT endswitch
			case_1 :
		mov ebx, 4
			jmp SHORT endswitch

			endswitch :
		mov DWORD PTR A[eax * 4], ebx

			dec eax
			cmp eax, -1
			jg SHORT _while

	}

	for (int j = 0; j < 9; j++)
		printf("%d ", A[j]);
	printf("\n");
}

void asm_f() {
	int A[9];

	_asm
	{
		//; 15   : 	int m = 0;
		mov	 DWORD PTR m, 0
		//; 16   : 	int i = 8;
		mov	 DWORD PTR i, 8
		_while:

		//; 17   :
		//; 18   : 	do {
		//; 19   : 		m = 8 * i;

		mov	 eax, DWORD PTR i
			shl	 eax, 3
			mov	 DWORD PTR m, eax

			//; 20   : 		switch (i) {

			mov	 eax, DWORD PTR i

			mov	 ebx, eax

			cmp eax, 2
			je SHORT case_2
			cmp eax, 0
			je SHORT case_0
			cmp eax, 7
			je SHORT case_7
			cmp eax, 1
			je SHORT case_1

			jmp _default


			case_2 :

		//; 21   : 		case 2: m += 4; break;

		mov	 eax, DWORD PTR m
			add	 eax, 4
			mov	 DWORD PTR m, eax
			jmp	 SHORT endswitch
			case_0 :

		//; 22   : 		case 0: m = 17; break;


		mov	 DWORD PTR m, 17; 00000011H
			jmp	 SHORT endswitch
			case_7 :

		//; 23   : 		case 7: m -= 4; break;

		mov	 eax, DWORD PTR m
			sub	 eax, 4
			mov	 DWORD PTR m, eax
			jmp	 SHORT endswitch
			case_1 :

		mov	 DWORD PTR m, 4
			jmp	 SHORT endswitch
			_default :

		//; 24   : 		default: m++;

		mov	 eax, DWORD PTR m
			add	 eax, 1
			mov	 DWORD PTR m, eax
			endswitch :

		//; 25   :}
		//; 26   : 		A[i] = m;

		mov	 eax, DWORD PTR i
			mov	 ecx, DWORD PTR m

			mov	 DWORD PTR  A[eax * 4], ecx

			//; 27   : 		i--;

			mov	 eax, DWORD PTR i
			sub	 eax, 1
			mov	 DWORD PTR i, eax

			//; 28   : } while (i > -1);

			cmp	 DWORD PTR i, -1
			jg	 SHORT _while
	}
	for (int j = 0; j < 9; j++)
		printf("%d ", A[j]);
	printf("\n");
}
