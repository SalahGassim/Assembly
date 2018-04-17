BITS 16

[org 0x7c00]
 
mov [ BOOT_DRIVE ], dl 
xor si ,si
mov ds , si ;
mov bp , 0xA000 
mov sp , bp     
mov bx , 0x7e00 
mov dh , 5 
mov dl , [ BOOT_DRIVE ]
call diskload
jmp start

restart:
mov sp, 0xA000
mov ax, 0x9a00
mov word[dir_arr], ax
xor ax ,ax
mov ax ,0x9005
mov word[arr],ax 
mov ax , 2
mov word[direction],ax
mov ax ,0
mov word[score], ax
mov word[gameState], ax
mov ax ,3
mov word[snakeLength] , ax
mov al, 23
mov byte[head_x] , al
mov al ,25
mov byte[tail_x] , al
mov al ,24
mov byte[head_y] , al
mov byte[tail_y] , al




start:
    call start_graphics_mode
    call init_array  
    call put_food 
	MainLoop :  
		call display_score
		call draw_background 
		call draw_frame
		call sleep
		mov ax , [gameState]
		cmp ax , 0 
		jne MainLoop 
		call update
		call handle_input
		jmp MainLoop
    ret
    
diskload :
push dx
mov ah , 0x02 
mov al , dh 
mov ch , 0x00
mov dh , 0x00 
mov cl , 0x02
int 0x13 
jc disk_error
pop dx 
cmp dh , al 
jne disk_error 
ret
disk_error :
mov dx , DISK_ERROR_MSG
call print
jmp $
print:   
	mov ah,0x0e
	wr:
	mov byte al,[edx]
	cmp al,0
	jz return
	int 0x10
	inc dx
	jmp wr
	return :
	ret

times 510 -($-$$) db 0
dw 0xaa55  



start_graphics_mode:
    mov ah,0
    mov al,13h
    int 10h
    ret
    
    
init_array :
    xor bx,bx 
    mov ax , 2401
    loop1 :
	mov si , [arr]           ; array address of first element
        mov byte [si+bx],  0 
        inc bx
        cmp bx ,ax
    jl loop1
	
	
    mov si , [arr]
    mov bx , 1199
    mov byte [si+bx] ,   1
    mov bx , 1200
    mov byte [si+bx] ,   1
    mov bx , 1201
    mov byte [si+bx] ,   1
	
	
    mov si , [dir_arr]
    mov bx , 0
    mov byte [si+bx] ,   2
    mov bx , 1
    mov byte [si+bx] ,   2
	
	call put_obsatcles
    ret
put_obsatcles: 
push si
push cx

mov bx, [arr]
mov cx , [score]

cmp cx , 6
jge l4
cmp cx , 4
jge l3
cmp cx , 2
jge l2

l1:

jmp complete


l2:
mov si , 995
l21:
mov byte [bx+si] , 1
inc si
cmp si ,1015
jl l21

mov si , 1485
l22:
mov byte [bx+si] , 1
inc si
cmp si ,1505
jl l22

jmp complete


l3:

mov si , 995
l_21:
mov byte [bx+si] , 0
inc si
cmp si ,1015
jl l_21

mov si , 1485
l_22:
mov byte [bx+si] , 0
inc si
cmp si ,1505
jl l_22

mov si , 15
l31:
mov byte [bx+si] , 1
add si ,49
cmp si ,1485
jl l31

mov si , 1014
l32:
mov byte [bx+si] , 1
add si,49
cmp si ,2435
jl l32

mov si , 1960
l33:
mov byte [bx+si] , 1
add si,1
cmp si ,1976
jl l33

mov si , 524
l34:
mov byte [bx+si] , 1
add si,1
cmp si ,539
jl l34  
jmp complete

l4:
mov si , 15
l_31:
mov byte [bx+si] , 0
add si ,49
cmp si ,1485
jl l_31

