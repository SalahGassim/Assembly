bits 16
org 0x7C00

	cli
	xor ax,ax
	mov ds,ax
	mov es,ax
                mov ss,ax
                mov sp,0xffff
checkA:
	mov ah, 0x02
                mov al, 32
                mov dl, 0x80
                mov dh , 0
                mov ch, 0
                mov cl, 2
                mov bx , start
                int 13h
                jc checkA   
                jmp start
                
 times (510 - ($ - $$)) db 0
db 0x55, 0xAA

              
              
start:
    jmp data
    
n: dd 9
k: dd 5
msg: db "good job!!!"
ans: times(81) dd 0
arr: times(81) dd 0
edii: dd 0
ij: dd 0
data:
    mov edi, 0xB8000;
    mov esp , 0xA000;
      mov byte  [edi], 'A'
      mov [edii] , edi
    
     call fillDiagonal
     
     mov eax , 0x3
    push eax
    xor eax , eax
    push eax
    call fillRemainning
    add esp , 8
    
    push dword [n]
    push ans
    push arr
    call copy
    add esp , 12
    
    push dword [k]
    call removeKDigits
    add esp , 4
    
    push dword [n]
    push dword arr
    call print
    add esp , 8
    
    mov edi, 0xB8000;
    mov esp , 0xA000;
    mov [edii] , edi
    
    check:
    mov edi , [edii]
    in al,0x64
    test al,1
    jz check
    
    in al , 0x60
    cmp al ,  0x80
    jae check
    
    
    cmp al , 0x50
    je down
    cmp al , 0x48
    je up
    cmp al , 0x4d
    je right
    cmp al , 0x4b
    je left
    
    cmp al , 0x02
    je one
   ; cmp al , 0x4f
    ;je one
    
    cmp al , 0x03
    je two
    ;cmp al , 0x50
    ;je two
    
    cmp al , 0x04
    je three
    ;cmp al , 0x51
    ;je three
    
    cmp al , 0x05
    je four
    ;cmp al , 0x4b
    ;je four
    
    cmp al , 0x06
    je five
    ;cmp al , 0x4c
    ;je five
    
    cmp al , 0x07
    je six
    ;cmp al , 0x4d
    ;je six
    
    cmp al , 0x08
    je seven
    ;cmp al , 0x47
    ;je seven
    
    cmp al , 0x09
    je eight
    ;cmp al , 0x48
    ;je eight
    
    cmp al , 0x0a
    je nine
    ;cmp al , 0x49
    ;je nine
    
    
    jmp check
    exit:
    popad
    mov al , 1
    mov bh , 0
    mov bl , 0x5
    mov cx , 0xa
    mov dh , 11
    mov dl , 14
    push cs
    pop es
    mov bp, msg
    mov ah, 13h 
    int 10h 
    hlt
    down:
    pushad
    mov eax , edi
    mov ebx , 80
    sub eax , 0xb8000
    shr eax , 0x1
    
    cdq
    div ebx
    inc eax
    mov dh , al
    mov ah , 2
    mov bh , 0
    cmp dh , 3
    je advancedown
    cmp dh , 7
    je advancedown
    cmp dh , 11
    je check
    int 10h
    add edi,160
    mov [edii] , edi
   ; mov byte [edi] , 'd'
    popad
    jmp check
    
    up:
    pushad
    mov eax , edi
    mov ebx , 80
    sub eax , 0xb8000
    shr eax , 0x1
    cdq
    div ebx
    dec eax
    mov dh , al
    mov ah , 2
    mov bh , 0
    cmp dh , 3
    je advanceup
    cmp dh , 7
    je advanceup
    cmp dh , -1
    je check
    int 10h
    sub edi,160
    mov [edii] , edi
   ; mov byte [edi] , 'u'
    popad
    jmp check
    
    right:
    pushad
    mov eax , edi
    mov ebx , 80
    sub eax , 0xb8000    
    shr eax , 0x1
    cdq
    div ebx
    add edx , 2
    mov dh , al
    mov ah , 2
    mov bh , 0
    cmp dl , 0x6
    je advanceright
    cmp dl , 14
    je advanceright
    cmp dl , 22
    je check
    int 10h
    add edi,4
    mov [edii] , edi
    ;mov byte [edi] , 'r'
    popad
    jmp check
    
    left:
    pushad
    mov eax , edi
    mov ebx , 80
    sub eax , 0xb8000
    shr eax , 0x1
    cdq
    div ebx
    sub edx , 2
    mov dh , al
    mov ah , 2
    mov bh , 0
    cmp dl , 0x6
    je advanceleft
    cmp dl , 14
    je advanceleft
    cmp dl , -2
    je check
    
    int 10h
    sub edi,4
    mov [edii] , edi
   ; mov byte [edi] , 'l'
    popad
    jmp check
    
    advanceup:
    sub dh , 1
    int 10h
    sub edi,320
    mov [edii] , edi
    ;mov byte [edi] , 'u'
    popad
    jmp check
    
    advancedown:
    add dh , 1
    int 10h
    add edi,320
    mov [edii] , edi
   ; mov byte [edi] , 'd'
    popad
    jmp check
    
    advanceright:
    add dl , 2
    int 10h
    add edi,8
    mov [edii] , edi
    ;mov byte [edi] , 'r'
    popad
    jmp check
    
    advanceleft:
    sub dl , 2
    int 10h
    sub edi,8
    mov [edii] , edi
    ;mov byte [edi] , 'l'
    popad
    jmp check
    
    one:
    mov eax , 1
    jmp set
    
    two:
    mov eax , 2
    jmp set
    
    three:
   mov eax , 3
    jmp set
    
    four:
    mov eax , 4
    jmp set
    
    five:
    mov eax , 5
    jmp set
    
    six:
    mov eax , 6
    jmp set
    
    seven:
    mov eax , 7
    jmp set
    
    eight:
    mov eax , 8
    jmp set
    
    nine:
    mov eax , 9
    jmp set
    
    set:
    pushad
    mov ah , 03h
    mov bh , 0
    int 10h

    checki:
    mov al , dh
    cmp al , 0
    je i0
    cmp al , 1
    je i1
    cmp al , 2
    je i2
    cmp al , 4
    je i3
    cmp al , 5 
    je i4
    cmp al , 6
    je i5
    cmp al , 8
    je i6
    cmp al , 9
    je i7
    cmp al , 10
    je i8
    
    checkj:
    mov al , dl
    cmp al , 0
    je jj0
    cmp al , 2
    je jj1
    cmp al , 4
    je jj2
    cmp al , 8
    je jj3
    cmp al , 10
    je jj4
    cmp al , 12
    je jj5
    cmp al , 16
    je jj6
    cmp al , 18
    je jj7
    cmp al , 20
    je jj8
    
    setij:
    cmp byte [edi + 1] , 0x6
    je check
    mov eax , 0x9
    imul esi
    add eax , ebx
    mov [ij] , eax
    popad
    mov ebx , [ij]
    mov [arr + 4 * ebx] , eax
    add eax , 0x30
    mov [edi] , al
    mov byte [edi + 1] , 0x5
    call validate
    cmp eax , 0
    je exit
   ; pushad
