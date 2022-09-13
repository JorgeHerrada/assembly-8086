    name "p4"    
    
    ;Este programa calcula la potencia 
    ;de un numero de 8bits, almacena 
    ;solo los 16 bits mas significativos
    ;del resultado. Tiene dos variables de entrada
    ;para base y exponente. Resultado se almacena
    ;en variable RES y registro AX
    
    
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
    
    mov dx, 1105h       ;fila y columna para imprimir
    ;mov bx, 0           ;limbia bx
    mov bl, 00001111b   ;colores de letra y fondo
    mov cx, msg6_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg6        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje

    mov ah, 0           ;prepara para int 16h
    int 10110b          ;int 16h para solicitar
    
              
              
    ;Inicia el calculo de la potencia
    
              
    cmp [EXP],0         ;Compara con 0 para caso particular
    jz potencia0        ;Salta a caso especial si Z es 1
    
    ;cmp [EXP],1         ;Compara con 1 para caso particular
    ;jz potencia1 
    
    
    ;Si no es un caso especial, comienza asignando BASE en RES
    mov [RES],0x00h
    mov al,[BASE]
    mov [RES+1],al 
    
    
    mov bl,[EXP]        ;asigna exponente para controlar ciclo
                        
;Ciclo que ocurrira n-1 veces segun sea el valor del exponente EXP                                               
ciclo:
    dec bl              ;decrementa valor de bl para controlar ciclo
    cmp bl,0            ;Compara si bl == 0
    jz  fin             ;segun la comparacion anterior, si F == 1, salta a fin
    call mult           ;de lo contrario, llama subrutina mutl
    jmp ciclo           ;salta al inicio del ciclo 
       
    
    
    
;Variables:

;Modificables
BASE    db 0x03h        ;Base
EXP     db 0x03h        ;Exponente

;No modificables
RES     db 0,0          ;Resultado
AuxH    db 0,0          ;Variable auxiliar en parte alta
AuxL    db 0,0          ;Variable auxiliar en parte baja
    
    
;Mensajes y el calculo de sus longitud:
    
msg1:         db "Seccion D07"
msg2:         db "Herrada Jorge"
msg3:         db "Introduce tus datos en las variables:"
msg4:         db "Guarda la base en variable BASE"
msg5:         db "Guarda exponente en variable EXP"
msg6:         db "Resultado se guarda en variable RES y registro AX"
msg_tail:
msg1_size = msg2 - msg1
msg2_size = msg3 - msg2
msg3_size = msg4 - msg3
msg4_size = msg5 - msg4 
msg5_size = msg6 - msg5
msg6_size = msg_tail - msg6                



;Subrutina de Multiplicacion de 16*8 bits

mult:   
    
    push ax             ;Apila AX
    push bx             ;Apila BX
    
    
    mov al,[RES]        ;prepara parte alta del resultado para multiplicar    
    mov bl,[BASE]       ;prepara base para multiplicar
    mul bl              ;Multiplica base por parte alta y guarda en AX
    mov [AuxH],ah       ;Almacena parte alta del resultado
    mov [AuxH+1],al     ;Almacena parte baja 
    
    
                         
    mov al,[RES+1]      ;prepara parte baja del resultado para multiplicar
    mul bl              ;Multiplica base por parte baja y guarda en AX
    mov [AuxL],ah       ;Almacena parte alta del resultado
    mov [AuxL+1],al     ;Almacena parte baja del resultado
    
    mov al,[AuxL+1]     ;prepara parte baja del resultado para guardar
    mov [RES+1],al      ;guarda parte baja del resultado    
    
    mov al,[AuxL]       ;prepara p/alta de aux bajo para sumar
    mov ah,[AuxH+1]     ;prepara p/baja de aux alto para sumar
    add al,ah           ;suma y almacena en al
    mov [RES],al        ;guarda parte alta del resultado
    
    
    pop bx              ;Recupera valor de BX
    pop ax              ;Recupera valor de AX
    
    ret                 ;fin subrutina, regresa a posicion guardada en pila
    
 
 
    
;Caso particular al elevar base a la 0 potencia
;El resultado es 1    
potencia0:

    mov [RES],0x00h
    mov [RES+1],0x01h 
    jmp fin             ;Salto incondicional a etiqueta fin
                     

;Termina ejecucion del programa cuando el ciclo termina                      
fin:       
    
    ;Mostrar resultado en AX    
    mov ah,[RES]
    mov al,[RES+1] 
    int 20h                      