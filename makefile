
t2: test2.d
	dmd $< -of$@
	# objdump -Mintel -drwC ./$@ > $@.asm
	./$@


ldct2: ldctest.d
	ldc2 -mattr=+mmx,sse,sse2,see3 $< -of$@
	# objdump -Mintel -drwC ./$@ > $@.asm
	./$@


d1: test6.d
	dmd $< -of$@ -mcpu=avx -mcpu=avx2
	./$@
