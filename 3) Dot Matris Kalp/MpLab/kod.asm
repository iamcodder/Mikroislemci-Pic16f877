#include <p16f877.inc>

sayac1		EQU		0X20
sayac2		EQU		0X21

			ORG	0X00
			goto	Setup

Setup
	Banksel			TRISB
	Clrf				TRISB
	Banksel			PORTB
	Clrf				PORTB

	Banksel			TRISC
	Clrf				TRISC
	Banksel			PORTC
	Clrf				PORTC

Yak1
	Movlw			0x01
	Movwf			PORTC
	Movlw			B'01101011'
	Movwf			PORTB

	call				gecikme10ms

	Movlw			0x02
	Movwf			PORTC
	Movlw			B'01000001'
	Movwf			PORTB

	call				gecikme10ms

	Movlw			0x04
	Movwf			PORTC
	Movlw			B'01000001'
	Movwf			PORTB	

	call				gecikme10ms

	Movlw			0x08
	Movwf			PORTC
	Movlw			B'01100011'
	Movwf			PORTB

	call				gecikme10ms

	Movlw			D'16'
	Movwf			PORTC
	Movlw			B'01110111'
	Movwf			PORTB

	call				gecikme10ms

	goto			Yak1



;10ms gecikme
gecikme10ms
	Movlw			D'25'
	Movwf			sayac1
gecikme10ms2
	Movlw			D'25'
	Movwf			sayac2
gecikme10ms3
	Decfsz			sayac2,f
	goto			gecikme10ms3
	Decfsz			sayac1,f
	goto			gecikme10ms2
	return

End