mov si , 1014
l_32:
mov byte [bx+si] , 0
add si,49
cmp si ,2435
jl l_32

mov si , 1960
l_33:
mov byte [bx+si] , 0
add si,1
cmp si ,1976
jl l_33

mov si , 524
l_34:
mov byte [bx+si] , 0
add si,1
cmp si ,539
jl l_34
  
mov si , 980
l41:
mov byte [bx+si] , 1
add si,1
cmp si ,1010
jl l41  

mov si ,1470
l42:
mov byte [bx+si] , 1
add si,1
cmp si ,1519
jl l42  

mov si , 1020
l43:
mov byte [bx+si] , 1
add si,1
cmp si ,1029
jl l43  

mov si , 1495
l44:
mov byte [bx+si] , 1
add si,49
cmp si ,2425
jl l44  

mov si , 30
l45:
mov byte [bx+si] , 1
add si,49
cmp si ,1059
jl l45 

mov si , 0
l46:
mov byte [bx+si] , 1
add si,1
cmp si ,40
jl l46 

mov si , 0
l47:
mov byte [bx+si] , 1
add si,49
cmp si ,490
jl l47

mov si , 48
l48:
mov byte [bx+si] , 1
add si,49
cmp si ,538
jl l48

complete:
    pop si
    pop cx
	ret

put_food : 
	xor cx , cx 
	xor bx , bx
	checkSnakeBody: 
		call rng1  
		push ax	
		call rng2 
		mov cx , ax 
		pop bx 
		push bx 
		push cx 
		call get_value 
		pop cx 
		pop bx
		xor ah , ah
		cmp al , 1  
		je checkSnakeBody 
		cmp al , 2 
		je checkSnakeBody
	push bx
	push cx 
	push 2 
	call set_value  
	add esp , 6
	ret  

rng1 : 
	xor dx , dx
	mov ax ,[46ch] 
	mov bx , 49  
	div bx  
	xor dh , dh 
	xor ax , ax 
	mov ax , dx 
	ret 
	
rng2 : 
	xor dx , dx 
	mul al 
	mov bx , 49  
	div bx  
	xor dh , dh 
	xor ax , ax 
	mov ax , dx 
	ret 
	
get_value : 
	mov byte cl , [esp+4]  ;x 
	mov byte al , [esp+2]  ;y
	xor ah , ah 
	xor ch , ch
	mov bl , 49 
	mul bl 
	add ax , cx
	mov bx , ax  
	xor ax ,ax 
	mov di , word [arr] 
	mov  al , byte [di+bx] 
	ret

display_score : 
	mov al , 13 
	mov ah , 0x0e 
	int 10h 
	
	mov word ax , [score]
	push ax 
	call print_decimal 
	add esp , 2 
	
	ret

print_decimal :   
	xor dx , dx 
	mov ax , [esp+2]  ; 1023
	mov bx , 10000 
	div bx  
	
	
	mov bx , table 
	xlat
	mov ah , 0x0e 
	int 10h 
	
	mov ax , dx 
	xor dx , dx 
	mov bx , 1000 
	div bx 
	
	mov bx , table 
	xlat
	mov ah , 0x0e 
	int 10h 
	
	mov ax , dx
	xor dx , dx 
	mov bx  ,100 
	div bx 
	
	mov bx , table 
	xlat
	mov ah , 0x0e  
	int 10h 
	
	mov ax , dx 
	xor dx , dx 
	mov bx , 10 
	div bx 
	
	mov bx , table 
	xlat
	mov ah , 0x0e 
	int 10h  
	
	mov ax , dx 
	mov bx , table 
	xlat 
	mov ah , 0x0e 
	int 10h
	ret 


