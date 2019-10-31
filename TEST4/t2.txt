datasg	segment	para	'data'
	three	db	3
	mess	db	'month?',13,10,'$'

	monin	label	byte
	max	db	3
	act	db	?
	mon	db	3 dup(?)
	
	alfmon	db	'???',13,10,'$'
	montab	db	'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'
datasg	ends

codesg	segment	para	'code'
	assume cs:codesg,ds:datasg,es:datasg
main	proc	far
	push	ds
	sub	ax,ax
	push	ax
	
	mov 	ax,datasg
	mov	ds,ax
	mov	es,ax

start:
	lea	dx,mess
	mov	ah,09
	int	21h

	lea	dx,monin
	mov	ah,0ah
	int	21h
	mov	dl,13
	mov	ah,02
	int	21h
	mov	dl,10
	mov	ah,02;;;;;;;;;;;;;
	int	21h
	cmp	act,0
	je	exit

	mov	ah,30h
	cmp	act,2
	je	two
	mov	al,mon	;个位数
	jmp	conv
two:			;两位数
	mov	al,mon+1
	mov	ah,mon
conv:
	xor	ax,3030h
	cmp	ah,0;如果他是个位数的月份
	jz	loc
	sub	ah,ah;两位数的月份，转换一下
	add	al,10

loc:
	lea	si,montab
	dec	al
	mul	three；因为每个下标对应三个字符
	add	si,ax;定位到要输出的字符串

	mov	cx,03;存好那三个字符
	cld
	lea	di,alfmon
	rep	movsb
	
	lea	dx,alfmon
	mov	ah,09
	int	21h
	jmp	start

exit:
	ret
main	endp
codesg	ends
	end	main
