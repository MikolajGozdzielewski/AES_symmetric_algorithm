include("struktury.jl")
include("klucz.jl")
include("funkcje.jl")
include("aes.jl")
include("konwersje.jl")
include("trybyszyfrowanie.jl")
include("generacjaklucza.jl")



#print("Podaj nazwe pliku klucza z koncowka .txt\n")
#nazwa = readline()
nazwa = "k"
#128,192 lub 256
dlugosc_klucza = 24
#klucz = klucz_sesji(generacja_klucza(dlugosc_klucza),zeros(dlugosc_klucza),dlugosc_klucza,0)
klucz = klucz_sesji("5f9212f6e91705f49956bab8ea8eed414e1493bbf6dfd87f",zeros(dlugosc_klucza),dlugosc_klucza,0)
przepisanie_klucza(klucz.klucz_podstawowy,klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
write(nazwa,klucz.klucz_podstawowy)

#print("Podaj tekst do zaszyfrowania\n")
#tekst = readline()
tekst = teksts("",zeros(4,4),"")
#tekst.tekst_jawny = "ala ma kota"
#tekst_wejsciowy = "Uczelnia zostala powolana do zycia w 1899 roku decyzja cesarza Wilhelma II[4]; w dniu 16 marca 1899 roku pruscy poslowie zatwierdzili te decyzje[5]. Uczelnia zostala otwarta w 1904 roku jako, zgodnie z pierwszym statutem z 1 pazdziernika 1904 r., Politechnika Krolewska w Gdansku (niem. Konigliche Technische Hochschule zu Danzig)"
tekst_wejsciowy = "papaja"



#ROZSZERZANIE KLUCZA
klucz.klucz_rozszerzony = rozszerzenie_klucza(klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
print(klucz.klucz_rozszerzony,"\n")

#SZYFROWANIE

tekst_zaszyfrowany = ecb(tekst_wejsciowy,tekst,klucz)

tekst.macierz_tekstu = zeros(4,4)
tekst.tekst_jawny = ""
tekst_wejsciowy = ""

#DESZYFROWANIE
tekst_wejsciowy = ecb_de(tekst_zaszyfrowany,tekst,klucz)
print(tekst_wejsciowy,'\n')


#SZYFROWANIE

tekst_zaszyfrowany = cbc(tekst_wejsciowy,tekst,klucz)

tekst.macierz_tekstu = zeros(4,4)
tekst.tekst_jawny = ""
tekst_wejsciowy = ""

#DESZYFROWANIE
tekst_wejsciowy = cbc_de(tekst_zaszyfrowany,tekst,klucz)
print(tekst_wejsciowy,'\n')