;    mov ebx , 0x9
;    push ebx
;    push arr 
;    call validate
;    add esp , 8
;    cmp eax , 0
;    je exit
;    popad
    jmp check
    
    i0:
    mov esi , 0
    jmp checkj
    i1:
    mov esi , 1
    jmp checkj
    i2:
    mov esi , 2
    jmp checkj
    i3:
    mov esi , 3
    jmp checkj
    i4:
    mov esi , 4
    jmp checkj
    i5:
    mov esi , 5
    jmp checkj
    i6:
    mov esi , 6
    jmp checkj
    i7:
    mov esi , 7
    jmp checkj
    i8:
    mov esi , 8
    jmp checkj
    
    jj0:
    mov ebx , 0
    jmp setij
    jj1:
    mov ebx , 1
    jmp setij
    jj2:
    mov ebx , 2
    jmp setij
    jj3:
    mov ebx , 3
    jmp setij
    jj4:
    mov ebx , 4
    jmp setij
    jj5:
    mov ebx , 5
    jmp setij
    jj6:
    mov ebx , 6
    jmp setij
    jj7:
    mov ebx , 7
    jmp setij
    jj8:
    mov ebx , 8
    
    jmp setij
    
    
    
    
    
    
    
    
   ;==========================================================
    ; -------------------------------functions------------------------
   ; ==========================================================
   
   ;=============================================================
    random: ; int random (int n)
    push ebp
    mov ebp , esp
    
    rdtsc
    xor edx , edx
    mov ebx , [ebp +6]
    idiv ebx
    mov eax , edx
    
   ; dec ebx
    ;cmp eax , ebx
    ;je one
    add eax , 1
    ;
    ;one:
    
    mov esp , ebp
    pop ebp
    ret ; return (math.random%n + 1)
    
    
    ;==================================================================
    columnCheck: ; bool columnCheck( int column , int number)
    push ebp
    mov ebp , esp
    
    xor edi , edi    
    mov eax , [ebp + 6] ; eax = j
    mov esi , [ebp + 10] ; esi = number
    xor ecx , ecx
    
    
    
    rowloop:
    cmp ecx , 0x9
    jge donerows
    
    cmp [arr + 4 * eax] , esi
    je foundincolumn
    
    
    inc ecx
    add eax , 0x9
    jmp rowloop
    
    foundincolumn:
    mov edi , 1
    
    donerows:
    mov eax , edi
    mov esp , ebp
    pop ebp
    ret ; return 1 if found in column i , 0 otherwise
    
    
    ;=================================================================
    rowCheck: ; bool rowCheck( int row , int number)
    push ebp
    mov ebp , esp
    
    xor edi , edi    
    mov eax , [ebp + 6] ; ebx = i
    mov esi , [ebp + 10] ; edx = number
    xor ecx , ecx
    
    mov ebx , 0x9
    imul ebx
    
    
    columnloop:
    cmp ecx , 0x9
    jge donecolumns
    
    cmp [arr + 4 * eax] , esi
    je foundinrow
    
    
    inc ecx
    inc eax
    jmp columnloop
    
    foundinrow:
    mov edi , 1
    
    donecolumns:
    mov eax , edi
    mov esp , ebp
    pop ebp
    ret ; return 1 if found in row i , 0 otherwise
    
    
    ;==========================================================================
    boxCheck: ; bool checkBox(int row , int column , int number)
    push ebp
    mov ebp , esp
    
    
    mov esi , [ebp + 14] ; esi = number
    xor edi , edi
    
    xor ecx , ecx ; i
    boxrow:
    cmp ecx , 0x3
    jge doneboxrow
    
    
    
    push ecx
    xor ecx , ecx ; j
    boxcolumn:
    cmp ecx , 0x3
    jge doneboxcolumn
    
    mov eax , [ebp + 6] ; eax = row
    add eax , [esp]; eax += i
    mov ebx , 0x9
    imul ebx
    add eax , [ebp + 10] ; eax => [row + i][column]
    add eax , ecx ; eax => [row + i][column + j]
    
    cmp [arr + 4 * eax] , esi
    je foundinbox
    
    inc ecx
    jmp boxcolumn
    doneboxcolumn:
    pop ecx
    
    inc ecx
    jmp boxrow
    foundinbox:
    pop ecx
    mov edi , 1
    doneboxrow:
    mov eax , edi
    mov esp , ebp
    pop ebp
    ret ;return 1 if found in box ; 0 otherwise
    
    
    ;=================================================================================
    safeCheck: ; bool safeCheck(int row , int column , int number)
    push ebp
    mov ebp , esp
    
    mov ecx , [ebp + 6] ; row
    mov edi , [ebp + 10] ; column
    mov esi , [ebp + 14] ; number
    
    push esi
    
   mov ebx , 0x3
   xor edx , edx
   mov eax , edi
   idiv ebx
   xor edx , edx
   imul ebx
   xor edx , edx
   push eax
       
   mov ebx , 0x3
   xor edx , edx
   mov eax , ecx
   idiv ebx
   xor edx , edx
   imul ebx
   xor edx , edx
   push eax
    
    call boxCheck
    pop ecx
    pop edi
    pop esi
    
    
    mov ecx , [ebp + 6] ; row
    mov edi , [ebp + 10] ; column
    mov esi , [ebp + 14] ; number
    
    
    push eax
    push edi
    push esi
    push ecx
    call rowCheck
    pop ecx
    pop esi
    pop edi
    pop ebx
    or eax , ebx
    push eax
    
    push ecx
    push esi
    push edi
    call columnCheck
    pop edi
    pop esi
    pop ecx
    pop ebx
    or eax , ebx
    

    mov esp , ebp
    pop ebp
    ret
    
    
    ;=========================================================================
    fillBox: ; void fillBox(int row , int column)
    push ebp
    mov ebp , esp
    
    mov esi , [ebp + 6] ; row
    mov edi , [ebp + 10] ; column
    
    xor ecx , ecx
    fori:
    cmp ecx , 0x3
    jge donei
    
    push ecx
    xor ecx , ecx
    forj:
    cmp ecx , 0x3
    jge donej
    
    dowhile:
    mov eax, 0x9
    push eax
    call random
    add esp , 4
    
    mov ebx , eax
    
    pushad
    
    push eax
    push edi
    push esi
    call safeCheck
    pop esi
    pop edi
    pop ebx
    
    
    
    cmp eax , 0x1
    popad
    je dowhile
    
    
    mov eax , esi
    add eax , [esp]
    mov edx , 0x9
    imul edx
    add eax , edi
    add eax , ecx
    
    mov [arr + 4 * eax] , ebx
    
    inc ecx
    jmp forj
    
    donej:
    pop ecx
    inc ecx
    jmp fori
    
    donei:
    mov esp , ebp
    pop ebp
    ret
   
     ;==================================================
    fillDiagonal: ;void fillDiagonal()
    push ebp
    mov ebp , esp
    
    xor ecx , ecx
    diag:
    cmp ecx , 0x9
    jge donediag
    
    push ecx
    push ecx
    call fillBox
    pop ecx
    pop ecx
    
    
    add ecx , 0x3
    jmp diag
    donediag:
    
    mov esp , ebp
    pop ebp
    ret
    
    
    ;======================================================================
    fillRemainning: ; bool fillRemainning (int row  , int column)
    push ebp
    mov ebp , esp
    
    mov esi , [ebp + 6] ; row
    mov edi , [ebp + 10] ; column
    
    cmp edi , 0x9
    jnge next1
    
    cmp esi , 0x8
    jnl next1
    
    inc esi
    xor edi , edi
    
    next1:
    
    cmp edi , 0x9
    jnge next2
    
    cmp esi , 0x9
    jnge next2
    
    mov eax , 0x1
    jmp returning
    
    next2: ; if(i < 3) ..... 0 1 2
    cmp esi , 0x3
    jnl next3
    
    cmp edi , 0x3 ; if(j < 3)
    jnl next5
    
    mov edi , 0x3
    jmp next5
    
    
    next3: ; else if (i < 6) ..... 3 4 5
    cmp esi , 0x6
    jnl next4
    
    mov eax , esi
    xor edx , edx
    mov ebx , 0x3
    idiv ebx
    xor edx , edx
    imul ebx
    xor edx , edx
    
    
    cmp edi , eax ; if (j == i/3 * 3)  i.e j == 3
    jne next5
    
    add edi , 0x3
    jmp next5
    
    next4: ; else .... 6 7 8 9
    cmp edi , 0x6
    jnge next5
    
    inc esi
    xor edi , edi
    
    cmp esi , 0x9
    jnge next5
    
    mov eax , 0x1
    jmp returning
    
    
    next5:
    
    mov ecx , 0x1
    
    label:
    cmp ecx , 0x9
    jnle outofloop
    
    push ecx
    push edi
    push esi
    call safeCheck
    pop esi
    pop edi
    pop ecx
    
    cmp eax , 0x1
    je unsafe
    
    mov eax , 0x9
    imul esi
    add eax , edi
    mov [arr + 4 * eax ] , ecx
    
    push ecx
    inc edi
    push edi
    push esi
    call fillRemainning
    pop esi
    pop edi
    dec edi
    pop ecx
    
    cmp eax , 0x1
    je returning
    
    mov eax , 0x9
    imul esi
    add eax , edi
    mov dword [arr + 4 * eax] , 0
    
    unsafe:
    inc ecx
    jmp label
    
    outofloop:
    xor eax , eax
    returning:
    mov esp , ebp
    pop ebp
    ret
    
    ;=================================================================
    removeKDigits:  ; void removeKDigits(int k)
    push ebp
    mov ebp , esp
    
    mov ecx , [ebp + 6] ; ecx = k
    
    whileloop:
    cmp ecx , 0
    jle donewhileloop
    
    
    mov eax , 81
    push eax
    call random
    add esp , 4
    cmp eax , 81
    jne decrease
    dec eax
    decrease:
    mov ebx , 0x9
    xor edx , edx
    idiv ebx
    
    cmp edx , 0x00
    je zero

    dec edx
    
    zero:
    push edx
    xor edx , edx
    imul ebx
    pop edx
    add eax , edx
    
    cmp dword [arr + 4 * eax] , 0
    je whileloop
    
    mov dword [arr + 4 * eax] , 0
    
    dec ecx
    jmp whileloop
    
    donewhileloop:
    
    mov esp , ebp
    pop ebp
    ret
    
    ;===================================
    copy: ; void copy(int[][] dest , int[][] src , int n)
    push ebp
    mov ebp , esp
    
    mov edi , [ebp + 6] ; edi = dest
    mov esi , [ebp + 10] ; esi = src
    mov ebx , [ebp + 14] ; ebx = n
    
    xor ecx , ecx
    forii:
    cmp ecx , ebx
    jge doneii
    
    push ecx
    xor ecx , ecx
    forjj:
    cmp ecx , ebx
    jge donejj
    
    
    xor edx , edx
    mov eax , [esp]
    imul ebx
    add eax , ecx
   
    mov edx ,  [esi + 4 * eax]
    mov [edi + 4 * eax] , edx

    inc ecx
    jmp forjj
    donejj:
    
    
    pop ecx
    
    inc ecx
    jmp forii
    doneii:
    
    
    mov esp , ebp
    pop ebp
    ret 
    
       ; ;============================================
    validate: ;boolean validate()
    push ebp
    mov ebp , esp
    mov ebx , 0x9
    xor edi , edi
    
    xor ecx , ecx
    foriii:
    cmp ecx , ebx
    jge doneiii
    
    push ecx
    xor ecx , ecx
    forjjj:
    cmp ecx , ebx
    jge donejjj
    mov eax , [esp]
    imul ebx
    add eax , ecx
    
    push dword [arr + 4 * eax]
    mov dword [arr + 4 * eax] , 0
    idiv ebx
    
    push ecx
    push eax
    call safeCheck
    mov edi , eax
    mov ebx , 0x9
    pop eax
    imul ebx
    pop ecx
    add eax ,  ecx
    pop dword [arr + 4 * eax]
    
    cmp edi , 0x1
    je doneiii
    inc ecx
    jmp forjjj
    donejjj:
    pop ecx
    
    inc ecx
    jmp foriii
    doneiii:
    mov eax , edi
    mov esp , ebp
    pop ebp
    ret
   
   ;===================================================== 
    print: ;void print(int[][] arr , int n)
    push ebp
    mov ebp , esp
    
    mov ebx , [ebp + 6] ; ebx = arr
    mov esi , [ebp + 10] ; esi = n
    mov edi , 0xb8000
    
    xor ecx , ecx
    for1:
    cmp ecx , esi
    jge done1
    
    push ecx
    xor ecx , ecx
    for2:
    cmp ecx , esi
    jge done2
    
    cmp ecx , 0x3
    je blockj
    
    cmp ecx , 0x6
    je blockj
    
    continuej:
    
    mov eax , [esp]
    imul esi
    add eax , ecx
    mov al ,   [ebx + 4*eax ]
    cmp al , 0
    je zerofound
    
    add al , 0x30
    mov [edi],al
    mov byte [edi + 1] , 0x6
    
    continueprinting:
    add edi , 2
    mov byte [edi] , 0x20
    add edi , 2
    inc ecx
     jmp for2
    done2:

 pushad
call newLine
popad
mov edi,[edii]

   pop ecx
    cmp ecx , 0x2
    je blocki
    cmp ecx , 0x5
    je blocki
    
    continuei:
    
    inc ecx
    jmp for1
    done1:
    
    mov esp , ebp
    pop ebp
    ret
;    
    blockj:

    mov byte [edi] , 0x20
    add edi , 2
    mov byte [edi] , 0x20
    add edi , 2
    jmp continuej
;    
    blocki:
 pushad
call newLine
popad
mov edi,[edii]
    jmp continuei
    
    newLine:
        mov eax,edi
        sub eax,0xb8000
        mov ebx,160
        cdq
        ;shr eax , 0x1
        div ebx
        inc eax
        mul ebx
        add eax,0xb8000
        mov edi,eax
        mov [edii],edi
        ret
;    
    zerofound:
   mov al ,'?'
    mov [edi],al
    jmp continueprinting
    
    times (0x400000 - ($-$$)) db 0
db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
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