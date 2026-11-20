.data 
input_n: .word 3
output: .word 0
.text

.global main

#0, 1, 1, 2, 3, 5
main:
#input value stored in register called input = $v0
#output value to print stored in register output = $at
lw $a0, input_n #this line takes value n stored in memory and sets it as our function input
jal Fibonacci
move $a0, $v0
jal isOdd
move $a0, $v0
jal Fibonacci_is_odd
li $v0, 10 #ends the program after last function call
syscall

#$a0 is the arguments going into the functions
#$v0 is the return from the functions

Fibonacci:
li $t1, 0 #t1 = 0 a
li $v1, 1 #v1 = 1 b
#li $v0, 5 #v0 = 5

#get_integer: #FOR testing with different input values
#li $v0, 5 #this creates a call to the user to input a value to be used in the function to determine the fib number to produce
#syscall
#move $t4, $v0
move $t4, $a0
beq $t4, 0, print_zero

beq $t4, 1, print_one



keep_adding:
#say input is 5 so $v0 = 5
move $t0, $v1#, 0 #$t0 = $v1 :1, 1, 2
move $t2, $t0#, 0 #:1, 2, 
#move $a0, $at#, 0 #:1, 2, 
sub $t4, $t4, 1 #: 4, 3, 
add $v1, $t1, $v1 #: 1, 2, 
move $t1, $t0#, 0 #: 1, 1, 
bne $t4, 0, keep_adding
beq $t4, 0, print

print: #print the value in at
#add $t0, $t0, $t1
move $a0, $t0
li $v0, 1 #so in asm convention you have to set $v0 back to 1 to print out $a0
syscall 
li $v0, 0
beq $v0, 0, end

print_zero: #print the value in at
li $a0, 0
li $v0, 1 #so in asm convention you have to set $v0 back to 1 to print out $a0
syscall 
li $v0, 0
beq $v0, 0, end

print_one: #print the value in at
li $a0, 1
li $v0, 1 #so in asm convention you have to set $v0 back to 1 to print out $a0
syscall 
beq $v0, 1, end

end:
move $v0, $a0 #registers a0 and t2 both have the end fib result, we want to move that to register v0 because that is the input into the next function
jr $ra



isOdd: ############################################# Function seperator
li $s0, 0 #for move operations
li $s1, 1
move $t6, $a0 #storing the function input into a temp variable

bgt $t6, 1, subtract
beq $t6, 1, odd
beq $t6, 0, not_odd

subtract:
sub $t6, $t6, 2
bgt $t6, 1, subtract
beq $t6, 1, odd
beq $t6, 0, not_odd

odd:
move $v0, $s1 #I am choosing to return 1 if it is odd and 0 if it is not odd
li $a0, 1
li $v0, 1 #so in asm convention you have to set $v0 back to 1 to print out $a0
syscall 
beq $v0, 1, func_end

not_odd:
move $v0, $s0
li $a0, 0
li $v0, 1 #so in asm convention you have to set $v0 back to 1 to print out $a0
syscall 
move $v0, $s0
beq $v0, 0, func_end

func_end:
jr $ra


Fibonacci_is_odd: ############################################# Function seperator

li $s0, 0 #for move operations
li $s1, 1

Fio_end:
beq $a0, 1, input_odd
beq $a0, 0, input_not_odd

input_not_odd:
move $v0, $s1 
li $a0, 0
li $v0, 1 
syscall
li $v0, 0
beq $a0, 0, very_end


input_odd:
move $v0, $s1 
li $a0, 1
li $v0, 1 
syscall
beq $a0, 1, very_end

very_end:
sw $v0, output #output of the final function stored in memory
jr $ra
