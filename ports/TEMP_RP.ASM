.model tiny
.code
org 100h

VIDEOSEG equ 0B800h
BDASEG   equ 040h


start:
        call save_old_09
        call save_old_08

        call add_newint09
        call add_newint08

        mov ax, 3100h
        mov dx, offset ENDPR
        add dx, 15
        mov cl, 4
        shr dx, cl
        int 21h

;------------------------------------------------------------
; install int 09h
;------------------------------------------------------------
add_newint09 proc
        cli
        xor ax, ax
        mov es, ax
        mov bx, 09h * 4
        mov word ptr es:[bx], offset process_hotkey
        mov ax, cs
        mov word ptr es:[bx + 2], ax
        sti
        ret
add_newint09 endp

;------------------------------------------------------------
; install int 08h (real timer tick)
;------------------------------------------------------------
add_newint08 proc
        cli
        xor ax, ax
        mov es, ax
        mov bx, 08h * 4
        mov word ptr es:[bx], offset timer_tick
        mov ax, cs
        mov word ptr es:[bx + 2], ax
        sti
        ret
add_newint08 endp

;------------------------------------------------------------
; save old int 09h
;------------------------------------------------------------
save_old_09 proc
        mov ax, 3509h
        int 21h
        mov old09adr, bx
        mov old09seg, es
        ret
save_old_09 endp

;------------------------------------------------------------
; save old int 08h
;------------------------------------------------------------
save_old_08 proc
        mov ax, 3508h
        int 21h
        mov old08adr, bx
        mov old08seg, es
        ret
save_old_08 endp

;------------------------------------------------------------
; erase AX window
;------------------------------------------------------------
erase_window proc
        push ax
        push cx
        push di
        push es

        mov ax, VIDEOSEG
        mov es, ax
        xor di, di
        mov ax, 0720h
        mov cx, 7

erase_loop:
        mov word ptr es:[di], ax
        add di, 2
        loop erase_loop

        pop es
        pop di
        pop cx
        pop ax
        ret
erase_window endp

;------------------------------------------------------------
; print AX=xxxx at ES:DI position
; input: AX=value, DI=offset, BL='A', BH=attribute
;------------------------------------------------------------
print_register proc
        push ax
        push bx
        push cx
        push dx
        push di
        push es

        mov dx, ax
        mov ax, VIDEOSEG
        mov es, ax

        mov al, bl
        mov ah, bh
        mov word ptr es:[di], ax
        add di, 2

        mov al, 'X'
        mov ah, bh
        mov word ptr es:[di], ax
        add di, 2

        mov al, '='
        mov ah, bh
        mov word ptr es:[di], ax
        add di, 2

        mov cx, 4

print_hex_loop:
        mov al, dh
        shr al, 4
        cmp al, 0Ah
        jb  short print_digit
        add al, 'A' - 10
        jmp short print_store

print_digit:
        add al, '0'

print_store:
        mov ah, bh
        mov word ptr es:[di], ax
        add di, 2
        shl dx, 4
        loop print_hex_loop

        pop es
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret
print_register endp

;------------------------------------------------------------
; keyboard IRQ: Ctrl+O toggles window on/off
; one press -> show/hide once
; O break clears debounce flag
; hotkey is swallowed, other keys go to old BIOS handler
;------------------------------------------------------------
process_hotkey proc
        push ax
        push bx
        push ds

        push cs
        pop ds
        mov last_ax, ax

        in  al, 60h

        cmp al, 098h              ; O break
        je  short hotkey_break

        cmp al, 018h              ; O make
        jne short hotkey_chain

        mov bx, BDASEG
        mov ds, bx
        mov al, byte ptr ds:[0017h]   ; keyboard flags
        test al, 04h                  ; Ctrl pressed?
        jz   short hotkey_chain

        push cs
        pop ds
        cmp byte ptr [o_down], 0
        jne short hotkey_swallow      ; autorepeat: ignore

        mov byte ptr [o_down], 1
        mov al, byte ptr [window_on]
        xor al, 1
        mov byte ptr [window_on], al
        cmp al, 0
        je  short hotkey_hide

        mov ax, word ptr [last_ax]
        xor di, di
        mov bh, 4Eh
        mov bl, 'A'
        call print_register
        mov byte ptr [was_drawn], 1
        jmp short hotkey_swallow

hotkey_hide:
        call erase_window
        mov byte ptr [was_drawn], 0
        jmp short hotkey_swallow

hotkey_break:
        push cs
        pop ds
        mov byte ptr [o_down], 0
        jmp short hotkey_swallow

hotkey_swallow:
        in  al, 61h
        mov ah, al
        or  al, 80h
        out 61h, al
        mov al, ah
        out 61h, al
        mov al, 20h
        out 20h, al

        pop ds
        pop bx
        pop ax
        iret

hotkey_chain:
        pop ds
        pop bx
        pop ax
        jmp dword ptr cs:[old09ptr]
process_hotkey endp

;------------------------------------------------------------
; real timer tick: while window is visible, refresh AX each tick
;------------------------------------------------------------
timer_tick proc
        push ax
        push bx
        push ds

        push cs
        pop ds
        mov last_ax, ax

        cmp byte ptr [window_on], 0
        jne short timer_draw

        cmp byte ptr [was_drawn], 0
        je  short timer_chain
        call erase_window
        mov byte ptr [was_drawn], 0
        jmp short timer_chain

timer_draw:
        mov ax, word ptr [last_ax]
        xor di, di
        mov bh, 4Eh
        mov bl, 'A'
        call print_register
        mov byte ptr [was_drawn], 1

timer_chain:
        pop ds
        pop bx
        pop ax
        jmp dword ptr cs:[old08ptr]
timer_tick endp


window_on db 0
was_drawn db 0
o_down    db 0
last_ax   dw 0

old09ptr  label dword
old09adr  dw 0
old09seg  dw 0

old08ptr  label dword
old08adr  dw 0
old08seg  dw 0
ENDPR:
end start
