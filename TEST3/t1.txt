prognam	segment
main	proc	far
	assume	cs:prognam

start:
	mov	ah,02h
	mov	dl,10h
	mov	bl,15	;15行

nextline:
	mov	cx,16	;16列

outputoneline:			;---------输出1行16个
	int	21h	;显示字符

	push	dx	;------保存字符
	;显示空白
	mov	al,02h
	mov	dl,0
	int	21h
	pop	dx	;------取出字符

	inc	dx	;+1得到下一个ASCII码
	loop	outputoneline	;--------输出一行16个

	push	dx	;------保存字符
	;显示换行
	mov	ah,02h	;输出换行
	mov	dl,10
	int	21h
	pop	dx	;------取出字符

	dec	bl
	cmp	bl,0
	jne	nextline	;bx!=0没有输出完15行，循环回去继续输出
	
	;返回doc
	mov	ah,4ch
	int	21h


main	endp
prognam	ends
	end	start
