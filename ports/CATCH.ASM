.model tiny
.code
org 100h

VIDEOSEG	equ 0b800h

start: 		dd 90909090h
;		1) saving adress of old interrupt vector

		mov ax, 3509h
		int 21h
		mov old09adr, bx
		mov bx, es
		mov old09seg, bx

;		2) set in IVT our new interrupt vector

		cli
		xor ax, ax
		mov es, ax
		mov bx, 09h * 4
		mov es:[bx], offset new09
		mov ax, cs
		mov es:[bx + 2], ax
		sti

;		3) set terminate and stay resident our programm
		
		mov ax, 3100h
		mov bx, offset ENDPR
		shr bx, 4
		inc bx
		mov dx, bx
		int 21h

; 		4) do our new interrupt vector

;-------------------------------------------------------------
; Read from 60h port (keyboard input) and print of screen,
; then transfer control to system interrupt vector
; Expect: none
; Exit:   none
; Destr:  none
;-------------------------------------------------------------
new09		proc

		push ax bx cx di es

		mov bx, VIDEOSEG
		mov es, bx
		mov bx, 80h * 2 * 5d + 40d

		in al, 60h
		mov ah, al
		xor di, di
		xor cx, cx
		mov cl, al
		mov di, cx
		mov es:[bx+di], ax
		
;		5) blink with old bit

	;	in al, 61h
	;	or al, 80h
	;	out 61h, al
	;	and al, not 80h
	;	out 61h, al

;		6) send signal to master-PIC

	;	mov al, 20h
	;	out 20h, al
	
		pop es di cx bx ax		

;		7) transfer control to old interruptr vector
		
		db 0eah  ; ea = jmp far
old09adr dw 0
old09seg dw 0

		endp
ENDPR:

end		start















 