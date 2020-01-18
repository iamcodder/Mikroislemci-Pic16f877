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
	Movwf		ADCON1 	; A portunu analogtan dijitale çevirdik
	Banksel		TRISA
	Movlw		b'00110000'
	Movwf		TRISA		; A portunun ilk 4 bitini giris,diger 2'yi cýktý yaptýk
	Banksel		PORTA
	Clrf		PORTA     	; A portunu sýfýrladýk
	Banksel		TRISB
	Clrf		TRISB 		; B portunu cikti yaptýk
	Banksel		PORTB
	Clrf		PORTB		; B portunu sýfýrladýk
	Movlw		D'10'		
	Movwf		Sayac3		; 10 defa döngü yapmak için
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
	


ileri_say_dort_bit						; A portunun ileri saymasýný saglýyor
	call		gecikme
	Banksel		PORTB
	Clrf			PORTB
	Clrf			Bportundaki_deger
	Banksel		PORTA
	Movfw		Aportundaki_deger	; A portunun sayýsýný degiskende tutuyoruz
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
									;yapmamýz lazým burada onu kontrol ediyoruz
	call		gecikme
	Movfw		Aportundaki_deger	;eger
	Movwf		PORTA
	goto		b_portunu_fulle

a_portu_sifirla						;a portunda deger olmayacaksa bu metot
	Clrf			PORTA
	Clrf			Aportundaki_deger
	goto		a_portunu_fulle

a_portunu_fulle						;sayý geri saymaya devam ederken 0 olursa
	Movlw		0xFF				;1 eksigi 255 olacagi icin a ve p portlarýnýn
	Movwf		Aportundaki_deger	;hepsini yakmamýz lazým
	Movwf		PORTA
	goto		b_portunu_fulle

b_portunu_fulle						;üsttekinin aynýsý
	Movlw		0xFF
	Movwf		PORTB
	Movwf		Bportundaki_deger
	goto		sekiz_bit_geri_saydir
	

b_portu_hepsi_yaniyor_mu
	Banksel		STATUS
	Btfss		STATUS,Z 			; 255'den 0a geçtiyse z biti 1 oluyor.eger z biti 1 olduysa a portunu yakmamýz lazým
	return
	Bcf			STATUS,Z
	call			ileri_say_dort_bit
	return


gecikme						;1 saniye gecikme için 10 defa 100ms gecikme yaptýrýyoruz
	
	Movlw		D'1'
	Movwf		Sayac3
	goto		dongu1

dongu1						;dongu 1,2,3 hesaplara göre 100ms gecikme yapýyor
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