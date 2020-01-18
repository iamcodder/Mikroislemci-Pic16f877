### Çalýþma Ýçeriði

- Satýr seçim uçlarýný C portuna, sütun seçim uçlarýný B portuna baðladým.
- Satýrý aktif etmek için 1, sütunu aktif etmek için 0 kullanýyoruz.
- Örneðin ilk satýrý seçmek için C portuna 1 atýyoruz . Sütunlarý seçmek içinse (kalp için ilk satýrda 2 nokta seçmeliyiz) B portuna 1101011 atamasý yapýyoruz.Böylece ilk satýrda 2 nokta aktif oluyor. Diðer satýrlarda da ayný þekilde iþlem yapýyoruz.Ancak ilk satýrý ve sütunu aktif ettikten sonra ikinci satýra geçerken kýsa bir bekleme süresi ekliyoruz.Buna süpürme iþlemi deniyor.
- Süpürme iþlemi için 2-3 ms kullanabilirsiniz.Böylece bir döngüye sokuyoruz.

![dot_matris](https://user-images.githubusercontent.com/25854605/72671106-7b647100-3a56-11ea-8350-abd64ce18a06.gif)


