.model tiny
.code
org 100h

VIDEOSEG	equ 0b800h

start:		dd 90909090h

		push VIDEOSEG
		pop es

		mov ah, 57h ; set color of symbol

		xor dx, dx
		mov cx, 50
next:
		in al, 60h ; read from 60th port (keyboard)
		
		xor bx, bx
		mov bl, al
		
		mov di, cx	

		mov es:[bx+80d*10+di], ax ; print on screen in random place
		dec cx
		cmp al, 1h
		jne next
		
		mov ax, 4c00h
		int 21h

end		start