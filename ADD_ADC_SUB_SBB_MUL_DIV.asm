
org 100h        ; Inicia el programa


MOV AL, 0xAFh     ; Guardamos AFh en AL (1010 1111)
MOV BL, 0x01h     ; Guardamos 01h en BL (0000 0001)


;************ADD***************  

;SUMA

ADD AL, BL      ;Sumamos AL + BL y guardamos en AL
                
                ;  1010 1111     AL
                ;  0000 0001 +   BL
                ;  -----------
                ;  1011 0000     Resultado en AL (B0h)


;************ADC***************   

;SUMA con ACARREO      

stc             ; Bit de acarreo en 1
ADC BL, AL      ; Sumamos Bl + AL + Bit de Acarreo 
                ; y guardamos en BL

                ; 0000 0001     BL
                ; 1011 0000     AL
                ;         1 +   ACARREO
                ; -----------
                ; 1011 0010     Resultado en BL  (B2h)
                

;************SUB***************     

;RESTA

SUB AL,BL       ; Resta Al - BL y almacena en AL
                
                ; 1011 0000     AL
                ; 1011 0010 -   BL
                ; -----------
                ; 1111 1110     Resultado en AL  (FEh)
                                   
                                   
;************SBB***************     

;RESTA con PRESTAMO

MOV AL, 0xB1h   ; Guardamos B1h en AL (1011 0001)
stc             ; Bit de acarreo en 1
SBB BL, AL      ; Resta BL - AL - C (acarreo) 
                ; y almacena en BL
               
                ; 1011 0010     BL
                ; 1011 0001     AL
                ;         1 -   C
                ; -----------
                ; 0000 0000     Resultado en BL


;************MUL***************  

;MULTIPLICACION sin signo      

; PARA MUL de 8x8 bits

MOV AL, 0xABh   ; Guardamos ABh en AL (1010 1011)
MOV BL, 0x09h   ; Guardamos 09h en BL (0000 1001)

MUL BL          ; Multiplica BL * lo que hay en AL
                ; Lo guarda en AX       
                
                ; AX = AL * BL = 0x0603h
                
                ; Se enciende bandera C y O 
                ; porque la mul, toma todo AX
                
; PARA MUL de 16x16 bits

MOV AX, 0xABCDh ; Guardamos ABCDh en AX (1010 1011 1100 1101)
MOV BX, 0xFF09h ; Guardamos FF09h en BX (1111 1111 0000 1001)

MUL BX          ; Multiplica BX * lo que hay en AX
                ; Lo guarda en DX:AX       
                
                ; DX:AX = AX * BX = 0xAB26 3D35h
                
                ; Se enciende bandera C y O 
                ; porque la mul, toma todo DX:AX


;************DIV***************    

;DIVISION     

; Para DIV de 16/8 bits      

MOV AX, 0xACh   ; Guardamos ACh en AX (1010 1100)
MOV BL, 0x05h   ; Guardamos 05h en BL (0000 0101)

DIV BL          ; Divide AX entre BL
                ; Guarda el cociente en AL
                ; Y el resto en AH   
                
                ; AL = 22h (cociente)
                ; AH = 02h (resto)
                
                
; Para DIV de 32/16  bits      

                         
; Guardando 0x0001FFFFh por separado en los dos registros
; en DX la parte mas significativa
                         
MOV AX, 0xffffh ; Guardamos FFFFh en AX (1111 1111 1111 1111)
MOV DX, 0x0001h ; Guardamos 0001h en DX (0000 0000 0000 0001)

MOV Bx, 0x001Fh ; Guardamos 0005h en BX (0000 0000 0000 0101)

DIV BX          ; Divide DX:AX entre BX
                ; Guarda el cociente en AX
                ; Y el resto en DX   
                
                ; AX = 1084h (cociente)
                ; DX = 0003h (resto)
                

ret             ; Fin del programa




