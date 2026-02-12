.model tiny
x = 30d
y = 80d*2h

.code
org 100h

VIDEOSEG        equ 0B800h
LENGTH_WINDOW   equ 80d*2h
N_STR		equ 5h
start:	        mov ax, VIDEOSEG
                mov es, ax
	 
                mov ah, 4eh ; set color
                mov cx, 40d ; lenght of the border
                mov bx, y + x

hor_border:
                mov es: byte ptr[bx], 0cdh ; print '='
                inc bx
	        inc bx
                loop hor_border
			
		
		

                mov ax, 4c00h
                int 21h

end             start