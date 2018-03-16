.286

data segment
	
data ends

code segment 
assume cs:code, ds:data
	prmaus proc far
	    ; прячем курсор
    mov ax, 02h
    int 33h
    ; збереження вмісту регістрів ds, es та  РЗП
    push   ds    
    push   es
    pusha
    ;завантаження  сегментних регістрів ds та  es
    push   0b800h ; сегментна адреса відеобуфера
    pop    es  
    push   data ; 
    pop ds

;;;;;основне тіло процедури:
    cli; заборона переривань
    ;;;;;
    mov	cx,10
    mov     ax,0B800h ; сегментный адрес видеопамяти
    mov     es,ax
	
	mov cx, 0
	@swaploop:
		mov dx, 0
		@rawloop:
			mov di, cx
			imul di, 2*80
			add di, dx
			add di, dx

			mov ax, es:[di]
			mov bx, es:[di + 40 * 2]
			mov es:[di], bx
			mov es:[di + 40 * 2], ax

			inc dx
			cmp dx, 40
		jl @rawloop

		inc cx
		cmp cx, 25
	jl @swaploop

    sti             ;переривання дозволяються

;;;;;
    popa
    pop es
    pop ds
    
;показуємо курсор
    mov ax, 01h
    int 33h

    ret
	prmaus endp

;;;;;;;;;;;;;;;;;
begin:	
	
	;;;;config 80 x 25
	pusha
	mov ax, 3
	int 10h

	;;;;init mouse
	xor ax, ax
    int 33h
	;показуємо курсор
    mov ax, 01h
    int 33h

    mov ax, 0ch ; встановити режим обробки подій від мишки
    mov cx, 100b       ; вибрати в якості події натискання лівої кнопки (біт2=1)
    push cs
    pop es      ; вважаєм, що процедура користувача для обробки подій від мишки знаходиться в поточному сегменті кодів
    lea dx, prmaus; встановити зміщення процедури обробки подій від мишки в сегменті кодів
    int 33h     ; регістрація адреси та умов виклику

    ;;;;
    ;Для заміни миготіння на інтенсивність і використання 16 кольорів фону
    mov ah, 10h
    mov al, 3
    mov bl, 0
    int 10h

    mov ax,0B800h ; сегментный адрес видеопамяти
    mov es,ax
    mov di,0
    mov ax, 01233h
    mov ds, ax
    mov si, 0


    cli
 	mov cx, 80 * 25
 	rep movsw   
    ;mov cx, 25
    ;@loop:
    ;push cx
    	;push cx
    	;mov cx, 20
    	;mov ax, 0f57h
    	;rep stosw
    	;mov cx, 20
    	;mov ax, 0b54h
    	;rep stosw
    	;mov cx, 20
    	;mov ax, 2e50h
    	;rep stosw
    	;mov cx, 20
    	;mov ax, 1c43h
    	;rep stosw

    	;mov cx, 20

    	;pop cx
    	;dec cx
    	;cmp cx, 0
    ;jg @loop

    sti
    ;mov ah, 3
    ;mov al, 0
    ;int         10h


    popa
    mov ax, 00h ; ввести символ з клавіатури ПЕОМ
    int 16h     ; виклик функції BIOS 

    ;;;;;;;;;;;;
    push cs
    pop es      ; вважаєм, що процедура користувача для обробки подій від мишки знаходиться в поточному сегменті кодів
    lea dx, prmaus; встановити зміщення процедури обробки подій від мишки в сегменті кодів
    xor cx, cx       ;cx=0
    mov ax, 0ch      
    ;вважаємо що регістри es:dx містять логічну адресу процедури prmaus
    int 33h     ;процедура prmaus далі викликатись не буде

	;;;;;;;;;;;;;;;
	mov ax, 0600h   ;Запрос на очистку экрана.
   	mov bh, 07      ;Нормальный атрибут (черно/белый).
   	mov cx, 0000    ;Верхняя левая позиция.
   	mov dx, 184fh   ;Нижняя правая позиция.
   	int 10h        ;Передача управления в BIOS.

    mov ax, 4c00h
    int 21h

code ends
end begin