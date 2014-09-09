#PACKAGE DOCUMENTATION (roxygen2)
#' Fast file writing with CWriteR.
#'
#' CWriteR provides functions that use C code to write 
#' output files. These C functions are much faster than the 
#' base R output functions, which is useful if you need to write
#' millions or billions of entries to a file quickly.
#'
#' 
#' @references \url{http://www.github.com/sheffien}
## @import if you import any packages; here.
#' @docType package
#' @name CWriteR
#' @author Nathan Sheffield
#' @useDynLib CWriteR
NULL

#FUNCTION DOCUMENTATION
#' cwrite: Write vector to file
#'
#' Write a vector to a file using C for fast writing. Not much more complicated than that. It's faster than the base R write functions.
#'
#'
#' @param y vector to write.
#' @param l length of the vector; (you can provide length(y)).
#' @param file output filename.
#' @export
#' @examples
#' d = rnorm(1000);
#' cwrite(d, length(d), "output.txt")
cwrite <- function(y, l, file) {
	#Check for file sanity.
	if(file.access(file, mode=0) != 0) {
		#file does not exist; create it.
		file.create(file);
	} else if(file.access(file, mode=2) != 0) {
		stop("file [", file, "] not writable!");
	} else {
		warning("File exists; appending.");
	}

	#Call C function
	res = .Call("cwriteC",
		y = 	y,
		l = 	as.numeric(l), 
		file =	path.expand(file),
	PACKAGE = "CWriteR");
	if(res==1) return(1);
	return(0);
}

#FUNCTION DOCUMENTATION
#' cwriteStep: Write a sample of a vector to a file using C for fast writing.
#'
#' This function will output every Nth NONZERO entry of a vector to a file.
#' Useful if you need just a sample of a large vector.
#'
#' @param y vector to write.
#' @param l length of the vector; (you can provide length(y)).
#' @param file output filename.
#' @param step output every Nth entry in the vector y.
#' @export
#' @examples
#' d = rnorm(1000);
#' cwriteStep(d, length(d), "output.txt", step=100)
cwriteStep <- function(y, l, file, step)
{
	#Check for file sanity.
	if(file.access(file, mode=0) != 0) {
		#file does not exist; create it.
		file.create(file);
	} else if(file.access(file, mode=2) != 0) {
		stop("file [", file, "] not writable!");
	} else {
		warning("File exists; appending.");
	}
	res = .Call("cwriteStepC",
		y = 	y,
		l =	as.numeric(l), 
		file =	path.expand(file),
		step =	step,
      PACKAGE = "CWriteR");
	if(res==1) return(1);
	return(0);
}