draw_background:
    push 60
    push 0
    push 2
    push 200
    push 0fh    
    call draw_rectangle       ; DRAW A LEFT BOARDER OF THE BOX
    add esp , 10

    push 60
    push 0
    push 200
    push 2
    push 0fh                 
    call draw_rectangle       ; DRAW A TOP BOARDER OF THE BOX
    add esp , 10

    push 258
    push 0
    push 2                  
    push 200
    push 0fh
    call draw_rectangle       ; DRAW A RIGHT BOARDER OF THE BOX
    add esp , 10

    push 60
    push 198
    push 200
    push 2                 
    push 0fh
    call draw_rectangle        ; DRAW A BOTTOM BOARDER OF THE BOX
    add esp , 10

    push 62
    push 2
    push 196
    push 196
    push 00h
    call draw_rectangle
    add esp , 10
    ret
stop_graphics_mode:
    mov ax , 6h 
    int 10
    ret 


draw_rectangle :
	push ax 
	push bx 
	push cx 
	push dx 
	push si 
	push di 
	push ds 
    xor bx,bx
    loop2 :
        xor ax,ax
        loop3:
            mov di , [esp+24] ;x
            mov si , [esp+22] ;y

            add di ,bx
            add si ,ax

            mov dx , [esp+16] ; color
            push dx
            push bx
            push ax
            push di
            push si
            push dx
            call  draw_pixel
            add esp,6
            pop ax
            pop bx
            pop dx

            mov si , [esp+18] ; height
            inc ax
            cmp ax , si
            jl loop3
        mov di , [esp+20] ; width
        inc bx
        cmp bx , di
        jl loop2
	pop ds 
	pop di 
	pop si 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
        ret
draw_pixel :
	; ds , es , fs , gs , cs , si , di , bx 
    mov cx, 0A000h ; The offset to video memory
    mov es,cx
    mov ax,[esp+4] ; Y coord
    mov cx,320     
    mul cx
    mov bx,[esp+6] ; X coord
    add ax,bx
    mov di,ax
    mov dx,[esp+2]
    mov byte [es:di],dl
    ret



draw_frame :
    xor cx ,cx 	
	loop4 : 
		xor di ,di 
		loop5:   
			push di 
			push cx
			mov ax , 49 
			mul di       
			add ax , cx  
			mov bx , ax  
			mov si , word [arr]  
			mov al , byte [si+bx]    
			cmp al , 1  
			jne loop6 
		

                draw:
			push ax 
			mov ax , 4   
			mul di       
			mov bx , 2  
			add ax , bx  
			
			mov si , ax  
			mov ax , 4   
			mul cx       
			mov bx , 62  
			add ax ,bx   
			pop bx 
			push ax 
			push si
			push 4
			push 4 
			push 0fh
			call draw_rectangle 
			add esp , 10 
			jmp endloop
		
                drawfood:
			push ax 
			mov ax , 4   
			mul di       
			mov bx , 2  
			add ax , bx  
			
			mov si , ax  
			mov ax , 4   
			mul cx       
			mov bx , 62  
			add ax ,bx   
			pop bx 
			push ax 
			push si
			push 4
			push 4 
			push 04h
			call draw_rectangle 
			add esp , 10 
			jmp endloop

            	loop6:
				cmp al , 2 
				je drawfood 
			endloop:
				pop cx   
				pop di   
				inc di   
				mov ax , 49 
				cmp di , ax  
				jl loop5
		inc cx 
		mov ax , 49 
		cmp cx ,ax 
		jl loop4
	ret


sleep : 
	mov si , 1
	mov bx , [46ch] 
	xor di  ,di 
	timer : 
		mov ax  , [46ch]
		sub ax , bx 
		cmp ax ,2 
		jl timer
		mov bx , [46ch]
		inc di 
		cmp di , si
		jl timer 
	ret


