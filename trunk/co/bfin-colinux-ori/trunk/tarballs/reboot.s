# a simple reboot program ... doesn't get much simpler than this ;)
.globl _start
.type  _start, @function
_start:
	movl $88, %eax
	movl $-18751827,%ebx
	movl $672274793, %ecx
	movl $1126301404, %edx
	int $0x80
.size _start,.-_start
