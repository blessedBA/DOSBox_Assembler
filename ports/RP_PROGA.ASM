.model tiny
.code
org 100h

VIDEOSEG 	equ 0b800h

start:		dd 90909090h

		call save_old

		call rewrite_IVT
		
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
rewrite_IVT	proc

		cli
		xor ax, ax
		mov es, ax
		mov bx, 09h * 4
		mov es:[bx], offset process_hotkey
		mov ax, cs
		mov es:[bx + 2], ax
		sti
		
		ret

rewrite_IVT	endp

;------------------------------------------------------------
; Detects hotkey ctrl + O and print in left corner a symbol
; Expect: none
; Exit:	  none
; Destr:  none (RESIDENT PROGRAMM)
;--------------------------------------------------------------
process_hotkey	proc

		push ax bx cx di es

		mov bx, VIDEOSEG
		mov es, bx
		xor bx, bx
	
		in al, 60h
		cmp al, 24d
		jne next
		
		mov ah, 02h
		int 16h
		and al, 04h
		test al, 04h
		jne next

		mov es:[bx], 4f41h

next:		
		pop es di cx bx ax
		
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
save_old	proc

		mov ax, 3509h
		int 21h
		mov old09adr, bx
		mov bx, es
		mov old09seg, bx				

		ret

save_old 	endp


ENDPR:
end 		start






		

		



		


