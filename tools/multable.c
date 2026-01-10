#include <stdio.h>

int main()
{
	int a, b;

	for (a=0; a < 16; a++)
	{
		for (b=0; b < 16; b++)
			printf("$%02X, ", a*b);
		printf("\n");
	}
	return (0);
}
