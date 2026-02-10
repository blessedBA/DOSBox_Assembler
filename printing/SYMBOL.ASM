.model  tiny
.code
org 100h

VIDEOSEG 		equ 0b800h ; assembler define

start: 			mov ax, VIDEOSEG
			mov es, ax
			
			mov al,ds:[80h] ; length of terminal string
			mov ah, 4eh ; yellow color (better to do constant = 4eh)
			
			xor bx, bx
			mov es:[bx], ax ; word ptr dont need becs all defined
			
			mov ax, 4c00h
			int 21h


end start			