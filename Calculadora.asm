    name "p6"  
    include 'emu8086.inc'  
    
    org     100h	            ;Inicia   
    jmp     Main                ;salta al main del programa
    
    ;DESCRIPCION DEL PROGRAMA    
    
         
         
         
;***********VARIABLES************************************************************************

linea       DB      23 DUP (0)  ;Arreglo de cadena ingresada por usuario
t_linea     DB      0           ;Tamanho de cadena
salir       DB      0           ;Bandera para terminar un ciclo
datos       DW      11 DUP (0)  ;arreglo que guarda los datos separados
opers       DB      11 DUP (0)  ;arreglo que guarda los operadores separados
base        DB      16          ;base numerica 

pos_dato    DB      0           ;posicion del dato a trabajar
pos_oper    DB      0           ;posicion del operador a trabajar

datos0      DW      11 DUP (0)  ;guarda parcialmente los datos
datos1      DW      11 DUP (0)  ;guarda parcialmente los datos
ops0        DB      11 DUP (0)  ;guarta parcialmente los operandos
ops1        DB      11 DUP (0)  ;guarta parcialmente los operandos     

n_num       DB      0           ;cantidad de numeros en datos
n_ops       DB      0           ;cantidad de operadores    

incremento  DW      0           ;incremento para numeros de 8 y 16 bits   

indice_op   DB      0           ;indice donde la operacion ocurre

result      DW      0           ;Resultado

    
    
    
;***********INICIO****************************************************************************
Main:
         
                                
        call    Instrucciones       ;Imprime instrucciones  
        
        call    clear_screen        ;limpia pantalla de instrucciones
        
        call    Lectura_Separacion  ;Lee la cadena y separa los numeros de los operadores
        
        call    num_datos           ;guarda numero de datos
         
        lea     si,datos
        lea     di,datos0           
        mov     incremento,2
        call    copiar_datos        ;copia numeros de SI a DI
                                                             
        lea     si,opers
        lea     di,ops0
        mov     incremento,1
        call    copiar_datos        ;copia numeros de SI a DI
                                                             
        call    Operaciones         ;Revisa jerarquia y resuelve operaciones
        
        
        
        
        
        
        
        int 20h                 ;fin del programa    
    

;***************REVISA JERARQUIA Y RESUELVE OPERACIONES**************************************
Operaciones:                                 

        lea     SI,datos0    ;SI apunta a datos
        lea     DI,ops0    ;DI apunta a operadores
         
        ;Multiplicaciones y divisiones 
        xor     cx,cx           ;limpia cx
        mov     cl,n_num        ;asigna numero de datos    
        inc     cl              ;cl++
        call    find_div_mul   ;encuentra y resuelve divisiones o multiplicaciones
        
        ;sumas y restas
        xor     cx,cx           ;limpia cx
        mov     cl,n_num        ;asigna numero de datos    
        inc     cl              ;cl++
        call    find_sum_res    ;encuentra y resuelve sumas y restas
        
        
        ret
        
find_div_mul: 
        push    si          ;apila
        push    di
                   
c_find_div_mul:  
        mov     ah,[DI]
        cmp     ah,47       ;/ division?
        je      division    ;si es igual, salta a realizar division
        cmp     ah,42       ;* multiplicacion?
        je      mult        ;si es igual, salta a realizar multiplicacion
        
        inc     si          ;incrementa para ciclo
        inc     di
        
        inc     indice_op
        
        loop    c_find_div_mul ;ciclo para encotrar y resolver mul/div
        
        pop     di           ;recupera
        pop     si  
        
        ret
        
find_sum_res:
        push    si          ;apila
        push    di
        
c_find_sum_res:  
        mov     ah,[DI]          
        cmp     ah,43       ;+ suma?
        je      suma        ;si es igual, salta a realizar suma 
        cmp     ah,45       ;- resta? 
        je      resta       ;salta a resta    
        
        inc     si          ;incrementa para ciclo
        inc     di
        
        loop    c_find_sum_res ;ciclo para encotrar y resolver mul/div
        
        pop     di           ;recupera
        pop     si  
                                                          


        ret
        

      
        
division:
        PRINT   'Division ' 
        
        push    si
        push    di 
        push    ax
        push    cx 
        push    dx
        
        xor     dx,dx
        mov     ax,[si] ;dividendo
        inc     si
        mov     bx,[si] ;divisor
               
        div     BX      ;AX = DX:AX/BX 
        
        
        call    reasignacion 
        
        lea     si,datos1
        lea     di,datos0           
        mov     incremento,2
        call    copiar_datos        ;copia numeros de SI a DI      
         

        pop     dx       
        pop     cx       
        pop     ax
        pop     di
        pop     si 

        
        
        jmp fin_operacion

        
