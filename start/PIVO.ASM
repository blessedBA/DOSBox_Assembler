.model tiny
.code
org 100h

start:			mov ah, 09h
			mov dx, offset QelloStr
			int 21h
			mov ax, 4c00h
			int 21h		
QelloStr 		db 'FEED POLTORASHKA NOW!!!', 0dh, 0ah, '$'


end 			start