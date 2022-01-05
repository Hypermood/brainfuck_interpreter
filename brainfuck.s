#.global brainfuck
.global main

.data

initAddr:   .skip 32
auxCounter: .skip 32
tempRax:    .skip 32
memCell:    .skip 16384


tempRax1:    .skip 32
tempRcx1:    .skip 32
tempRdi1:    .skip 32
tempRsi1:    .skip 32

printVar:   .asciz "%s"
inputVar:   .asciz "%s"


.text

testString: .asciz "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."




# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
#brainfuck:
main:
#Prologue
    pushq %rbp
    movq %rsp, %rbp
    
    movq $testString, %rdi

                                  # address of initial instruction in rdi
    movq $0, %rax                 # setting up the initial displacement
    
    movq $memCell, %rsi           # setting the init. address of memory cell
    
currentInstruction:
    
    movb (%rdi,%rax,1), %cl       # fetching the next character/instruction (ascii char eight bits)
    

# Different characters functions
                            

    cmpb $0, %cl           # program ending
    je stopParse
    
    cmpb $62, %cl          # pointer to next mem cell with >
    je nextMem
    
    cmpb $60, %cl          # pointer to previous mem cell with <
    je prevMem
    
    cmpb $43, %cl          # increase value at mem cell with +
    je incVal
    
    cmpb $45, %cl          # decrease value at mem cell with -
    je decVal
    
    cmpb $46, %cl          # print character in mem cell with .
    je printChar
    
    cmpb $44, %cl          # scan input character with ,
    je scanChar
    
    cmpb $91, %cl          # begin the loop with [
    je beginLoop
    
    cmpb $93, %cl          # end of loop with ]
    je endLoop
    

    
printChar: 
    
    pushq %rax
    pushq %rdi
    pushq %rcx
    pushq %rsi
    
    movq $0, %rax                   # no vector arguments needed
    movq (%rsi), %rsi
    movq %rsi, printVar
    movq $printVar, %rdi            # putting prompt base instruction as first argument
    call printf
    
    popq %rsi
    popq %rcx
    popq %rdi
    popq %rax
    
    
    incq %rax
    jmp currentInstruction
    
    
scanChar:                       # prompt user?

    call scanChar2
    
    incq %rax
    jmp currentInstruction
    
scanChar2:
    #Prologue
    pushq %rbp
    movq %rsp, %rbp
    
    movq %rax, tempRax1
    movq %rdi, tempRdi1
    movq %rcx, tempRcx1
    movq %rsi, tempRsi1

    movq $0, %rax               # no vector arguments needed
    subq $16, %rsp              # reserving space for the input
    leaq -16(%rbp), %rsi        # loading address of stack variable in rsi
    movq $inputVar, %rdi        # loading first argument of scanf
    call scanf
    

    movq tempRax1, %rax
    movq tempRdi1, %rdi
    movq tempRcx1, %rcx
    movq tempRsi1, %rsi
    
    
    movq -16(%rbp), %r8
    movq %r8, (%rsi)
    
#epilogue
    movq %rbp, %rsp
    popq %rbp
    ret
    
nextMem: 
    
    addq $8, %rsi               # getting the next mem cell address
    
    incq %rax
    jmp currentInstruction

prevMem: 
    
    subq $8, %rsi               # getting the prev mem cell address
    
    incq %rax
    jmp currentInstruction
    
incVal:

    incq (%rsi)               # incrementing value at pointer
    
    incq %rax
    jmp currentInstruction
    
decVal:

    decq (%rsi)               # decrementing value at pointer
    
    incq %rax
    jmp currentInstruction


beginLoop:

    
    jmp bracketCompl          # calculating the difference between current and compliment bracket
    
    returnInBeginLoop:
    
    movq (%rsi), %r12

    cmpq $0, (%rsi)          # comparing the current value in mem cell with 0
    jne finish
    
    popq %r8
    addq %r8, %rax
        
    finish:
    
    incq %rax
    jmp currentInstruction
    
    

bracketCompl:

    movq %rax, tempRax
    movq $1, auxCounter

        loop:
    
        incq %rax
    
        movb (%rdi,%rax,1), %cl       # fetching the next character/instruction (ascii char eight bits)
    
        cmpb $91, %cl                 # checking if the character is [
        je incCounter
    
    
        cmpb $93, %cl                 # checking if the character is ]
        je initialCheck
    
        jmp loop
    
        initialCheck:                   # checking if the ] is the correct compliment
    
            decq auxCounter
    
            cmpq $0, auxCounter
            je match
        
            jmp loop
        
        match:                      # execute only if the ] is the correct compliment of the initial [
        
            movq %rax, %r8
            subq tempRax, %r8
            
            
            movq (%rsp), %r9        # getting the most recent value from the stack
            cmpq %r9, %r8           # comparing differences
            je dontDoAnything
            
            pushq %r8                   # push the difference in the stack
                
            dontDoAnything:
            movq tempRax, %rax
            jmp returnInBeginLoop
    
    
    incCounter:
    
    incq auxCounter
    jmp loop        
    
    
endLoop:

    movq (%rsp), %r9
    subq %r9, %rax
    
    jmp currentInstruction
    
stopParse:

#epilogue
    movq %rbp, %rsp
    popq %rbp
    #ret
    call exit
