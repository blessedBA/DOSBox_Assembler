.model tiny
.code
org 100h
			; very a lot of funcs for demonstrating
			; in real cases dont need so much funcs
start:		call main	; 	
		call exit ; just for example, better mov ax 4c00h and int 21h	

; --------------------------------------------------------------------------

Main 		proc
	
		lea di, meowstr ; = mov di, offset meowstr
		mov al, '$'
		call str_mem_chr ; so name bcs its a hybrid of strchr and memchr (funcs of C)	

		; ...cx...  (doing something with cx - returned value)

		ret
		endp

;-------------------------------------------------------------------------------
; Searches ES:DI for symbol in AL (no more than 0FFFFh times)
; Entry: ES:DI --> string to search in 
;  	 AL	=  Symbol to search
; Exit:  CX	=  Symbol position
; Exp:   DF	=  0  (or in destroy list we remined about rewrited flag)
;!Destr: DI	      (df = 0 - direction flag)

;------------------------------------------------------------------------------

str_mem_chr	proc

		xor cx, cx ; better than just  "mov cx, ffff " (faster)
		dec cx

		cld	

		repne scasb

		; cx = ffff - len  =>   len = (ffff = -1) - cx

		neg cx  ;  ???
		inc cx 	;  ???

		ret
		endp

exit		proc

		mov ax, 4c00h
		int 21h
		
		endp

meowstr		db "pivo pivo lodochka", 0dh, 0ah, '$'

end 		start



 