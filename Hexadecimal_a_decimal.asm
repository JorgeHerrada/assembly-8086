    name "p5"  
    include 'emu8086.inc'  
             
    ;Convierte hexadecimal introducido por usuario a decimal
    ;y lo imprime en pantalla
                 
    ;PASOS:         
    ;Este programa lee en pantalla un numero 
    ;hexadecimal de 16 bits, lo convierte de su
    ;valor ascci a su valor hexadecimal, despues
    ;lo convierte a numero bcd para posteriormente
    ;convertirlo a su valor ascci e imprimirlo en 
    ;pantalla
     
     
;***********INICIO********************************************** 
     
        org     100h	        ;Inicia  
                                
        call    Instrucciones   ;Imprime instrucciones    
        
        GOTOXY  0x05,0x13       ;Cursor a coordenadas (5h,13h)
        PRINT   'Entrada: '     ;Imprime string 
        call    Leer            ;Lee, convierte a hexa
                                ;y guarda en num16
        PRINT   ' Hexadecimal ' ;Imprime string               
    
        call    Hexa_bcd        ;convierte de hexa a bcd
        
        call    bcd_ascii       ;convierte bcd a valor ascii
    
        GOTOXY  0x05,0x14       ;Cursor a coordenadas (5h,15h)                        
        PRINT   'Salida: '      ;Imprime string
                                                         
        call    Imp_resultado   ;imprime resultado                                                         
        PRINT   ' Decimal'      ;Imprime string
        GOTOXY  0x05,0x16       ;Cursor a coordenadas (5h,15h)                        
        PRINT   'ADIOS '        ;Imprime string
       
        mov     al,0            ;al = 0 para terminar ejecucion   
        int     0x20h           ;interrupcion 20h termina programa    


;*******Leer numero hexadecimal en pantalla ********************+
Leer:    
;Lee en pantalla, convierte a hexa
;guarda en variable num16 y hace que
;DI apunte a ello 

        xor ax,ax           ;limpia AX
        lea     di,cadnum   ;DI apunta a cadnum
        lea     si,n16      ;SI apunta a n32  
        mov     dx,5        ;DX = entradas a leer en pantalla(incluye ENTER)
        call    get_string  ;llama subrutina para obtener 
                            ;strings en pantalla y se guardan
                            ;en posicion DS:DI

        mov     al,[di]     ;AL = (DI)inicio de cadena leida
        call    numbyte     ;subrutina para conv numero ascii a num
        mov     al,[b]      ;AL = b (resultado)
        mov     [si],al     ;byte convertido se guarda en SI que apunta a num16    
        inc     si          ;incrementa SI
        inc     di          ;incrementa DI
        mov     al,[di]     ;AL = DI siguiente byte a convertir
        call    numbyte     ;subrutina para conv valor ascii a num
        mov     al,[b]      ;AL = b (resultado)
        mov     [si],al     ;Byte convertido se guarda en SI que apunta a num16 
        
        lea     di,n16      ;DI apunta a n16 (donde se almaceno el resultado)
        
        ret
        
        
numbyte:  
;Convierte el numero en valor ascii a num hexa con mismo valor
;primero convierte parte alta del byte, multiplica por 16 para
;desplazar a la izquierda, convierte parte baja del byte y la 
;suma con parte alta, resultando un byte con valor real, no ascii
        call    asc2num     ;subrutina convierte ascii a numero
        mov     bl,16       ;bl = 16  (para desplazar a la izquierda)
        mul     bl          ;AX = AL*BL 
        mov     [b],al      ;b = AL
        inc     di          ;DI = DI+1 
        mov     al,[di]     ;AL = segunda posicion del byte
        call    asc2num     ;subrutina convierte ascii a numero    
        add     al,[b]      ;AL = AL + b
        mov     [b],al      ;b = AL
        ret                 ;fin subrutina
        
asc2num:  
;Resta al numero con valor hexa-ascci 
;dependiendo si es entero, min o mayus
        sub     al,48       ;substrae 48  (enteros)
        cmp     al,9        ;para ver si esta entre 0-9
        jle     f_asc       ;salta si es <= 9
        sub     al,7        ;substrae 7 mas (mayusculas)
        cmp     al,15       ;para ver si esta entre 0-15
        jle     f_asc       ;salta si es <= 15
        sub     al,32       ;substrae 32 mas (minusculas)

