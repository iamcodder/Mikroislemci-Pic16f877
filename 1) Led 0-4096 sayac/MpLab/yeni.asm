#include<p16f877.inc>
__CONFIG H'3F31'
Sayac1		EQU	0X21
Sayac2		EQU	0X22
Sayac3		EQU	0X23
Aportundaki_deger	EQU	0X26
Bportundaki_deger	EQU	0X27
			ORG	0X0000
			goto	Setup

Setup
	Banksel		ADCON1
	Movlw		0x06	
	Movwf		ADCON1 	; A portunu analogtan dijitale �evirdik
	Banksel		TRISA
	Movlw		b'00110000'
	Movwf		TRISA		; A portunun ilk 4 bitini giris,diger 2'yi c�kt� yapt�k
	Banksel		PORTA
	Clrf		PORTA     	; A portunu s�f�rlad�k
	Banksel		TRISB
	Clrf		TRISB 		; B portunu cikti yapt�k
	Banksel		PORTB
	Clrf		PORTB		; B portunu s�f�rlad�k
	Movlw		D'10'		
	Movwf		Sayac3		; 10 defa d�ng� yapmak i�in
	Clrf		Aportundaki_deger
	Clrf		Bportundaki_deger
	goto		kontrol_bir

kontrol_bir 					; geri sayma butonu mu aktif
	Btfss		PORTA,5
	goto		kontrol_iki
	goto		a_portunu_fulle

kontrol_iki					; ileri sayma butonu mu aktif
	Btfss		PORTA,4
	goto		kontrol_bir
	goto		ileri_say_sekiz_bit


ileri_say_sekiz_bit			; B portunda ileri sayma islemi icin
	call		gecikme
	Movlw		0x01
	Addwf		Bportundaki_deger,f
	Movfw		Bportundaki_deger
	Movwf		PORTB
	call		b_portu_hepsi_yaniyor_mu

	Btfss		PORTA,5
	goto		ileri_say_sekiz_bit
	goto		sekiz_bit_geri_saydir



sekiz_bit_geri_saydir
	call			gecikme

	Bsf			STATUS,C

	Movlw		b'1'
	Subwf		Bportundaki_deger,f

	Btfss		STATUS,C
	goto		a_portu_kontrol
	Movfw		Bportundaki_deger
	Movwf		PORTB

	Btfss		PORTA,4
	goto		sekiz_bit_geri_saydir
	goto		ileri_say_sekiz_bit
	


ileri_say_dort_bit						; A portunun ileri saymas�n� sagl�yor
	call		gecikme
	Banksel		PORTB
	Clrf			PORTB
	Clrf			Bportundaki_deger
	Banksel		PORTA
	Movfw		Aportundaki_deger	; A portunun say�s�n� degiskende tutuyoruz
	Addlw		b'1'
	Movwf		Aportundaki_deger
	Movwf		PORTA
	Clrw
	return

a_portu_kontrol						
	Bsf			STATUS,C
	Movlw		0x01
	Subwf		Aportundaki_deger,f
	Btfss		STATUS,C			;a portundaki sayidan 1 cikinca sonuc eksi
	goto		a_portu_sifirla		;oluyorsa o zaman b portundan azaltma 
									;yapmam�z laz�m burada onu kontrol ediyoruz
	call		gecikme
	Movfw		Aportundaki_deger	;eger
	Movwf		PORTA
	goto		b_portunu_fulle

a_portu_sifirla						;a portunda deger olmayacaksa bu metot
	Clrf			PORTA
	Clrf			Aportundaki_deger
	goto		a_portunu_fulle

a_portunu_fulle						;say� geri saymaya devam ederken 0 olursa
	Movlw		0xFF				;1 eksigi 255 olacagi icin a ve p portlar�n�n
	Movwf		Aportundaki_deger	;hepsini yakmam�z laz�m
	Movwf		PORTA
	goto		b_portunu_fulle

b_portunu_fulle						;�sttekinin ayn�s�
	Movlw		0xFF
	Movwf		PORTB
	Movwf		Bportundaki_deger
	goto		sekiz_bit_geri_saydir
	

b_portu_hepsi_yaniyor_mu
	Banksel		STATUS
	Btfss		STATUS,Z 			; 255'den 0a ge�tiyse z biti 1 oluyor.eger z biti 1 olduysa a portunu yakmam�z laz�m
	return
	Bcf			STATUS,Z
	call			ileri_say_dort_bit
	return


gecikme						;1 saniye gecikme i�in 10 defa 100ms gecikme yapt�r�yoruz
	
	Movlw		D'1'
	Movwf		Sayac3
	goto		dongu1

dongu1						;dongu 1,2,3 hesaplara g�re 100ms gecikme yap�yor
	Movlw		H'B6'
	Movwf		Sayac1
	goto		dongu2

dongu2
	Movlw		H'B6'
	Movwf		Sayac2
	goto		dongu3

dongu3
	Decfsz		Sayac2,f
	goto		dongu3

	Decfsz		Sayac1,f
	goto		dongu2
	Decfsz		Sayac3,f
	goto		dongu1
	return		

End