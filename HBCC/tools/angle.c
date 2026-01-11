#include <stdio.h>
#include <math.h>

/*
                   /
                 /b|
                /  |
           C  /    |
             /     | A
           /       |
          /a      c|
         /----------
              B

       A       B       C
     ----- = ----- = -----
     sin a   sin b   sin c

     c = 90 deg; sin 90 = 1.0
     b = 90 - a
     B = 1.0
     C = 1.0 / sin (90 - a)
     A = sin a / sin (90 - a)

*/

int main(int argc, char **argv)
{
	double angle, s, e, a, b, h, A, B;
	int i, f, sh[256], sa[256], sb[256];

	e = 0;
	for (i=0; i < 256; i++)
	{
		angle = i*2*M_PI/256;	
		a = sin(angle);
		b = sin(M_PI/2 - angle);
		sa[i] = a * 256 + 0.0;
#if 0
		h = 1.0 / b;
		A = a / b;
		B = b / a;
		if (A >= 1.0) A = 0.0;
		if (B >= 1.0) B = 0.0;
		f = a > 0.0 ? a * 256 + 0.5 : a * 256 - 0.5;
		e += a - f/256.0;
		sh[i] = (h - 1.0) *256 + 0.5;
		sa[i] = A * 256 + 0.5;
		sb[i] = B * 256 + 0.5;
		//printf("%d: sin(%f) = %f : %d\n", i, angle, s, f);
		printf("%d:Hypotnuse(%f) = %f; Height = %f, Slope = %f\n", i, angle, h, A, B);
#endif
	}
#if 0
	printf("\nFRACHYP\tHEX\t");
	for (i=0; i < 64; i++)
	{
		printf("%02X", sh[i]);
		if ((i&15)==15) printf("\n\tHEX\t");
	}
	printf("\nMINLEN\tHEX\t");
	for (i=0; i < 64; i++)
	{
		printf("%02X", sa[i]);
		if ((i&15)==15) printf("\n\tHEX\t");
	}
	printf("\nMAJLEN\tHEX\t");
	for (i=0; i < 64; i++)
	{
		printf("%02X", sb[i]);
		if ((i&15)==15) printf("\n\tHEX\t");
	}
	printf("\n");
	//printf("Total error = %f\n", e);
#endif
	printf("\nSINL\tHEX\t");
	for (i=0; i < 256; i++)
	{
		printf("%02X", sa[i]&0xFF);
		if ((i&15)==15) printf("\n\tHEX\t");
	}
	printf("\n");
	printf("\nSINH\tHEX\t");
	for (i=0; i < 256; i++)
	{
		printf("%02X", (sa[i]&0xFFFF) >> 8);
		if ((i&15)==15) printf("\n\tHEX\t");
	}
	printf("\n");
	return (0);
}