f_asc:  
        ret                 ;termina subrutina


;********Convierte Hexadecimal a BCD **************************;
Hexa_bcd:
;Converte el numero hexadecimal en bcd 
                                                                
        lea     si,n16      ;SI apunta a direccion de n16
        lea     di,num      ;DI apunta a direccion de num    
        mov     cx,2        ;CX = 2 preaparando para loop
        call    copy_arrays ;subrutina para copiar 
        lea     di,bcd      ;DI apunta a direccion de bcd
        add     di,4        ;DI suma 4 para apuntar al 
                        ;ultimo byte del arreglo                                                               
            
ciclo:
        mov     al,10       ;AL = 10
        mov     [aux],al    ;aux = AL
        call    div16       ;llama subrutina
        jz      f_ciclo     ;si todo fue cero,salta a fin_ciclo    
        mov     al,[resi]   ;AL = residuo final de num
        mov     [di],al     ;agrega residuo como digito a bcd 
        dec     di          ;decrementa DI
        push    di          ;guarda DI en pila
        lea     si,cocnte   ;DI apunta a cociente
        lea     di,num      ;DI apunta a num
        mov     cx,2        ;cx para control del ciclo
        call    copy_arrays ;subrutina copia cocnte en num
        pop     di          ;recupera DI de pila
        jmp     ciclo       ;reinicia ciclo            
    

f_ciclo:
        mov     al,[resi]   ;AL = residuo final de num
        mov     [di],al     ;agrega residuo como digito a bcd
        
        ret

     
     
     
     
; Rutina que copia el arreglo indicado por el registro SI,
; Al arreglo indicado por el arreglo DI. El numero de 
; elementos a copiar, se indican en el registro CX
copy_arrays:            
        push    ax      ;Guarda valores en pila
        push    cx      ;para recuperarlos
        push    si      ;posteriormente
        push    di      
copy:                   
        mov     al,[si] ;AL = valor del espacio al que apunta SI
        mov     [di],al ;espacio al que apunta DI = AL
        inc     si      ;incrementa SI y DI    
        inc     di
        loop    copy    ;decrementa CX y cuando es 0 termina loop                     
        
        pop     di      ;recupera valores de pila
        pop     si      ;guardados previamente
        pop     cx
        pop     ax
        ret             ;termina subritina y vuelve a 
                        ;direccion guardad en pila    

div16:
        push    ax          ;AX a la pila
        mov     ah,0        ;ah = 0
        mov     al,[num]    ;al = primera posicion de num
        test    [aux],0xff  ;PuertaLogica aux_AND_FFh
        jz      div_zero    ;si es cero, salta
        div     [aux]       ;divide, AL = AX/aux (residuo en AH)
        mov     [cocnte],al  ;cociente = resultado
        mov     al,[num+1]  ;al = segunda posicion de num
        div     [aux]       ;divide, AL = AX/aux (residuo en AH)
        mov     [cocnte+1],al;cociente+1 = resultado      
        
        mov     [resi],ah   ;guardamos residuo final
        clc                 ;limpia acarreo 
        
        ;Testeo con compuerta AND
        test    [cocnte],0xff       ;Usa AND con todas 
        jnz     no_igual            ;las partes de cociente
        test    [cocnte+1],0xff     ;si no es cero, salta 
        jnz     no_igual            ;a subrutina no_igual
        
no_igual:                        
        pop     ax          ;recupera AX de pila
        ret         

div_zero:                   
;Control de div entre cero    
        mov     al,0xff     
        mov     [cocnte],al
        mov     [cocnte+1],al
        mov     [resi],al
        stc   
        pop     ax
        ret
     
     

;************BCD a ASCII*****************************************    
bcd_ascii:
;convierte numeros bcd en sus valores ascii
        
        ;suma 48 decimal para cambiar a representacion ascii
        add     [bcd],48d
        add     [bcd+1],48d
        add     [bcd+2],48d
        add     [bcd+3],48d
        add     [bcd+4],48d     
        
        ret     ;fin subrutina  
        
        
        
