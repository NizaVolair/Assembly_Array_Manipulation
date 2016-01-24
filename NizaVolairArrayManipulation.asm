TITLE Array Manipulation  (NizaVolairArrayManipulation.asm)

; Name: Niza Volair
; Email : nizavolair@gmail.com
; Date : 11 - 08 - 15
; Description: Program to calculate composite numbers.

INCLUDE Irvine32.inc

; upper and lower limits for input range checking
upperLimit = 400
lowerLimit = 1

.data


intro	BYTE	"Array Manipulaiton and Composite Calculations Programmed by Niza Volair", 0ah, 0dh, 0ah, 0dh
		BYTE	"This program generates random numbers in the range[100 .. 999], finds composites, ", 0ah, 0dh
		BYTE	"displays the list, sorts the list, and calculates the median value.", 0ah, 0dh
		BYTE	"Finally, it displays the list sorted in descending order.", 0ah, 0dh, 0ah, 0dh
		BYTE	"How many numbers should be generated ? [10 .. 200]: ", 0

error	BYTE	"Invalid input", 0

inst	BYTE	"How many numbers should be generated ? [10 .. 200]: ", 0

list	BYTE	"The unsorted random numbers: ", 0ah, 0dh

median	BYTE	"The median is: ", 0

sorted	BYTE	"The sorted list: ", 0





.code
main PROC



exit; exit to operating system
main ENDP


; Procedure to display introduction of program
; receives: intro is a global variable
; returns: message to screen
; preconditions:  intro is initialized
; registers changed : edx
introduction	PROC

;introduce the program
mov		edx, OFFSET		intro	
call	WriteString
call	Crlf
call	Crlf

ret
introduction	ENDP


; Procedure to get user input, uses call to subroutine validate to check input
; receives: num and inst are global variables
; returns: instructions printed to screen 
; preconditions:  inst is initialized
; registers changed : eax, edx
getUserData	PROC

; prompt for and get integer and put in num variable
mov		edx, OFFSET		inst
call	WriteString
call	ReadInt
mov		num, eax

; call subroutine for validation
call	validate

ret
getUserData	ENDP


; Procedure to validate input
; receives: num and error a global variables, limits are constants
; returns: error message or a number between 1 and 400 is in num
; preconditions:  num initialized with a number
; registers changed : edx
validate	PROC

; compare integer to upper and lower limits
cmp		num, upperLimit		; if greater than upper limit jump to error message and reprompt
jg		rangeError

cmp		num, lowerLimit		; if lower than lower limit jump to error message and reprompt
jl		rangeError

call	Crlf
jmp		goBack				; procedure should skip over rangeError unless there is an issue


rangeError:					; Data validation : If the user enters a number outside the range[1 .. 400] an error message should be displayed

mov		edx, OFFSET		error
call	WriteString
call	Crlf
call	getUserData			; and user should be prompted to re - enter the number of composites.

goBack:

ret
validate	ENDP


; Procedure to display composit numbers aligned in lines and rows, uses subroutine to get numbers
; receives: num, spaces 3/4/5, and curCol are global variables
; returns: up to 400 composit numbers aligned in lines and rows, uses subroutine to get numbers
; preconditions:  spaces3 / 4 / 5, and curCol are initialized
; registers changed : eax, ecx, edx
showCompsites	PROC

;loop the subroutine until the correct number of composite numbers are displayed
mov		eax, 3						; put 3 (+ 1 = 4 first composite number) in eax
mov		ecx, num					; The counting loop(1 to n) is implemented using the MASM loop instruction.

compositePrint:						; gets composits through subroutine and prints them 
call	isComposite					; calls subroutine to check numbers in eax and only return when a composite is found

printNum: 
call	writeDec					; print the number in eax, it has been checked against all in range primes and is certified composite


cmp		eax, 10						; compare composite in eax to 10 to see if it is 1 digit
jl		oneDigit
cmp		eax, 100					; compare composite in eax to 100 to see if it is 2 digits
jl		twoDigits
mov		edx, OFFSET		space3		; else must be 3 digit: display with at least 3 spaces between the numbers for 3 digit numbers
jmp		printSpaces


; spacing for display
twoDigits:
mov		edx, OFFSET		space4		; display 4 spaces between the numbers for 2 digit numbers
jmp		printSpaces

oneDigit:
mov		edx, OFFSET		space5		; display 5 spaces between the numbers for 1 digit numbers

printSpaces:
call	WriteString					; print correct number of spaces


inc		curCol						; The results should be displayed 10 composites per line 
cmp		curCol, 10					; check if new row is needed		
je		newRow						; make new row if needed
jl		loopAgain

; rows and columns for display
newRow:								
call	Crlf
mov		curCol, 0

loopAgain:
loop	compositePrint				; loop back to print another composite

call	Crlf
call	Crlf

ret
showCompsites	ENDP


; Procedure to get a composite number
; receives: primeArray and arrayLength are global variables
; returns: one of first 400 composite numbers in eax
; preconditions:  eax starts with 3
; registers changed : eax, ebx
isComposite	PROC

testNextNum:
inc		eax							; get next number which might be composite in eax(adds 1 to 3 to start at first composite)
mov		ebx, 0						; set ebx to 0 to use in array element accessing
mov		arrayLength, 93				; set arrayLength back to 93 to check against all possible primes

testArray:
cmp		eax, primeArray[ebx]		; test the potental composite against each of the primes in the array
je		testNextNum					; if the number is equal to a prime it is not composite, so loop again to next number without printing

add		ebx, 4						; increase ebx by 4 to get next DWORD in array
dec		arrayLength					; decrease arrayLength as one element has been checked
cmp		arrayLength, 0				; if arrayLength is at 0, there are no more elements
jg		testArray					; if it's greater than 0: loop again to test potential composite, else we have found a composite!!!

ret
isComposite	ENDP

; Procedure to display farewell for the program
; receives: outro global variable 
; returns: message to screen
; preconditions:  outro initialized
; registers changed : edx
farewell	PROC

; Display farewell message
mov		edx, OFFSET		outro
call	WriteString
call	Crlf
call	Crlf

ret
farewell	ENDP


END main