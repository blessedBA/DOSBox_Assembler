.model tiny
.code
org 100h
start:		dd 90909090h	
	        mov ax, 3509h
	        int 21h
	        mov Old090fs, bx
	        mov bx, es
          	mov Old09Seg, bx

		mov ax, 0 ; table of interuptrs
		mov es, ax


		cli
		mov bx, 09h * 4
		mov es:[bx], offset oldnew09 ; write adress of new our function
		mov ax, cs
		mov es:[bx+2], ax ; [bx
		sti


		mov ax, 3100h
		mov dx, offset endofprogramm  ; in paragraphes (one = 16 bytes)
		shr dx, 4  ; div by 16 because of paragraphes
		inc dx     ; prozapas					
		int 21h

oldnew09	proc
		push ax bx es ; remember

		mov ax, 0b800h
		mov es, ax

		mov bx, (5*80d + 40d) * 2
		mov ah, 4eh

		in al, 60h
		mov es:[bx], ax
		in al, 61h
		or al, 80h ; set old bit to 1
		out 61h, al
		and al, not 80h ; not 80h = 7fh
		out 61h, al
		mov al, 20h
		out 20h, al

		pop es bx ax ; reversed

	        db 0eah         ; jmp far

Old090fs dw 0
Old09Seg dw 0

		endp

endofprogramm:		; to calculate size of our programm





end		start
