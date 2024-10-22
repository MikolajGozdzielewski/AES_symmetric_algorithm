include("struktury.jl")
include("klucz.jl")
include("funkcje.jl")
include("aes.jl")
include("konwersje.jl")
include("aesde.jl")



#print("Podaj nazwe pliku klucza z koncowka .txt\n")
#nazwa = readline()
nazwa = "k"
#128,192 lub 256
dlugosc_klucza = 16
klucz = klucz_sesji(generacja_klucza(dlugosc_klucza),zeros(dlugosc_klucza),dlugosc_klucza,0)
przepisanie_klucza(klucz.klucz_podstawowy,klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
write(nazwa,klucz.klucz_podstawowy)

#print("Podaj tekst do zaszyfrowania\n")
#tekst = readline()
tekst = teksts("",zeros(4,4),"")
tekst.tekst_jawny = "ala ma kota"

#ROZSZERZANIE KLUCZA
klucz.klucz_rozszerzony = rozszerzenie_klucza(klucz.klucz_rozszerzony,klucz.dlugosc_klucza)


#SZYFROWANIE
szyfrowanie(klucz,tekst)
print(tekst.tekst_zaszyfrowany,'\n')

tekst.macierz_tekstu = zeros(4,4)
tekst.tekst_jawny = ""

#DESZYFROWANIE
deszyfrowanie(klucz,tekst)
print(tekst.tekst_jawny)


