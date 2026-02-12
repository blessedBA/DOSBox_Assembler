.model  tiny
.code
org 100h

VIDEOSEG 		equ 0b800h ; assembler define

start: 			mov ax, VIDEOSEG
			mov es, ax
			
		;	mov al, 0eh ; print symbol "nota"
			mov ah, 4dh ; yellow color (better to do constant = 4eh)
		
			mov di, 82h	
			mov bx, 80d*5h ; coordinates of the centre of 5th string	
			mov cl, ds:[80h]
			dec cl
cycle:
			mov al, [di]			
			mov es:[bx], ax ; word ptr dont need becs all defined
			add bx, 2h 	; bx++
			add di, 1h
			loop cycle	

			mov ax, 4c00h
			int 21h


end start			