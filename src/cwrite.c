#include <stdio.h>
#include <R.h>
#include <Rinternals.h>

// This function simply writes a vector to a file in C
SEXP cwriteC(SEXP y, SEXP l, SEXP file)
{
	//convert R variables into C variables
	char* cFile = CHAR(STRING_ELT(file, 0));
	double *y_c = REAL(y);
	double *length = REAL(l);

	//open a file
	FILE* ofp = fopen(cFile, "a"); //a for append.
	float x;
	printf("Writing %i items...", (int) *length);

	//loop through vector, printing to file
	for (int i=0; i<*length; i++) {
		x = (float) y_c[i];
		fprintf(ofp, "%.4g\n", x);
	}
	fclose(ofp);
	
	//report success
	SEXP result;
	PROTECT(result = allocVector(REALSXP, 1));
	UNPROTECT(1);
	return result;
}

//This function does the same thing, but prints only every nth NONZERO value
SEXP cwriteStepC(SEXP y, SEXP l, SEXP file, SEXP step)
{
	//convert R variables into C varibles
	char* cFile = CHAR(STRING_ELT(file, 0));
	double *y_c = REAL(y);
	double *length = REAL(l);
	double *cStep = REAL(step);

	//open a file
	FILE* ofp = fopen(cFile, "a"); //a for append.
	float x;
	int count =0;
	printf("Writing %i items...", (int) (*length / *cStep) );

	//loop through vector, printing to file
	for (int i=0; i<*length; i++) {
		x = (float) y_c[i];
		if (x != 0) { //skip if x == 0
			if (count == *cStep) { //only print every nth value
				fprintf(ofp, "%.4g\n", x);
				count = 0;
			}
		count++;
		}
	}
	fclose(ofp);

	//report success
	SEXP result;
	PROTECT(result = allocVector(REALSXP, 1));
	UNPROTECT(1);
	return result;
}
