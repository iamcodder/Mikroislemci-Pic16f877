#include <p16f877.inc>

sayac1				EQU	0X20
sayac2				EQU	0X21
yirmi_sayac			EQU	0X22
segmentsayicisag	EQU	0X23
segmentsag			EQU	0X24
segmentsol			EQU	0X25
segmentsayicisol		EQU	0X26
gecikme1			EQU	0X27
gecikme2			EQU	0X28
yanmabiti			EQU	0X29

ORG	0X00	
goto	Setup

ORG	0X04
goto	Kesme

Setup

BANKSEL	OPTION_REG			;PSA 256
Bcf			OPTION_REG,T0CS		
Bcf			OPTION_REG,PSA
Bsf			OPTION_REG,PS2
Bsf			OPTION_REG,PS1
Bsf			OPTION_REG,PS0

BANKSEL	INTCON
Bsf			INTCON,PEIE
Bsf			INTCON,GIE
Bsf			INTCON,T0IE
Bcf			INTCON,T0IF

BANKSEL	TMR0					;50MS de bir kesme
Movlw		D'61'					;verecek bunu 20 kere 
Movwf		TMR0					;yaptýr 1 sny elde edersin

BANKSEL	TRISB
CLRF		TRISB
BANKSEL	PORTB
CLRF		PORTB
BANKSEL	ADCON1
Movlw		0x06
Movwf		ADCON1
BANKSEL	TRISA
CLRF		TRISA
BANKSEL	PORTA
MOVLW		0X01
MOVWF		PORTA

CLRF		sayac1	
CLRF		sayac2		
CLRF		yirmi_sayac	
CLRF		segmentsayicisag
CLRF		segmentsag	
CLRF		segmentsol	
CLRF		segmentsayicisol	
CLRF		gecikme1
CLRF		gecikme2
Movlw		0x01
Movwf		yanmabiti
goto		SolSegment


SolSegment
RLF			yanmabiti,f		;soldaki 7 segment
Movfw		yanmabiti
Movwf		PORTA
Movfw		segmentsol
Movwf		PORTB
call			gecikme10ms

SagSegment
RRF		yanmabiti,f		;sagdaki 7 segment
Movfw		yanmabiti
Movwf		PORTA
Movfw		segmentsag
Movwf		PORTB
call			gecikme10ms
goto		SolSegment


Kesme
BANKSEL	INTCON
Bcf			INTCON,PEIE
Bcf			INTCON,GIE

call			yirmi_kontrol

Bcf			INTCON,T0IF
Bsf			INTCON,PEIE
Bsf			INTCON,GIE		
BANKSEL	TMR0
Movlw		D'61'
Movwf		TMR0
retfie


yirmi_kontrol					;50 ms kesme 20 defa mý gelmis
Incf			yirmi_sayac,f
Movlw		D'20'
Subwf		yirmi_sayac,w
Btfsc		STATUS,Z
call			arttirsag
return


arttirsag
CLRF		yirmi_sayac		;sagdaki sayiyi artýk 7 segmentte
Bcf			STATUS,Z		;yanan
INCF		segmentsayicisag,f
Movlw		D'10'
Subwf		segmentsayicisag,w
Btfsc		STATUS,Z
call			arttirsol
Movfw		segmentsayicisag
call			Lookup
Movwf		segmentsag
return

arttirsol
Bcf			STATUS,Z		;soldaki sayiyi artýk 7 segmentte
CLRF		segmentsayicisag	;yanan
INCF		segmentsayicisol,f

Movlw		0x06
Subwf		segmentsayicisol,w
Btfsc		STATUS,Z
Clrf			segmentsayicisol
Movfw		segmentsayicisol
Call 		Lookup
Movwf		segmentsol
return

Lookup
Addwf	PCL,F
Retlw	b'00111111'	
Retlw	b'00000110'	
Retlw	b'01011011'	
Retlw	b'01001111'	
Retlw	b'01100110'	
Retlw	b'01101101'  
Retlw	b'01111101' 
Retlw	b'00000111'
Retlw	b'01111111'
Retlw	b'01101111'


gecikme10ms
Movlw		D'58'
Movwf		gecikme1

gecikme10ms2
Movlw		D'58'
Movwf		gecikme2

gecikme10ms3
Decfsz		gecikme2,f
goto		gecikme10ms3
Decfsz		gecikme1,f
goto		gecikme10ms2
return


END