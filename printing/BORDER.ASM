.model tiny
x   = 30d
l_w = 80d*2h ; length of terminal string

.code
org 100h

VIDEOSEG        equ 0B800h

start:	        mov ax, VIDEOSEG
                mov es, ax
		
	 
                mov si, 5h  ; number of current string
                mov cx, 40d ; lenght of the border
		mov ax, si
		mov bx, l_w
		mul bx
		mov bx, ax
		add bx, x

hor_border:
                mov es:byte ptr[bx], 0cdh ; print '='
            	add bx, 2h
                loop hor_border
			 
		mov cx, 40d ; length of hor_border		
		mov di, 5d

pr_ver_b:
		cmp di, 00d
		je  end_pr_b
		dec di
		inc si
		mov ax, si
		mov bx, l_w
		mul bx
		mov bx, ax
	  	add bx, x
		jmp one_ver_b

one_ver_b:	
		cmp cx, 40d
		je pr_one_ver_b
		cmp di, 2
		je sec_cond
back3:
		add bx, 2h
		loop one_ver_b

		mov cx, 40d
		mov es: byte ptr[bx], 0bah		
		jmp pr_ver_b

pr_one_ver_b:
		mov es: byte ptr[bx], 0bah
		dec cx 
		jmp one_ver_b

sec_cond:
		cmp cx, 20h
		je pr_str_l
		jmp back3		
pr_str_l:
		call print_string
		jmp one_ver_b

;---------------------------------------------------------------------------





;---------------------------------------------------------------------------

print_string	proc

		push cx
		push si
		push bx
		xor cx, cx
		mov cl, ds:[80h]
		mov si, 82h
hor_str:
		mov al, [si]
		mov es:[bx], al
		add bx, 2h
		inc si
		loop hor_str
		pop bx
		pop si
		pop cx
		dec cx
		add bx, 2h		

		ret
		endp
 



end_pr_b:

		inc si
		mov ax, l_w
		mul si
		mov bx, ax
		add bx, x
		mov cx, 40d		
hor_border_2:
		mov es:byte ptr[bx], 0cdh ; print '='
		add bx, 2h
		loop hor_border_2

                mov ax, 4c00h
                int 21h

end             start