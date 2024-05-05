;=================================================================================;
;                                  8086 Assembly
;                       Advanced Microprocessor Lab Project
;                                    Done By:
;                                  Tamim Salhab
;                                    May 2024
;=================================================================================;
.MODEL SMALL	; Memory configuation 
.STACK 100H		; Stack size 

.data			; Data section

;======================== Main Prompts & Variabels ===============================:
PrintMagicSquare DB 0AH,0DH,"1. Magic Square$"
PrintTitleCase DB 0AH,0DH,"2. Title Case$"
PrintPower2 DB 0AH,0DH,"3. Power2$"
PrintExit DB 0AH,0DH,"4. Exit$"
PrintEnterYourChoice DB 0AH,0DH,"Enter your choice:$"
x1 DB 1
x2 DB 2
x3 DB 3
x4 DB 4
zero DB 0
space DB 0AH,0DH,"$"
choice DB 0

;======================== Magic Square Prompts & Variabels =======================;
PrintEnterDim DB 0AH,0DH,"Enter dimentions of array:$"
PrintTheMatrix DB 0AH,0DH,"The Matrix:$"
isSquare DB 0AH,0DH,"is a square matrix$"
isNotSquare DB 0AH,0DH,"is not a square matrix$"
PrintEnterNumbers DB 0AH,0DH,"Enter numbers:$"
sum1 DB 0
sum2 DB 0
arrsize DB 0
Array DB 255 DUP (0)

;======================== Title Case Prompts & Variabels =========================;
PrintTitleCaseEnter DB 0AH,0DH,"Enter a text:$"
titleWordResult DB 0AH,0DH,"Number of words is: $"
SpaceSign DB " "
DollerSign DB "$"
arrdim DB 0
title2 DB 255 DUP (0)

;======================== Power2 Prompts & Variabels =============================;
PrintEnterThreeDigit DB 0AH,0DH,"Enter three digit number:$"
PrintPower2Result DB 0AH,0DH,"The result is: $"
num DW 0
tenk DW 10000
HUNDk DD 1000000
ten DB 10
hun DB 100
rem DB 0

.code			
;=============================== Code Section ====================================;