update :  
	mov al , byte [head_x]
	mov cl , byte [head_y]
	mov bl , byte [direction] 
	cmp bl , 0 
	je _movUp
	cmp bl , 1 
	je _movDown
	cmp bl , 2 
	je _movLeft
	cmp bl , 3 
	je _movRight 
	ret
	_movUp   : 
		cmp cl , 0  
		je _tunUp 
		dec cl  	
		jmp return_update
	_movDown : 
		cmp cl , 48 
		je _tunDwn
		inc cl 
		jmp return_update
	_movLeft : 
		cmp al , 0 
		je _tunLeft
		dec al 
		jmp return_update  
	_movRight:  
		cmp al , 48 
		je _tunRight 
		inc al 
		jmp return_update 
	
	_tunUp : 
		mov cl , 48 
		jmp return_update  
	_tunDwn : 
		mov cl , 0 
		jmp return_update  
	_tunLeft : 
		mov al , 48 
		jmp return_update  
	_tunRight:
		mov al , 0 
		jmp return_update 
		
	return_update:  
		mov byte [head_x] , al 
		mov byte [head_y] , cl 
		push ax 
		push cx  
		
		mov byte bl , [direction] 
		
		mov si , [dir_arr]
		mov ax , [snakeLength] 
		dec ax 
		add si , ax 
		mov byte [si] , bl 
		
		call check
		
		pop cx 
		pop ax
		
		push ax 
		push cx 
		push 1 
		call set_value
		add esp , 6	 
		ret
	end_update:
		ret


		
set_value : 
	mov byte cl , [esp+6]
	mov byte al , [esp+4]
	xor dx , dx 
	mov dx , [esp+2]
	xor ah , ah 
	xor ch , ch 
	mov bl , 49 
	mul bl 
	add ax , cx
	mov bx , ax  
	mov di , word [arr] ;word [si]
	mov  byte [di+bx] , dl
	ret
	

check :  
	push ax 
	push bx 
	push cx 
	push dx 
	push di 
	push si 

	xor bx , bx 
	xor ax , ax 
	xor cx , cx
	
	mov cl , [esp+16]  ; x  
	mov bl , [esp+14]  ; y
	
	push cx 
	push bx 
	call get_value 
	pop bx 
	pop cx
	
	xor ah , ah  
	cmp al , 1 
	je _dead 
	cmp al , 2 
	je _eat 
	jmp _mov 
	
	_dead : 
		mov word [gameState] , 1 
		call sleep
		call sleep
		call sleep 
		call sleep 
		call sleep 
		call Game_over
		jmp end_check 
	_eat  : 
		mov si , word [score] 
		inc si 
		mov word [score] , si 
		
		mov si ,word  [snakeLength] 
		inc si 
		mov word [snakeLength] , si
                call put_obsatcles 
		call put_food
		jmp end_check 
	_mov :
		call remove_tail 
	end_check :
		pop si 
		pop di 
		pop dx 
		pop cx 
		pop bx
		pop ax 
		ret 
	

remove_tail : 
	xor cx , cx 
	xor bx , bx
	xor ax , ax
	mov cl , [tail_x]
	mov bl , [tail_y]
	
	push cx 
	push bx 
	push 0 
	call set_value
	add esp , 2 
	
	
	mov bx , [dir_arr]
	mov byte al , [bx]  
	
	pop bx 
	pop cx 
	
	cmp al , 0 
	je tail_up 
	cmp al , 1 
	je tail_down 
	cmp al , 2 
	je tail_left 
	cmp al , 3 
	je tail_right 
	jmp end_tail 
	tail_up : 
		cmp bl, 0 
		je tuntup 
		dec bl 
		jmp return_tail 
		
	tail_down : 
		cmp bl, 48 
		je tuntdown 
		inc bl 
		jmp return_tail 
	
	tail_left : 
		cmp cl, 0 
		je tuntleft 
		dec cl 
		jmp return_tail 
	
	tail_right : 
		cmp cl, 48 
		je tuntright 
		inc cl 
		jmp return_tail 
		
	tuntup: 
		mov bl , 48
		jmp return_tail
		
	tuntdown: 
		mov bl , 0
		jmp return_tail
	
	tuntleft: 
		mov cl , 48
		jmp return_tail
		
	tuntright: 
		mov cl , 0
		jmp return_tail 
		
	return_tail: 
		mov byte [tail_x] , cl 
		mov byte [tail_y] , bl 
		
		call shift_array 
	end_tail : 
		ret


