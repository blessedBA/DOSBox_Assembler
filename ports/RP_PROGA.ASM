.model tiny
.code
org 100h

VIDEOSEG 	equ 0b800h

start:		dd 90909090h

		call save_old_09
		call save_old_1c

		call add_newint09
		
		mov ax, 3100h
		mov bx, offset ENDPR
		shr bx, 4
		inc bx
		mov dx, bx
		int 21h


;----------------------------------------------------------------
; Write in IVT (Interactive Vector Table) adress of new IV 
; Exect: none
; Exit:  none
; Destr: AX, BX, ES
;------------------------------------------------------------------`
add_newint09	proc

		cli
		xor ax, ax
		mov es, ax
		mov bx, 09h * 4
		mov es:[bx], offset process_hotkey
		mov ax, cs
		mov es:[bx + 2], ax
		sti
		
		ret

add_newint09	endp

;------------------------------------------------------------
; Detects hotkey ctrl + O and print in left corner a symbol
; Expect: none
; Exit:	  none
; Destr:  none (RESIDENT PROGRAMM)
;--------------------------------------------------------------
process_hotkey	proc

		push bx cx di es ax

		mov bx, VIDEOSEG
		mov es, bx
		xor bx, bx
	
		in al, 60h
		cmp al, 24d
		jne next1
		
		mov ah, 02h
		int 16h
		;and al, 04h
		test al, 04h
		jz next1

		mov es:[bx], 4f41h
	
		call add_newint1c
		;pop ax
		;mov di, 80d * 2h + 40d
		;mov bl, 'A'
		;call print_register
		;push ax

next1:		
		pop ax es di cx bx
		
		db 0eah
old09adr dw 0
old09seg dw 0		

process_hotkey endp			

;---------------------------------------------------------------------
; Save adress of old Interrupt Vector (offset in ES, segment in BX)
; Expect: none
; Exit:   ES - segment of old IV; BX - offset of old IV
; Destr:  AX, ES, BX
;---------------------------------------------------------------------
save_old_09	proc

		mov ax, 3509h
		int 21h
		mov old09adr, bx
		mov bx, es
		mov old09seg, bx				

		ret

save_old_09 	endp


;-------------------------------------------------------------------
; Save adress of old IV 1c (timer)
;------------------------------------------------------------------
save_old_1c	proc

		push ax bx es

		mov ax, 351ch
		int 21h
		mov old1cadr, bx
		mov bx, es
		mov old1cseg, bx

		pop es bx ax

		ret

save_old_1c 	endp

;---------------------------------------------------------------------
; Print number ; Expect: AX - value to print, DI - coordinate where to print, BL - ASCII code of register you need to print; BH - color
; Exit: printed on screen value of register
; Destr: none
;--------------------------------------------------------------------
print_register 	proc
    		push es
    		push ax
    		push cx
    		push dx
		push di

    		mov dx, ax         
    		mov ax, VIDEOSEG
    		mov es, ax
    		mov cx, 4

		
		mov es:[di], bx
		add di, 2h
		mov byte ptr es:[di], 'X'
		mov byte ptr es:[di + 1], bh
		add di, 2h
		mov bl, '='
		mov byte ptr es:[di], bh
		mov es:[di], bx

next2:
    		mov al, dh
    		shr al, 4           

    		cmp al, 0Ah
    		jb digit

    		add al, 'A' - 10
    		jmp store

digit:		; if number < Ah
    		add al, '0'

store:
		mov ah, 07h  ; set color of printed symbol
    		mov word ptr es:[di], ax
    		add di, 2
    		shl dx, 4
    		loop next2
		
		
		pop di
    		pop dx
    		pop cx
    		pop ax
    		pop es
    		
		ret

print_register 	endp

;----------------------------------------------------------------
; Add our int 1c to IVT
; Expect: none
; Exit:	  none
; Destr:  none
;----------------------------------------------------------------
add_newint1c	proc

		push ax bx es

		;cli
		xor ax, ax
		mov es, ax
		mov bx, 1ch * 4h
		mov es:[bx], offset cnt_to_timer
		mov ax, cs
		mov es:[bx + 2], ax
		;sti

		pop es bx ax

		ret

add_newint1c	endp

;------------------------------------------------------------
; IV for printing register every tick of timer
; Expect: none
; Exit:   none
; Destr:  none    (RESIDENT PROGRAMM)
;------------------------------------------------------------
cnt_to_timer	proc

		push di bx

		mov di, 80d * 2h
		mov bh, 4eh
		mov bl, 'A'
		call print_register

		pop bx di

		db 0eah
old1cadr dw 0
old1cseg dw 0

cnt_to_timer 	endp

ENDPR:
end 		start






		

		



		


