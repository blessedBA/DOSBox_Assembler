.model  tiny
.code
org 100h

VIDEOSEG 		equ 0b800h ; assembler define

start: 			mov ax, VIDEOSEG
			mov es, ax
			
			mov al, 0eh ; print symbol "nota"
			mov ah, 4dh ; yellow color (better to do constant = 4eh)
			
			mov bx, 80d*5h ; coordinates of the centre of 5th string
			mov es:[bx], ax ; word ptr dont need becs all defined
			
			mov ax, 4c00h
			int 21h


end start			