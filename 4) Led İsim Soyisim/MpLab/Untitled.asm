#include <p16f877.inc>

temp	EQU	0X20
GECIKME2	EQU	0X21
GECIKME1	EQU	0X22
temp2	EQU	0X23
		ORG	0X00
		goto	Setup

Setup
	BANKSEL		TRISB
	CLRF		TRISB
	BANKSEL		PORTB
	CLRF		PORTB


	BCF		PORTB,4		;RS UCUNU 0 YAPARAK LCD YE KOMUT GONDERECEGINI SOYLE
	
	MOVLW		0x01				;ekrani temizleme
	call		KOMUT_8BIT

	Movlw		0x02				;display ayarini aktif etme
	call		KOMUT_8BIT

	Movlw		0x03				;imleci basa alma
	call		KOMUT_8BIT

	MOVLW		0x06				;karakter modunu acma
	call		KOMUT_8BIT

	MOVLW		0x0D				;Displayy on/off
	call		KOMUT_8BIT		

	Movlw		0x28				;2 satir,4 bit iletisim
	call		KOMUT_8BIT

	Movlw		0x80				;1.satira gec
	call		KOMUT_8BIT

	Movlw		'S'
	call		Karakter_gonder		
	
	Movlw		0xC0				;2.sat�ra gec
	call			KOMUT_8BIT

	Movlw		'S'
	call			Karakter_gonder		

	

Dongu

	goto		Dongu

KOMUT_8BIT
	Bcf			PORTB,4
	Movwf		temp
	Swapf		temp,w
	call			komut_4_bit
	Movfw		temp
	call			komut_4_bit
	return

komut_4_bit
	Andlw		0x0f
	Movwf		temp2
	Movfw		PORTB
	Andlw		0xf0
	iorwf		temp2,w
	Movwf		PORTB	
	call			DUSEN_KENAR
	return

Karakter_gonder
	Movwf		temp
	Swapf		temp,w
	Banksel		PORTB
	Bsf			PORTB,4
	call			komut_4_bit
	Movfw		temp
	call			komut_4_bit
	return

DUSEN_KENAR:
	bsf		PORTB,5			
	call 	cok_az_gecikme	
	bcf		PORTB,5			
    	return

cok_az_gecikme				
	movlw	0xC8
	movwf	GECIKME1
DNGU1
	decfsz	GECIKME1,1
	goto	DNGU1
	return

END