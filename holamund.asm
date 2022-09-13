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
 


    org 100h     ;indica donde inicia el programa

	mov al, 1   ;tamaño de pantalla  ;decimal
	mov bh, 0   
	mov bl, 1001_1111b  ;binario  atributos para int 10h
	mov cx, offset msg2 - offset msg1 ; calcula el tamaño del mensaje. 
	mov dl, 7o  ;octal     columna al imprimir
	mov dh, 13o          ;fila al imprimit
	mov bp, offset msg1  ;indica posicion de memoria donde se va a leer
	mov ah, 13h          ;para int 10h, dice que sera impresion en pantalla
	int 10h  
	
	
	mov cx, msgend - offset msg2  
	mov dl, 36       ;Columna
	mov dh, 13       ;fila
	mov bp, offset msg2
	mov ah, 13h
	int 10h
	jmp msgend       ;salto a msgend

;Variables	
msg1    db "Hola, seminario de solucion de problemas de traductores de lenguaje 1"
msg2    db "seccion D07"

msgend:
        mov ah,0
        int 16h    ;espera a que se presione una tecla
        int 20h    ;termina la ejecución
        
        end        ;No es realmente necesario ponerlo
        
