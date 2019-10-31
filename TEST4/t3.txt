datasg	segment	para	'data'
	cr	equ	13
	lf	equ	10
	eom	equ	'$'
	
	out_of_range	db	'error code is not in valid range (1-83)'
			db	cr,lf,eom
	reserved	db	'error code is reserved(36-79)',cr,lf,eom

	er1	db	'invalid function number',cr,lf,eom
	er2	db	'file not found',cr,lf,eom
	er3	db	'path not found',cr,lf,eom
	er4	db	'too many open files',cr,lf,eom
	er5	db	'access denied',cr,lf,eom
	er6	db	'invalid handle',cr,lf,eom
	er7	db	'memory control blocks destroyed',cr,lf,eom
	er8	db	'insufficient memory',cr,lf,eom
	er9	db	'invalid memory block address',cr,lf,eom
	er10	db	'invalid enviroment',cr,lf,eom
	er11	db	'invalid format',cr,lf,eom
	er12	db	'invalid access code',cr,lf,eom
	er13	db	'invalid data',cr,lf,eom
	er14	db	'no such message',cr,lf,eom
	er15	db	'invalid drive was specified',cr,lf,eom
	er16	db	'attempted to remove the current directory',cr,lf,eom
	er17	db	'not same device',cr,lf,eom
	er18	db	'no more files',cr,lf,eom
	er19	db	'disk is write_protected',cr,lf,eom
	er20	db	'unknow unit',cr,lf,eom
	er21	db	'drive not ready',cr,lf,eom
	er22	db	'unknown command',cr,lf,eom
	er23	db	'data error(crc)',cr,lf,eom
	er24	db	'bad request structure',cr,lf,eom
	er25	db	'seek error',cr,lf,eom
	er26	db	'unknown media type',cr,lf,eom
	er27	db	'sector not found',cr,lf,eom
	er28	db	'printer out of range',cr,lf,eom
	er29	db	'write fault',cr,lf,eom
	er30	db	'read fault',cr,lf,eom
	er31	db	'general failure',cr,lf,eom
	er32	db	'sharing violation',cr,lf,eom
	er33	db	'lock violation',cr,lf,eom
	er34	db	'invalid disk change',cr,lf,eom
	er35	db	'fcb unavailabe',cr,lf,eom
	er80	db	'file exists',cr,lf,eom
	er81	db	'reserved',cr,lf,eom
	er82	db	'cannot make',cr,lf,eom
	er83	db	'fail on int 24',cr,lf,eom

	ertab1	dw	er1,er2,er3,er4,er5,er6,er7,er8,er9,er10,er11,er12,er13,er14,er15,er16,er17,er18,er19,er20,er21,er22,er23,er24,er25,er26,er27,er28,er29,er30,er31,er32,er33,er34,er35

	ertab2	dw	er80,er81,er82,er83
datasg	ends

codesg	segment	para	'code'
	assume	cs:codesg,ds:datasg

show_err	proc far
	push	ds
	sub	bx,bx
	push	bx

	mov	si,datasg
	mov	ds,si
	
	push	ax
	cmp	ax,83;大于83，不在范围内
	jg	o_o_r
	cmp	ax,0;看是否大于0，小于0则不在范围内
	jg	in_range

o_o_r:
	lea	dx,out_of_range;输出不在范围内的错误信息
	jmp	short disp_msg

in_range:
	cmp	ax,35;在1-35的错误信息
	jg	try79
	lea	bx,ertab1
	dec	ax
	jmp	form_addr;需要定位位置

try79:
	cmp	ax,79;36-79的错误信息，
	jg	last_4
	lea	dx,reserved;不需要定位位置，直接输出
	jmp	disp_msg

last_4:
	lea	bx,ertab2;80-83的错误信息，在最后4个，需要定位位置
	and	ax,3

form_addr:
	shl	ax,1
	add	bx,ax
	mov	dx,[bx]

disp_msg:
	mov	ah,9
	int	21h
	pop	ax
	ret
show_err endp
codesg	ends
	end	show_err