;=============================== Magic Square ====================================;
MagicSquare PROC

    LEA DX,PrintEnterDim                        ; print massege to enter dimention
    CALL print

    CALL Read                                   ; read dimemtnions
    SUB AL,30H                                  ; subtracting 30H to deal with real value
    MOV arrdim,AL                               ; store dim value
    MUL arrdim                                  ; array dim * array dim to get a matrix 
    MOV arrsize,AL
    MOV AH,00H              
    LEA DX,PrintEnterNumbers                    ; print massege to enter array values
    CALL print                                  

    MOV SI,00                                   ; setting index to 0, to store elemetnts in array
    MOV BL,AL                                   ; size of array

    readnums:                                   ; read array numbers
        CALL read
        SUB AL,30H                              ; subtracting to get real value
        MOV Array[SI],AL                        ; storing value in array
        INC SI                                  ; increment counters
        DEC BL                                  ; dec size of array
        CMP BL,zero                             ; compare size of array if finished
    JNE readnums

    LEA DX,PrintTheMatrix                       ; print the matrix is:
    CALL print
    LEA DX, space                               ; printing new line
    CALL print

                                                ; to print the matrix

    MOV SI,00                                   ; setting counter for indexing to print the matrix
    MOV BL,arrdim                               ; setting arrdim to stop each line
    MOV CL,00
    L1:                                         ; loop to itterate over lines
        L2:                                     ; loop to itterate over columns
            MOV DL,Array[SI]                    ; printing codes
            ADD DL,30H
            CALL PrintChar
            INC SI                              ; increment for index
            INC CL
            CMP CL, arrdim
        JNE L2
        MOV CL,00
        LEA DX, space                           ; printing new line between lines
        CALL print
        DEC BL
        CMP BL,zero
    JNE L1

    MOV SI,00
    MOV CL,00
    MOV AL,00H

    L3:                                         ; getting first sum to compare
        ADD AL, Array[SI]                       ; Calculatting sum of elements
        INC SI
        INC CL
        CMP CL,arrdim
    JNE L3

    MOV sum1,AL                                 ; storing sum value
    ADD sum1,30H

                    ; loop to check for horizantal sum

    MOV SI,00                                   ; defining new counters and index
    MOV BL,arrdim
    MOV CL,00
    MOV sum2,00

    L4:                                         ; start of first loop
        L5:                                     ; second loop to itterate over the whole array
            MOV DL,Array[SI]                    ; calculating sum to compare
            ADD sum2,DL
            INC SI
            INC CL
            CMP CL, arrdim
        JNE L5                                  ; comparing sum
        MOV CL,00
        MOV DL,sum2
        ADD DL,30H
        CMP DL,sum1
        JNE printNOT1                           ; if sum not equal then print not a square
        MOV sum2,00
        DEC BL
        CMP BL,zero
    JNE L4

    JMP we

    printNOT1:                                  ; to print not a square
        LEA DX,isNotSquare
        CALL print
    JMP no
    we:
                ; loop to check for vertical sum

    MOV SI,00                                   ; defining new counters 
    MOV BL,00
    MOV CL,00
    MOV sum2,00
    MOV DI,00

    toADD:                                      ; loop to add every line
        INC DI
        INC CL
        CMP CL, arrdim
    JNE toADD
    
    MOV CL,00

    L6:
        L7:
            MOV DL,Array[SI]                    ; adding first value from first column
            ADD sum2,DL
            ADD SI,DI                           ; moving to next value in column
            INC CL
            CMP CL, arrdim
        JNE L7

        MOV CL,00
        MOV SI,01
        MOV CH,00
        DEC CH

        toADD2:
            INC SI
            INC CH
            CMP CH,BH
        JNE toADD2

        MOV DL,sum2
        ADD DL,30H
        CMP DL,sum1                             ; comparing with the sum to decide
        JNE printNOT
        MOV sum2,00
        INC BL
        CMP BL,arrdim
    JNE L6

  
                ; loop to check for diagnoal sum

    MOV SI,00
    MOV BL,00
    MOV CL,00
    MOV sum2,00
    MOV DI,01

    toADD3:                                     ; setting counter for first diagnoal check : + (dim + 1)
        INC DI
        INC CL
        CMP CL,arrdim
    JNE toADD3
    
    L8:                                         ; first loop to run of first diagonal
        MOV AL,Array[SI]
        ADD sum2,AL                             ; adding sum
        ADD SI,DI
        DEC CL
        JNZ L8

    MOV AL,sum1                                 ; comparing each sum with original sum
    SUB AL,30H
    CMP AL,sum2
    JNE printNOT

    MOV SI,00                                 
    MOV BL,00
    MOV CL,00
    MOV sum2,00
    MOV DI,00
    toADD4:                                     ; setting counter for second diagnoal check : + (dim - 1)
        INC DI                                    
        INC CL
        CMP CL,arrdim
    JNE toADD4
    DEC DI

    MOV SI,DI

    L9: 
        MOV AL,Array[SI]                        ; checking with the second sum from second diagonal
        ADD sum2,AL                             ; adding values to sum
        ADD SI,DI
        DEC CL
        JNZ L9

    MOV AL,sum1                                 ; comparing sum of second diagonal with original sum
    SUB AL,30H
    CMP AL,sum2

    JNE printNOT

    JMP printIs

    printNOT:                                   ; printing it is not a square
    LEA DX,isNotSquare
    CALL print
    JMP no

    printIs:                                    ; printing it is a square
    LEA DX,isSquare
    CALL print
    no:

RET 
MagicSquare ENDP
;=============================== Magic Square End =================================;

;================================== Title Case ====================================;

TitleCase PROC                                  ; title case method

    LEA DX,PrintTitleCaseEnter                  ; printing to user to enter text
    CALL print
    MOV DI,00                                   ; defining counters
    MOV CL,00
    MOV BL,01

    L0:
        CALL read
        CMP AL,DollerSign                       ; checking if it is $ to stop
        JE done             
        CMP BL,01                               ; checking if pervieos is space to capetalize
        JNE LoopToCheckSpace                    ; if not equal then don't capetalize
        SUB AL,32                               ; adding 32 to make it upper case
        MOV BL,00                               ; setting flag to zero, then don't capetalize
        INC CL
        LoopToCheckSpace:                       ; if char is space, then set flag to 1 to capetalize the next char
            CMP AL,SpaceSign
            JNE complete
            MOV BL,01                           
        complete:
            PUSH AX                             ; pushing the value to stack to use it later
            INC DI                              ; increment to count size of string
    JNE L0

    done:

    MOV SI,00                                   
    L55:                                        ; appending values to array to print
        POP AX
        MOV title2[SI],AL                       
        INC SI
        DEC BL
    JNZ L55

    LEA DX, space                               ; print new line
    CALL print

    MOV SI, DI                                  
    DEC SI
    LoopToPrintString:                          ; loop to print string 
        MOV DL, title2[SI]
        CALL PrintChar
        DEC SI
    JNZ LoopToPrintString

    MOV DL, title2[SI]    
    CALL PrintChar

    LEA DX,titleWordResult                      ; print how many words we have
    call print
    MOV DL,CL
    ADD DL,30H
    call PrintChar
    JMP MainLoop                    

    RET 