;********IMPRIMIR RESULTADO***********************************
Imp_resultado:   

        ;***NOTA**+**
        ;preguntar al profe: como distingue el procesador
        ;cuando es un numero o un string?
                
        push    ax          ;guarda ax en pila
                                
        lea     di,ascii    ;DI apunta a variable ascii
        
        mov     al,[bcd]    ;movemos digito a digito
        mov     [di],al     ;los valores del resultado
        mov     al,[bcd+1]  ;de variable de tipo 'entero'    
        mov     [di+1],al   ;a variable tipo 'string'    
        mov     al,[bcd+2]  ;para poder imprimirlo
        mov     [di+2],al   ;usando la funcion 
        mov     al,[bcd+3]  ;print_string
        mov     [di+3],al  
        mov     al,[bcd+4]
        mov     [di+4],al  
        
        lea     si,ascii    ;SI apunta a variable string
        
        call    print_string;imprime sting pantalla 
                            ;desde DS:SI
        
        
        pop     ax          ;recupera ax de la pila
        
        ret                 ;termina subrutina
                                                   
             
;***********VARIABLES********************************************
;variables para subrutina 'Leer'
cadnum      db      "00000"
n16         db      ?,?
b           db      ?
                                
;variables para subrutina 'Hexa_bcd'
bcd         db      0,0,0,0,0   ;se guardara cada numero decimal
num         db      0,0         ;para comparacion                     
resi        db      0           ;para guardad residuo
cocnte      db      0,0         ;guarda cociente
aux         db      0           ;auxiliar   

ascii       db      "00000",0   ;el cero al final se usa como 
                                ;caracter nulo para la funcion
                                ;print string    





;*********Imprimir instrucciones en pantalla******************
Instrucciones:                                
    mov ax, 1003h       ;Prepara para interrupcion 10h 
    mov bx, 0           ;para usar 16 colores
    int 10h             ;interrupcion de BIOS

    mov dx, 0705h       ;Fila y columna al escribir
    mov bl, 10011111b   ;color de letra y fondo de ella
    mov cx, msg1_size   ;Asigna el tamanho del mensaje 
    mov al, 01b         ;Modo de escritura
    mov bp, msg1        ;mensaje a leer
    mov ah, 13h         ;prepara impresion de pantalla en int10
    int 10h             ;Int 10 e imprime en pantalla el mensaje
    
    mov dx, 0905h       ;Fila y columna al escribir
    mov bl, 11111001b   ;Colores de letra y fondo
    mov cx, msg2_size   ;tamaño del mensaje
    mov al, 01b         ;Modo de escritura
    mov bp, msg2        ;Ubicacion del mensaje
    mov ah, 13h         ;prepara impresion de pantalla en int10
    int 10h             ;int 10h e imprime mensaje
         
    mov dx, 0B05h       ;fila y columna para imprimir
    mov bl, 00011100b   ;colores de letra y fondo
    mov cx, msg3_size   ;tamanho del mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg3        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje

    mov dx, 0D05h       ;fila y columna para imprimir
    mov bl, 11000001b   ;colores de letra y fondo
    mov cx, msg4_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg4        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje 

    mov dx, 0F05h       ;fila y columna para imprimir
    mov bl, 01110000b   ;colores de letra y fondo
    mov cx, msg5_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg5        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje 
    
    mov dx, 1105h       ;fila y columna para imprimir
    mov bl, 00001111b   ;colores de letra y fondo
    mov cx, msg6_size   ;tamaño de mensaje
    mov al, 01b         ;modo de escritura
    mov bp, msg6        ;ubicacion del mensaje
    mov ah, 13h         ;prepara impresion en int10h
    int 10h             ;int 10h e imprime mensaje

    mov ah, 0           ;prepara para int 16h
    int 10110b          ;int 16h para solicitar     
                                                  
    ret                 ;termina subrutina de impresion
                        ;de instrucciones                                              
    
    
    
;********Mensajes y el calculo de sus longitudes: ********************
    
msg1:         db "Seccion D07"
msg2:         db "Herrada Jorge"
msg3:         db "Codigo: #########:"
msg4:         db "Ingresa un numero hexadecimal de 16 bits y presiona ENTER"
msg5:         db "16 bites son 2 bytes por lo tanto 4 caracteres"
msg6:         db "El numero se convierte a decimal y se despliega en pantalla"
msg_tail:
msg1_size = msg2 - msg1
msg2_size = msg3 - msg2
msg3_size = msg4 - msg3
msg4_size = msg5 - msg4 
msg5_size = msg6 - msg5
msg6_size = msg_tail - msg6     



;******DEFINICIONES DEL EMU8086.inc***************************

DEFINE_GET_STRING 
DEFINE_PRINT_STRING 
        END  