shift_array :  
		xor si , si   
		mov si , 1
		Loop7: 
			mov bx , [dir_arr] 
			mov byte cl , [bx+si] 
			mov byte [bx+si-1] , cl 
			mov di , word [snakeLength]
			inc si 
			cmp si , di
			jl Loop7
		ret  

Game_over:  
	
	push 0 
	push 0 
	push 320                  ; clear screen 
	push 200 
	push 0 
	call draw_rectangle 
	add esp , 10 
	
	xor bx , bx 
	displaymsg: 
		mov byte al , [gameOverMsg+bx]  
		cmp al , 0
		jz return_it
		mov ah , 0x0e 
		int 10h  
		 inc bx 
		jmp displaymsg 
	return_it:
		mov word ax ,[score] 
		push ax 
		call print_decimal 
		add esp , 2  
		xor bx , bx
		displaymsg2 : 
			mov byte al , [pressRestart+bx]  
			cmp al , 0
			jz return_it2
			mov ah , 0x0e 
			int 10h  
	       	        inc bx 
			jmp displaymsg2   
	return_it2:

        

		mov ah , 10h 
		int 16h   
                jmp restart
 
		ret


handle_input:
	
	mov ah , 01h ;check keyboard status
	int 16h 
	jz _none 
	
	mov ah , 10h  ; get pressed key
	int 16h
	
	
	cmp al , 'w'
	je up 

	cmp al ,  's'
	je down 
	
	cmp al ,  'a' 
	je left 
	
	cmp al ,  'd' 
	je right     
	
	cmp ah , 48h 
	je up 
	cmp ah , 50h 
	je down 
	cmp ah , 4bh 
	je left 
	cmp ah , 4dh 
	je right 
	jmp _none
	up : 
		mov byte bl , [direction]
		cmp bl , 1 
		je _ignore
		mov byte [direction] , 0 
		ret 
	down : 
		mov byte bl , [direction]
		cmp bl , 0
		je _ignore
		mov byte [direction] , 1 
		ret
	left : 
		mov byte bl , [direction]
		cmp bl , 3 
		je _ignore
		mov byte [direction] , 2 
		ret 
	right :
		mov byte bl , [direction]
		cmp bl , 2 
		je _ignore
		mov byte [direction] , 3 
		ret 
	_ignore:
	_none : 
		ret 






        ;  LOADER VARIABLES :
        
DISK_ERROR_MSG db " Disk read error !", 0

BOOT_DRIVE : db 0


        ; GAME'S VARIABLES

	arr :  dw 0x9005       ; main game array (49,49) that represents  the screen 
   
	head_x :  db 23  ; x coordinate of snake head 
		
	head_y : db 24 	 ; y coordinate of snake head 
		
	direction : db 2  ;  direction that the snake is moving to
			 ;  0= up ; 1 = down ; 2 = left ; 3 = right
	tail_x :  db 25   ; x coordinate of snake tail 
		    
	tail_y : db 24
			 ; y coordinate of snake tail 
	dir_arr : dw 0x9a00
		  ; pointer to [dir_array] start 
	snakeLength :  dw 3 ; the length of the snake 
		
	table :   db "0123456789ABCDEF"     ; translation table used for printing hex and decimal score
		 
	score :  dw 0      ; the score of the player 
		 
	gameState  : dw 0  ; the state of the game 0 = playing 1 = gameOver    0=playing
		  
	gameOverMsg: 
		db 10,10,10,10,10,10,10,10,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,"Game Over!",10,13
		db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,"Your Score",10,13 
		db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h ,0
	pressRestart: 
		db 10,13,20h,20h,20h,20h,20h,20h,20h,20h, "press aany key to restart" ,0




times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xDA, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