mult:             
        PRINT   'Multiplicacion ' 
        jmp fin_operacion  

suma:                  
        PRINT   'Suma '            
        jmp fin_operacion  

resta:       
        PRINT   'Resta '           
        jmp fin_operacion         
                                
fin_operacion:
        inc     di
        inc     si
        dec     cx
        jmp     c_find_div_mul                                
                     
;**********REASIGNACION***************************************
reasignacion:

        lea     si,datos0
        lea     di,datos1   
        
c_reasignacion0:
        cmp     indice_op,0
        je      sig
        mov     bx,[si]
        mov     [di],bx
                       
        inc     si
        inc     di                          
        dec     indice_op
        jmp     c_reasignacion0                          
        
sig:
        mov     [di],ax
        
        inc     si      ;incremento doble en si
        inc     si      ;para ignorar el operaror involucrado
        inc     di      

c_reasignacion1:

        mov     bx,[si]  
        cmp     bx,0
        je      fin_reasignacion
        mov     [di],bx
                       
        inc     si
        inc     di                          
        dec     indice_op
        jmp     c_reasignacion1
                          
                          
fin_reasignacion:

        ret
        
        
        
        
                       
;copia los datos a los que apunta SI a datos0, y los apunta di a ops0
copiar_datos:
        push    ax
        push    di
        push    si
        push    cx
        
        mov     cl,n_num 
        inc     cl    
         
        
c_copiar_datos: 
        
        mov     ax,[si]
        mov     [di],ax 
        
        add     si,incremento
        add     di,incremento
        
        
        loop    c_copiar_datos
          
        pop     cx                  
        pop     si
        pop     di
        pop     ax    
        
        ret                       

;****************CALCULA NUMERO DE DATOS Y OPERADORES***************************
num_datos:
        push    di
        push    cx
        push    ax
        
        mov     cx,0
        
        lea     di,opers
        
c_num_datos: 

        inc     cx
        mov     ax,[di]
        cmp     ax,0
        je      fin_c_num_datos 
        inc     di
        jmp     c_num_datos

fin_c_num_datos:        
        
        mov     n_num,cl
        dec     cl
        mov     n_ops,cl
                          
        pop     ax
        pop     cx
        pop     di
        
        ret
        




        
;****************LECTURA Y SEPARACION DE CARACTERES/OPERADORES********************************       
Lectura_Separacion:   
        xor     ax,ax       ;Limpia ax y dx
        xor     dx,dx
        mov     cx,21       ;tamanio de cadena a leer, incluye ENTER
        lea     si,linea    ;SI apunta al arreglo que almacenara la cadena.
        call    leecad      ;llama a leer cadena
        lea     di,datos    ;DI apunta al arreglo de DATOS
        lea     dx,opers    ;DX = posicion de memoria del arreglo de operadores
        mov     al,[si]     ;AL = al valor al que apunta SI que es el primer 
                            ;valor del arreglo que almacena la cadena leida
        cmp     al,0        ;compara AL == 0
        je      fin         ;Salta a fin si es true
        call    asc2num     ;subrutina para pasar de ascci a valor HEXA
        cmp     al,0fh      ;comp si valor HEXA > F
        ja      c_err       ;Si es asi, hay error de caracter y salta
        mov     [di],ax     ;agrega valor hexa al arreglo de datos 
        
;************Ciclo principal*****************************************************
nvocar: 
        inc     si          ;SI ++(apunta a siguiente elemento)
        mov     al,[si]     ;al = elemento de cadena    
        test    al,0FFh     ;compara con FFh
        je      fin         ;si AL = 00, salta
        call    asc2num     ;Subrutina para pasar de ascii a hexa
        cmp     al,0fh      ;compara si al > F
        ja      leeop       ;si true, salta a leer operando
        push    dx          ;Apila DX y AX
        push    ax
        mov     ax,[di]     ;AX = sig pos en arreglo datos
        mov     bl,[base]   ;BL = valor de var BASE
        mul     bx          ;DX:AX = AX * BX
        mov     [di],ax     ;posicion en arreglo datos = AX
        pop     ax          ;recupera AX y DX
        pop     dx
        add     [di],ax     ;Arreglo de datos =+ AX
        jmp     nvocar      ;ciclo


