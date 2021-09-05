
org 100h        ;Aqui inicia el programa

mov AH, 0xAAh   ;guardamos 0xAAh en AH (1010 1010)
mov BH, 0xFFh   ;guardamos 0xFFh en BH (1111 1111)

;*******NOT*********

not AH          ;invertimos con NOT, como comp a 1
                ;(0101 0101)
                
;*******NEG*********
                
neg BH          ;NEG de BH, como comp a 2  
                ;(0000 0001)

;*******OR**********
          
or BH,AH        ;aplicamos compuerta OR, bit a bit
                ;BH deberia conservar: (0101 0101) 

mov BH, 0xFAh   ;Guardamos 0xFFh en BH (1111 1010)
              

;*******AND*********

and AH,BH       ;aplicamos compuerta AND, bit a bit
                ;AH deberia conservar: (0101 0000) 
                
;*******XOR*********                

xor AH,AH       ;aplicamos compuerta XOR, bit a bit
                ;AH deberia quedar: (0000 0000)

                
xor BH,BH       ;aplicamos compuerta XOR, bit a bit
                ;BH deberia quedar: (0000 0000)
                          

ret




