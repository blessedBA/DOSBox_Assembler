.model tiny
x   = 30d
l_s = 80d*2h ; length of terminal string
l_b = 40d	; length of horizontal border
.code
org 100h

VIDEOSEG        equ 0B800h


start:	        mov ax, VIDEOSEG
                mov es, ax
		
	 
                mov si, 5h  ; 5h = number strings to skip
                mov cx, l_b ; length of the border
		mov di, 5d  ; number border's strings

		call calcCoord
		call prHorBorder	 		

pr_ver_b:
		cmp di, 00d
		je  end_pr_b
		dec di
		inc si
		call calcCoord
		jmp one_ver_b

one_ver_b:	
		cmp cx, l_b
		je pr_one_ver_b
		cmp di, 2
		je sec_cond
back3:
		add bx, 2h
		loop one_ver_b

		mov cx, l_b
		mov es: byte ptr[bx], 0bah	; print "||"	
		jmp pr_ver_b

pr_one_ver_b:
		mov es: byte ptr[bx], 0bah
		dec cx 
		jmp one_ver_b

sec_cond:
		cmp cx, 18h ; from which value start print terminal string 
		je pr_str_l
		jmp back3		
pr_str_l:
		call print_string
		jmp one_ver_b


end_pr_b:

		inc si
		call calcCoord
		mov cx, l_b		

		call prHorBorder

                mov ax, 4c00h
                int 21h

;------------------------------------------------------------------------
; Calculate Coordinates of videomemory in registrs BX and SI
; Expect: BX, SI
; Exit:   BX - calculated index
; Destr:  AX
;-------------------------------------------------------------------------
calcCoord	proc
		mov ax, l_s
		mul si
		mov bx, ax
		add bx, x

		ret
		endp

;---------------------------------------------------------------------------
;Print: terminal string (length = ds:[80h]) begin from [si = 82h]
;Entry: no
;Exit:  no
;Destr: cx++, bx += 2, al
;---------------------------------------------------------------------------
print_string	proc

		push cx
		push si
		push bx
		xor cx, cx
		mov cl, ds:[80h]
		dec cl ; dont need last symbol = '<enter>'
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


;-------------------------------------------------------------------------
; Print horizontal border length <cx> to videomemory [bx]
; Expect: CX - length of border
;	  BX - adress from which border was writted
; Exit:   nothing
; Destr:  BX
;--------------------------------------------------------------------------

prHorBorder	proc
		push cx
hor_border:
		cmp di, 5d
		je up_corn
		cmp di, 0h
		je bot_corn
next:
		jmp next2

up_corn: 
		cmp cx, l_b
		je l_u_corn
		cmp cx, 1d
		je r_u_corn

		jmp next2
l_u_corn:
		mov es:byte ptr[bx], 0c9h ; print left up corner
		jmp next3
r_u_corn:
		mov es:byte ptr[bx], 0bbh ; print right bottom corner
		jmp next3

bot_corn:
		cmp cx, l_b
		je l_b_corn
		cmp cx, 1d
		je r_b_corn

		jmp next2
l_b_corn:
		mov es:byte ptr[bx], 0c8h ; print left up corner
		jmp next3
r_b_corn:
		mov es:byte ptr[bx], 0bch ; print left bottom corner
		jmp next3

next2:
		mov es:byte ptr[bx], 0cdh ; print '='
next3:
		add bx, 2h
		loop hor_border
		pop cx

		ret
		endp

end             start