;*******SUBRUTINA LEE OPERANDO Y GUARDA EN ARRELO DE OPERADORES*******************
leeop:  
        push    di          ;guarda DI en pila
        mov     di,dx       ;DI = DX (apunta a arreglo de operadores)
        mov     al,[si]     ;AL = valor ascii
        cmp     al,'*'      ;comp multiplicacion
        je      op0         ;salta a op 0 si es igual
op1:    cmp     al,'/'      ;comp division
        je      op0         ;salta a op 0 si es igual
op2:    cmp     al,'-'      ;comp resta
        je      op0         ;salta a op 0 si es igual
op3:    cmp     al,'+'      ;comp suma    
        jne     c_err       ;si no es igual salta a c_err
op0:    mov     [di],al     ;arreglo de operadores = AL (operador encontrado)
        inc     di          ;DI++ (posicion en arreglo de operadores)    
        mov     dx,di       ;dx = DI
        pop     di          ;recupera DI
        inc     di          ;incrementa DI
        inc     di          ;incrementa DI
        jmp     nvocar      ;salto a nvocar    

;***********SUBRUTINA PARA CHAR NO VALIDO != 0-9|a-f|A-F|+-*/*********************        
c_err:   
        ;Imprime mensaje para caracter no valido
        ;
        push    di          ;apila DI
        lea     di,msg2     ;di apunta posicion de mensaje
        mov     cx,msg8_size;tamanho de mensaje
        mov     dh,5        ;coordenadas    
        mov     dl,0        ;coordenadas
        call    imprime     ;llama a imprimir
        pop     di          ;recupera DI


;***********FIN DE LECTURA Y SEPARACION DE CARACTERES*****************************        
fin:        
        xor     ax,ax
        ret
        ;int     20h


;*****SUBTURINAS LEEN CARACTERES INGRESADOS POR PANTALLA**************************
leecad: 
        push    di              ;guarda DI, SI, CX y AX en pila
        push    si
        push    cx 
        push    ax 
        mov     [t_linea],cl    ;guarda tamanho de linea, estaba en cl
        
ntecla: 
        jcxz    enc             ;CX = 0, salta si TRUE
        mov     ah,0            ;ah = 0 modalidad para INT 16h
        int     16H             ;Lee caracter en pantalla sin echo y guarda en AL
        mov     [si],al         ;Guarda valor escrito en pantalla
                                ;en variable a la que apunta SI
        inc     si              ;SI++
        dec     cx              ;CX--
        cmp     al,1BH          ;compara con ascii de ESC
        jne     sigue           ;Si no es igual, salta a "sigue"
        mov     [salir],1       ;salir = 1 para terminar ciclo
        jmp     FINCAD          ;salto incondicinal a FINCAD
        
sigue:  
        cmp     al,0DH          ;compara con retorno de carro
        je      FINCAD          ;si son iguales, salta a FINCAD    
        cmp     al,08H          ;compara con retroceso(borrar)
        je      borra           ;si con iguales, salta a borrar
        mov     ah,0EH          ;ah = 0Eh modalidad para INT 10h
        int     10H             ;Escribe caracter guardado en AL
        jmp     ntecla          ;salto incondicional "ntecla"

;*****SUBRUTINA PARA BORRAR, RESTABLECER VALORES*********************
borra:  
        dec     si
        dec     si
        inc     cx
        inc     cx
        mov     ah,0eH
        int     10H
        mov     al,20H
        int     10H
        mov     al,08
        int     10H
        jmp     ntecla


;*****SUBRUTINA CONTROLA SI HAY MAS CARACTERES DE LOS PERMITIDOS**********  
;Escribe 1er mensaje, salta de linea
;Limpia variables
;Escribe 2do mensaje, salta de linea
;borra la linea donde se va a leer la cadena
;coloca cursor al incio de esa linea
;prepara para ciclo de lectura de chars en pantalla
enc:    lea     di,msg9         ;apunta a posicion del mensaje
        mov     cx,msg9_size    ;tamanho del mensaje
        mov     dh,0            ;coordendas
        mov     dl,0
        call    imprime         ;IMPRIME mensaje
        mov     dh,03           ;coordenadas
	    mov     dl,0
	    mov     bh, 0
	    mov     ah, 2
	    int     10h             ;cambia posicion del cursor
        lea     si,linea        ;SI apunta a variable
        mov     cx,21           ;tamanho a leer
        call    limpia          ;limpia variables
        lea     di,msg1         ;Escribe una linea, maximo 20 caracteres
        mov     cx,msg7_size    ;tamanho del mensaje
        mov     dh,1            ;coordenadas
        mov     dl,0
        call    imprime         ;imprime mensaje
        mov     dh,03           ;coordenadas
	    mov     dl,0
	    mov     bh, 0
	    mov     ah, 2
	    int     10h             ;cambia posicion del cursor
	    call    BorraLinea      ;borra linea por si hay obstruccion
        mov     dh,03           ;Corrdenadas
	    mov     dl,0
	    mov     bh, 0
	    mov     ah, 2
	    int     10h             ;cambia posicion del cursor
        lea     si,linea        ;SI apunta a var linea
        mov     cx,21           ;numero para ciclo
        jmp     ntecla          ;salta a volver a leer cadena
  
  
;******SUBRUTINA PARA CUANDO SE INGRESA enter EN LA CADENA*************
FINCAD: 
        dec     si              ;SI-- regresa SI 
        mov     [si],0          ;borra ultima posicion escrita
        mov     ah,0eH          ;AH = 0Eh para int 10h
        mov     al,0dH          ;caracter a imprimir
        int     10H             ;imprime lo guardado en AL (retorno de carro)
        mov     al,0aH          ;caracter a imprimir
        int     10H             ;imprime lo guardado en AL (nueva linea)
        sub     [t_linea],cl    ;t_linea =- cl: resta los caracteres escritos
                                ;del numero de c. posibles
        pop     ax              ;recupera valores de la pila 
        pop     cx
        pop     si
        pop     di 
        ret                     ;fin de subrutina
             


;********SUBRUTINA  PARA IMPRIMIR MENSAJES *****************************
;DI apunta a la direccion de memoria del mensaje            
;CX tiene el tamanho del mensaje
;las coordenadas ya estan en DX
imprime:
       	push    bx              ;APILA BX,AX Y ES
       	push    ax
       	push    es
       	mov     al,1            ;PARAMETROS DE IMPRESION
    	mov     bh,0
    	mov     bl,0011_1011b
    	push    cs              ;APILA CS
    	pop     es              ;RECUPERTA ES
    	mov     bp,di           ;BP APUNTA A DIRECCION DEL MENSAJE
    	mov     ah,13h          
    	int     10h             ;imprime
    	pop     es              ;recupera de la pila
    	pop     ax
    	pop |   bx
    	ret

;******SUBRUTINA BORRA CARACTERES EN LINEA PARA VOLVER A LEER**************    	
BorraLinea:
        push    ax
        push    bx
        push    cx
        mov     cx,21    ;debe ser igual al limite de caracteres
        mov     al,32
        mov     bh,0
        mov     ah,0aH
        int     10H
        pop     cx
        pop     bx
        pop     ax
        ret 

;******SUBRUTINA LIMPIA LAS VARIABLES****************************        
limpia: push    si
        push    cx
l_lim:  mov     [si],0
        inc     si
        loop    l_lim
        pop     cx
        pop     si
        ret	        
        
; Subrutina que resta valores convertir
; representacion ascii de un numero, al
; valor hexadecimal correspondiente
asc2num:
        sub     al,48   ;resta para numeros 0-9
        cmp     al,9    ;compara si <= 9
        jle     f_asc   ;si es true salta    
        sub     al,7    ;resta para A-F
        cmp     al,15   ;compara si <= 15
        jle     f_asc   ;si es true salta
        sub     al,32   ;resta para a-f

f_asc:                  
        ret             ;fin de subrutina



    
    
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
    
msg1:       db      "Seccion D07 - Herrada Serrano Jorge Luis - 211721923"
msg2:       db      "Ingresa una ecuacion aritmetica en base HEXA"
msg3:       db      "Maximo 20 caracteres y presiona ENTER al final"
msg4:       db      "Operaciones permitidas: suma, resta, mult y div "
msg5:       db      "Maximo de 16 bits(FFFF) cada numero"
msg6:       db      "El resultado se imprime en pantalla al finalizar" 
msg7:       db      "Escribe una linea, maximo 20 caracteres",0dH,0aH
msg8:       db      "Has ingresado un caracter no valido",0dH,0aH
msg9:       db      "Has excedido el numero de caracteres",0dH,0aH 
msg_tail:
msg1_size = msg2 - msg1
msg2_size = msg3 - msg2
msg3_size = msg4 - msg3
msg4_size = msg5 - msg4 
msg5_size = msg6 - msg5  
msg6_size = msg7 - msg6  
msg7_size = msg8 - msg7  
msg8_size = msg9 - msg8  
msg9_size = msg_tail - msg9


;******DEFINICIONES DEL EMU8086.inc***************************

DEFINE_GET_STRING 
DEFINE_PRINT_STRING    
DEFINE_CLEAR_SCREEN
        END  