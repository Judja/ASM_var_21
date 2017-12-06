#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define n 11 // ê³ëüê³ñòü áàéò³â ó íàäâåëèêîìó ÷èñë³

typedef unsigned char byte; // äëÿ ðîáîòè ç áàéòàìè âèêîðèñòîâóºòüñÿ òèï char

extern "C" bool Biggr(byte* M1, byte* M2, short len);

void PrintBinary(byte *number, short length)
{
	for (short i = length; i != 0; --i)
	{
		byte currentPart = *(number + i - 1);
		currentPart & 0x80 ? printf("1") : printf("0");
		currentPart & 0x40 ? printf("1") : printf("0");
		currentPart & 0x20 ? printf("1") : printf("0");
		currentPart & 0x10 ? printf("1") : printf("0");
		currentPart & 0x08 ? printf("1") : printf("0");
		currentPart & 0x04 ? printf("1") : printf("0");
		currentPart & 0x02 ? printf("1") : printf("0");
		currentPart & 0x01 ? printf("1") : printf("0");
		printf(" ");
	}
	printf("\n\n");
}
int main()
{
	srand(time(NULL));
	byte x[n], y[n];//íàäâåëèêå ÷èñëî
	bool f;
	for (int i = 0; i<n; i++)
	{
		//x[i] = rand() % 255;
		//y[i] = rand() % 255;
		x[i] = 1;
		y[i] = 0;
	}
	printf("Before: \n\n");
	printf("M1 = \n");
	PrintBinary(x, n);
	printf("M2 = \n");
	PrintBinary(y, n);
	_asm {
		push n
		lea eax, y
		push eax
		lea eax, x
		push eax
		call Biggr
		mov f, al
		add sp, 12
	}
	if (f == true)
		printf("M1 bigger\n");
	else
		printf("M2 bigger\n");
	system("pause");
	return 0;
}
