;Nombre por default que toma el ejecutable
name "holamundo" ;directiva, palabra reservada

; este programa imprime dos mensajes en la pantalla
; escribiendo directamente en la memoria de video.
; en la memoria vga: el primer byte es el caracter ascii,
; el siguiente byte son los atributos del caracter.
; los atributos del caracter es un valor de 8 bits,
; los 4 bits altos ponen el color del fondo
; y los 4 bits bajos ponen el color de la letra.

; hex    bin        color
; 
; 0      0000      black
; 1      0001      blue
; 2      0010      green
; 3      0011      cyan
; 4      0100      red
; 5      0101      magenta
; 6      0110      brown
; 7      0111      light gray
; 8      1000      dark gray
; 9      1001      light blue
; a      1010      light green
; b      1011      light cyan
; c      1100      light red
; d      1101      light magenta
; e      1110      yellow
; f      1111      white
 


    org 100h                    ;Iniciamos programa en direccion 100h

	mov al, 1                   ;Modo de escritura
	mov bh, 0                   ;numero de pagina?
	mov bl, 0111_0101b          ;colores fondo_letra
	mov cx, msg2 - offset msg1  ;calcula el tamaño del mensaje. 
	mov dl, 03h                 ;columna al imprimir
	mov dh, 03h                 ;fila al imprimir
	mov bp, offset msg1         ;indica posicion de memoria donde se va a leer
	mov ah, 13h                 ;para int 10h, dice que sera impresion en pantalla
	int 10h                     ;llama int 10h
	
	    
    
    mov bl, 0000_0100b          ;colores fondo_letra	    
	mov cx, msg3 - offset msg2  ;Calcula tamaño de msg2  
	mov dl, 06h                 ;Columna
	mov dh, 06h                 ;fila
	mov bp, offset msg2         ;indica posicion donde se va a leer
	;ya no es necesaria porque no ha sido modificada ah
	;mov ah, 13h                ;Prepara para escribir en pantalla 
	int 10h                     ;llama interrupcion 10h 
	
	
	mov bl, 1111_0010b          ;colores fondo_letra
	mov cx, msgend - offset msg3;Calcula tamaño de msg3
	mov dl, 09h                 ;columna
	mov dh, 09h                 ;fila
	mov bp, offset msg3         ;direccion de memoria donde se va a leer
    int 10h                     ;llama int 10h
    
    
	jmp msgend                  ;salto incondicional a msgend
 
 
;Variables	
msg1    db "Hola, mi nombre es Jorge Herrada y esta es la practica numero 2"
msg2    db "del SSP de traductores de lenguajes I,seccion D07 2022A"
msg3    db "Mi codigo es #########"
   
   
msgend: 

        mov ah,0    ;prepara para int 16h
        int 16h     ;espera a que se presione una tecla  
        
        ;Codigo de alumno == 211721923 en base 10
        ;Codigo de alumno == 1100100111101001111011000011 en base 2
    
        mov dx, 1100100111101001b   ;C9E9 Movemos los 16 bits + significativos
        mov cx, 1001111011000011b   ;9EC3 Movemos los 16 bits - significativos
    
        ;NRC de la materia == 138641  en base 10   
        ;NRC de la materia == 100001110110010001 en base 2
    
        mov bx, 1000011101100100b   ;8764 Movemos los 16 bits + significativos
        mov ax, 0001110110010001b   ;1D91 Movemos los 16 bits - significativos
            
        
        int 20h    ;termina la ejecución
        
        end        ;No es realmente necesario ponerlo