TitleCase ENDP

;=============================== Title Case End =================================;

Readnum PROC                                   ; method to read three digit number
    MOV AX,0
    CALL read
    SUB AL,30h
    MUL hun
    MOV num,AX
    CALL read
    SUB AL,30h
    MUL Ten
    ADD num,AX
    CALL read
    SUB AL,30h
    ADD num, AX
RET
Readnum ENDP

powerCalculate PROC                             ; method to mul: num * num
    MOV AX,0
    MOV AX,num
    MUL AX
    MOV num,AX
RET
powerCalculate ENDP

Displaynum PROC                                 ; method to display three digit number
    MOV AX,0
    MOV AX, num
    DIV HUN
    MOV rem, AH
    MOV DL, AL
    ADD DL, 30h
    CALL printChar
    MOV AL, rem
    MOV AH,0
    DIV TEN
    MOV DL, Al
    ADD DL, 30h
    MOV rem, AH
    CALL printChar
    MOV DL, rem
    ADD DL, 30h
    CALL printChar
    RET
Displaynum ENDP

;=============================== Power Two =================================;

Power2 PROC

POWERCHECKLOOP:
    LEA DX, PrintEnterThreeDigit                ; print to user to enter three digit value
    call Print
    CALL Readnum
    SUB num,256
    CMP num,255                                 ; check if out of range
    JG POWERCHECKLOOP                           ; jump if greater to the loop again
    CMP num,0                                   ; check if 0 or less
    JL POWERCHECKLOOP                           ; jump to loop again

    call powerCalculate                         ; calculate square
    LEA DX, space                               
    CALL print                              
    LEA DX, PrintPower2Result                   ; show the result message
    call print

    MOV CX,2
    MOV BX ,TENk

    LoopToPrintFirst2Values:                    ; loop to print the first two digits of result
        MOV DX,0
        MOV AX,num
        DIV BX                                  ;  AL = AX / hundred  AH = AX %  hundred
        MOV num,DX
		MOV DL,AL
        ADD DL,30H
        CALL PrintChar
        SUB BX,9000                             ; 10000 - 9000 = 1000 to print the second
        LOOP LoopToPrintFirst2Values
	CALL Displaynum                             ; print three digit number

RET 
Power2 ENDP
;=============================== Power Two End =================================;

PrintChar PROC                                  ; print char function
    MOV AH,02H
    INT 21H
RET 
PrintChar ENDP

Print PROC                                      ; print string function
    MOV AH,09H
    INT 21H
RET 
Print ENDP


Read PROC                                       ; read char function
    MOV AH,01
    INT 21H
RET 
Read ENDP

MAIN PROC
    MOV AX,@DATA	
    MOV DS,AX


;=============================== Code Here ====================================;

MainLoop:

    LEA DX, PrintMagicSquare                    ; print magic square massege
    CALL Print

    LEA DX, PrintTitleCase                      ; print title case massege
    CALL Print

    LEA DX, PrintPower2                         ; print power2 massege
    CALL Print  

    LEA DX, PrintExit                           ; print exit massege
    CALL Print

    LEA DX, PrintEnterYourChoice                ; print enter your choice massege
    CALL Print

    CALL Read                                   ; read choice
    SUB AL, 30H

    CMP AL,x1
    JE choice1                                  ; jump to choice 1 / magic square

    CMP AL,x2
    JE choice2                                  ; jump to choice 2 / title case

    CMP AL,x3
    JE choice3                                  ; jump to choice 3 / power 2

    CMP AL,x4
    JE choice4                                  ; jump to choice 4 / exit

    choice1:                                    ; jump to function magic square
        CALL MagicSquare
        JMP after

    choice2:                                    ; jump to function title case
        CALL TitleCase
        JMP after 

    choice3:                                    ; jump to function power2
        CALL Power2 
        JMP after

    choice4:                                    ; exit program
        JMP exit

    after:

JMP MainLoop

exit:

MOV AH,4CH	; End the program
INT 21H

MAIN ENDP
END MAIN
