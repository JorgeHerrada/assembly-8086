    name "practica_3"   ; 
    
;   Este programa realiza la sumatoria de cinco datos.
;   Todos ellos son datos de 8 bits que se introducen
;   manualmente en la memoria RAM, el resultado de
;   esta sumatoria, es de 16 bits, los 8 bits mas 
;   significativos estaran en la posicion 216h y los
;   8 bits menos significativos en la posicion 215h
    
    org  100h	        ;Inicia  

    mov ax, 1003h       ;Prepara para interrupcion 10h 
    mov bx, 0           ;para usar 16 colores
    int 10h             ;interrupcion de BIOS

    mov dx, 0705h       ;Fila y columna al escribir
    ;mov bx, 0          ;Limpia bx
    mov bl, 10011111b   ;color de letra y fondo de ella
    mov cx, msg1_size   ;Asigna el tamanho del mensaje 
    mov al, 01b         ;Modo de escritura
    mov bp, msg1        ;mensaje a leer
    mov ah, 13h         ;prepara impresion de pantalla en int10
    int 10h             ;Int 10 e imprime en pantalla el mensaje
    
    mov dx, 0905h       ;Fila y columna al escribir
    ;mov bx, 0           ;
    mov bl, 11111001b   ;Colores de letra y fondo
    mov cx, msg2_size   ;tamaño del mensaje
    mov al, 01b         ;Modo de escritura
    mov bp, msg2        ;Ubicacion del mensaje
    mov ah, 13h         ;prepara impresion de pantalla en int10
    int 10h             ;int 10h e imprime mensaje
         
    mov dx, 0B05h       ;fila y columna para imprimir
    ;mov bx, 0           ;limpia bx
    mov bl, 00011100b   ;colores de letra y fondo
    mov cx, msg3_size   ;tamanho del mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg3        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje

    mov dx, 0D05h       ;fila y columna para imprimir
    ;mov bx, 0           ;limbia bx
    mov bl, 11000001b   ;colores de letra y fondo
    mov cx, msg4_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg4        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje 

    mov dx, 0F05h       ;fila y columna para imprimir
    ;mov bx, 0           ;limbia bx
    mov bl, 01110000b   ;colores de letra y fondo
    mov cx, msg5_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg5        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje

    mov ah, 0           ;prepara para int 16h
    int 10110b          ;int 16h para solicitar
    
    
    ;Seccion solo para debugging 
    ;mov [210h],0xFF
    ;mov [211h],0xFF
    ;mov [212h],0xFF
    ;mov [213h],0xFF
    ;mov [214h],0xFF


    mov ax,0            ;limpia ax
    
    add al,[210h]       ;suma primer numero
    adc ah,0            ;suma con acarreo, AH + 0 + CF
    
    add al,[211h]       ;suma segundo numero + acumulado en AL
    adc ah,0            ;suma con acarreo, AH + 0 + CF
    
    add al,[212h]       ;suma tercer numero + acumulado en AL
    adc ah,0            ;suma con acarreo, AH + 0 + CF
    
    add al,[213h]       ;suma cuarto numero + acumulado en AL
    adc ah,0            ;suma con acarreo, AH + 0 + CF
    
    add al,[214h]       ;suma quinto numero + acumulado en AL
    adc ah,0            ;suma con acarreo, AH + 0 + CF
    
    mov [215h],ax       ; mueve resultado a espacio de memoria 215H
                        
    int 20h             ;Termina ejecucion
    
    
;Variables    
    
msg1:         db "Seccion D07"
msg2:         db "Herrada Jorge "
msg3:         db "Introduce tus datos en la memoria:"
msg4:         db "5 datos de 8 bits en direcciones 0x0210 - 0x0214"
msg5:         db "La suma se almacenara en 16 bits en 0x0215"
msg_tail:
msg1_size = msg2 - msg1
msg2_size = msg3 - msg2
msg3_size = msg4 - msg3
msg4_size = msg5 - msg4
msg5_size = msg_tail - msg5