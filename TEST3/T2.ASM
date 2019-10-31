datasg  segment  
  string1   db  'Enter keyword:$'
  string2   db  'Enter sentence:$'
  huiche db  13,10,'$'

  mess1   db  	'Match at location:',?,?,' H of the sentence',13,10,'$'
  mess2   db	'No match.',13,10,'$'  

keyword     label   byte
    maxk     db      10
    actk     db      ?           
    keyd     db      10 dup(?)    
sentence     label   byte
    maxs     db      50
    acts     db      ?           
    sente    db      50 dup(?)   
datasg  ends


codesg  segment
        assume  cs:codesg,ds:datasg,es:datasg

main    proc    far
        push    ds
        sub     ax,ax
        push    ax
        
        mov     ax,datasg
        mov     ds,ax
        mov     es,ax

start:
        lea     dx,string1 ;提示输入keyword
        mov     ah,09
        int     21h

        lea     dx,keyword 
        mov     ah,0ah  
        int     21h
        cmp     actk,0
        je      exitt
 
        lea     dx,huiche ;换行
        mov     ah,09
        int     21h
 
        lea     dx,string2 ;提示输入sentence
        mov     ah,09
        int     21h

        lea     dx,sentence
        mov     ah,0ah  
        int     21h
        cmp     acts,0
        je      exitt
	jmp	normal	;正常执行

exitt:
	jmp	exit

normal:
        lea     dx,huiche ;换行
        mov     ah,09
        int     21h
  
        lea     si,keyd
        lea     bx,sente
        mov     di,bx
	;lea	di,sente
        cld
        mov     ch,0
        mov     cl,acts  ;句子长度，一个字节
        sub     cl,actk
        inc     cx ;比较次数
 
compare:
        push    cx	;之后的cmpsb还会用到cx，所以保存现在的cx
        push    di	;保存现在搜索到的字符串的首地址，之后用来+1

        mov     cl,actk ;关键字长度，一个字节
        repz    cmpsb	;如果相等继续比较（ZF=1）;repz遇到不相等（零标志ZF=0）/cx=0时停止比较
        jz      find	;为0则跳转（零标志=1），即repz是因为搜索完毕cx=0结束的，而不是因为zf=1结束的
        pop     di
        pop     cx
        inc     di	;字符串搜索起始位置+1
        lea     si,keyd	;关键字返回到开头
        loop    compare
 
        lea     dx,mess2 ;不匹配
        mov     ah,09
        int     21h
       ;jmp     exit
 	jmp	start

find:   
        pop     di
        pop     cx
        sub     di,bx
        mov     bx,di
        inc     bx ;得到十进制的位置
 
        mov     ax,bx
        mov     bh,16
        div     bh
	
	cmp	al,10
	jnl	jiaal
        add     al,48
	jmp	judgeah
jiaal:
	add	al,55

judgeah:
	cmp	ah,10
	jnl	jiaah	;>=10
        add     ah,48	;ah<10
	jmp	normala
jiaah:
	add	ah,55

normala:
        mov     [mess1+18],al;商
        mov     [mess1+19],ah;余数

 
        lea     dx,mess1 ;输出
        mov     ah,09
        int     21h
        jmp     start
 
 
exit:			;返回dos
   	mov	ah,4ch
	int	21h

main    endp
codesg  ends            ;end of segment
        end     main    ;end assembly
 
 
 