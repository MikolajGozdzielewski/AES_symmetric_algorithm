using Primes
include("struktury.jl")
include("generacjaklucza.jl")
include("klucz.jl")
include("diffiehellman.jl")
include("konwersje.jl")
include("md5.jl")
include("funkcje.jl")
include("trybyszyfrowanie.jl")
include("aes.jl")


mutable struct sdane_s
    klucz_wpisywany::String
    klucz_z_pliku::String
    tekst_wpisywany::String
    tekst_z_pliku::String
    generuj::Int
    generuj_DH::Bool
    tryb::String
    zapisz_klucz::String
    zapisz_szyfr::String
    blad::Bool
end

mutable struct sdane_d
    klucz_wpisywany::String
    klucz_z_pliku::String
    szyfr_wpisywany::String
    szyfr_z_pliku::String
    tryb::String
    blad::Bool
end

function komendy()
    while true
        print("Wpisz komende:\n")
        komenda = split(readline())
    
        if komenda[1] == "szyfrowanie"
            dane_s = k_szyfrowanie(komenda)
            if dane_s.blad == 0
                if poprawonosc_komendy_szyfrowanie(dane_s)
                    blad = false
                    if dane_s.klucz_wpisywany != ""
                        if mod(length(dane_s.klucz_wpisywany),2) != 0
                            print("Niepoprawna dlugosc klucza wpisanego\n")
                            blad = true
                        else
                            dlugosc_klucza = length(klucz_tymczasowy)/2
                            klucz = klucz_sesji(dane_s.klucz_wpisywany,zeros(Int(dlugosc_klucza)),dlugosc_klucza,0)
                        end
                    elseif dane_s.klucz_z_pliku != ""
                        plik = open(dane_s.klucz_z_pliku,"r")
                        klucz_tymczasowy = read(plik,String)
                        close(plik)
                        if mod(length(klucz_tymczasowy),2) != 0
                            print("Niepoprawna dlugosc klucza w pliku\n")
                            blad = true
                        else
                            dlugosc_klucza = length(klucz_tymczasowy)/2
                            klucz = klucz_sesji(klucz_tymczasowy,zeros(Int(dlugosc_klucza)),dlugosc_klucza,0)
                        end
                    elseif dane_s.generuj != 0
                        klucz = klucz_sesji(generacja_klucza(dane_s.generuj),zeros(dane_s.generuj),dane_s.generuj,0)
                    elseif dane_s.generuj_DH == true
                        print(1,"\n")
                        klucz_tymczasowy = string(diffiehellman(),base = 16)
                        print("dh\n")
                        klucz_tymczasowy = md5(klucz_tymczasowy)
                        print("ms5\n")
                        klucz = klucz_sesji(klucz_tymczasowy,zeros(16),16,0)
                    end
                    #print(klucz.dlugosc_klucza,"\n")
                    if klucz.dlugosc_klucza == 16 || klucz.dlugosc_klucza == 24 || klucz.dlugosc_klucza == 32
                        przepisanie_klucza(klucz.klucz_podstawowy,klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
                        klucz.klucz_rozszerzony = rozszerzenie_klucza(klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
                        #print(klucz.klucz_podstawowy,"\n")
                        #print(klucz.klucz_rozszerzony,"\n")
                    else
                        print("Niepoprawna dlugosc klucza\n")
                        blad = true
                    end
                    if !blad
                        if dane_s.tekst_wpisywany != ""
                            tekst_wejsciowy = dane_s.tekst_wpisywany
                        elseif dane_s.tekst_z_pliku != ""
                            plik = open(dane_s.tekst_z_pliku,"r")
                            tekst_wejsciowy = read(plik,String)
                            close(plik)
                        end
                        tekst = teksts("",zeros(4,4),"")
                        if dane_s.tryb == "ECB"
                            tekst_zaszyfrowany = ecb(tekst_wejsciowy,tekst,klucz)
                        elseif dane_s.tryb == "CBC"
                            tekst_zaszyfrowany = cbc(tekst_wejsciowy,tekst,klucz)
                        end
                        if dane_s.zapisz_klucz != ""
                            write(dane_s.zapisz_klucz,klucz.klucz_podstawowy)
                        end
                        if dane_s.zapisz_szyfr != ""
                            write(dane_s.zapisz_szyfr,tekst_zaszyfrowany)
                        end
                        print(tekst_zaszyfrowany,"\n")
                    end
                end
            end
        elseif komenda[1] == "deszyfrowanie"
            dane_d = k_deszyfrowanie(komenda)
            if dane_d.blad == 0
                if poprawonosc_komendy_deszyfrowanie(dane_d)
                    blad = false
                    if dane_d.klucz_wpisywany != ""
                        if mod(length(dane_d.klucz_wpisywany),2) != 0
                            print("Niepoprawna dlugosc klucza wpisanego\n")
                            blad = true
                        else
                            dlugosc_klucza = length(klucz_tymczasowy)/2
                            klucz = klucz_sesji(dane_d.klucz_wpisywany,zeros(Int(dlugosc_klucza)),dlugosc_klucza,0)
                        end
                    elseif dane_d.klucz_z_pliku != ""
                        plik = open(dane_d.klucz_z_pliku,"r")
                        klucz_tymczasowy = read(plik,String)
                        close(plik)
                        if mod(length(klucz_tymczasowy),2) != 0
                            print("Niepoprawna dlugosc klucza w pliku\n")
                            blad = true
                        else
                            dlugosc_klucza = length(klucz_tymczasowy)/2
                            klucz = klucz_sesji(klucz_tymczasowy,zeros(Int(dlugosc_klucza)),dlugosc_klucza,0)
                        end
                    end
                    if klucz.dlugosc_klucza == 16 || klucz.dlugosc_klucza == 24 || klucz.dlugosc_klucza == 32
                        przepisanie_klucza(klucz.klucz_podstawowy,klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
                        klucz.klucz_rozszerzony = rozszerzenie_klucza(klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
                        #print(klucz.klucz_podstawowy,"\n")
                        #print(klucz.klucz_rozszerzony,"\n")
                    else
                        print("Niepoprawna dlugosc klucza\n")
                        blad = true
                    end
                    if !blad
                        if dane_d.szyfr_wpisywany != ""
                            szyfr_wejsciowy = dane_d.szyfr_wpisywany
                        elseif dane_d.szyfr_z_pliku != ""
                            plik = open(dane_d.szyfr_z_pliku,"r")
                            szyfr_wejsciowy = read(plik,String)
                            close(plik)
                        end
                        tekst = teksts("",zeros(4,4),"")
                        if dane_d.tryb == "ECB"
                            tekst_odszyfrowany = ecb_de(szyfr_wejsciowy,tekst,klucz)
                        elseif dane_d.tryb == "CBC"
                            tekst_odszyfrowany = cbc_de(szyfr_wejsciowy,tekst,klucz)
                        end
                        print(tekst_odszyfrowany,"\n")
                    end
                end
            end
        elseif komenda[1] == "koniec"
            break
        else
            print("Niepoprawna komenda\n")
        end
    end
end

function k_szyfrowanie(komenda)
    dane = sdane_s("","","","",0,false,"","","",0)
    
    dlugosc = length(komenda)
    i = 2
    while i <= dlugosc
        if komenda[i] == "-k"
            i = i + 1
            dane.klucz_wpisywany = wartosc_tekst(dane.klucz_wpisywany,komenda,i)
            if dane.klucz_wpisywany == ""
                print("Blad niepoprawna wartosc parametru -k\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.klucz_wpisywany))
            #print(dane.klucz_wpisywany)
        elseif komenda[i] == "-K" 
            i = i + 1
            dane.klucz_z_pliku = wartosc_tekst(dane.klucz_z_pliku,komenda,i)
            if dane.klucz_z_pliku == ""
                print("Blad niepoprawna wartosc parametru -K\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.klucz_z_pliku))
        elseif komenda[i] == "-g"
            i = i + 1
            if komenda[i] == "128"
                dane.generuj = 16
            elseif komenda[i] == "192"
                dane.generuj = 24
            elseif komenda[i] == "256"
                dane.generuj = 32
            else
                print("Blad niepoprawna wartosc parametru -g\n")
                dane.blad = 1
                break
            end
            i += 1
        elseif komenda[i] == "-d"
            i = i + 1
            print(1,"\n")
            dane.generuj_DH = true
        elseif komenda[i] == "-m"
            i = i + 1
            if komenda[i] == "ECB"
                dane.tryb = "ECB"
            elseif komenda[i] == "CBC"
                dane.tryb = "CBC"
            else
                print("Blad niepoprawna wartość paramentru -m\n")
                dane.blad = 1
                break
            end
            i = i + 1
        elseif komenda[i] == "-s"
            i = i + 1
            dane.zapisz_klucz = wartosc_tekst(dane.zapisz_klucz,komenda,i)
            if dane.zapisz_klucz == ""
                print("Blad niepoprawna wartosc parametru -s\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.zapisz_klucz))
        elseif komenda[i] == "-S"
            i = i + 1
            dane.zapisz_szyfr = wartosc_tekst(dane.zapisz_szyfr,komenda,i)
            if dane.zapisz_szyfr == ""
                print("Blad niepoprawna wartosc parametru -S\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.zapisz_szyfr))
        elseif komenda[i] == "-p"
            i = i + 1
            dane.tekst_wpisywany = wartosc_tekst(dane.tekst_wpisywany,komenda,i)
            if dane.tekst_wpisywany == ""
                print("Blad niepoprawna wartosc parametru -p\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.tekst_wpisywany))
        elseif komenda[i] == "-P"
            i = i + 1
            dane.tekst_z_pliku = wartosc_tekst(dane.tekst_z_pliku,komenda,i)
            if dane.tekst_z_pliku == ""
                print("Blad niepoprawna wartosc parametru -P\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.tekst_z_pliku))
        else
            print("Blad niepoprawna nazwa paramentru ", komenda[i],"\n")
            dane.blad = 1
            break
        end
    end
    return dane
end

function k_deszyfrowanie(komenda)
    dane = sdane_d("","","","","",0)
    
    dlugosc = length(komenda)
    i = 2
    while i <= dlugosc
        if komenda[i] == "-k"
            i = i + 1
            dane.klucz_wpisywany = wartosc_tekst(dane.klucz_wpisywany,komenda,i)
            if dane.klucz_wpisywany == ""
                print("Blad niepoprawna wartosc parametru -k\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.klucz_wpisywany))
            #print(dane.klucz_wpisywany)
        elseif komenda[i] == "-K" 
            i = i + 1
            dane.klucz_z_pliku = wartosc_tekst(dane.klucz_z_pliku,komenda,i)
            if dane.klucz_z_pliku == ""
                print("Blad niepoprawna wartosc parametru -K\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.klucz_z_pliku))
        elseif komenda[i] == "-m"
            i = i + 1
            if komenda[i] == "ECB"
                dane.tryb = "ECB"
            elseif komenda[i] == "CBC"
                dane.tryb = "CBC"
            else
                print("Blad niepoprawna wartość paramentru -m\n")
                dane.blad = 1
                break
            end
            i = i + 1
        elseif komenda[i] == "-c"
            i = i + 1
            dane.szyfr_wpisywany = wartosc_tekst(dane.szyfr_wpisywany,komenda,i)
            if dane.szyfr_wpisywany == ""
                print("Blad niepoprawna wartosc parametru -c\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.szyfr_wpisywany))
        elseif komenda[i] == "-C"
            i = i + 1
            dane.szyfr_z_pliku = wartosc_tekst(dane.szyfr_z_pliku,komenda,i)
            if dane.szyfr_z_pliku == ""
                print("Blad niepoprawna wartosc parametru -C\n")
                dane.blad = 1
                break
            end
            i = i + length(split(dane.szyfr_z_pliku))
        else
            print("Blad niepoprawna nazwa paramentru ", komenda[i],"\n")
            dane.blad = 1
            break
        end
    end
    return dane
end

function wartosc_tekst(tekst,wejscie,i)
    dlugosc = length(wejscie)
    if !startswith(wejscie[i],"\"")
        return ""
    end
    while i <= dlugosc
        tekst = string(tekst," ",wejscie[i])
        i = i + 1
        if endswith(tekst,"\"")
            break
        end
    end
    if !endswith(tekst,"\"")
        return ""
    end
    return tekst[3:end-1]
end

function poprawonosc_komendy_szyfrowanie(dane::sdane_s)
    suma_kontrolna_klucz = 0
    suma_kontrolna_tekst = 0
    liczba_kontrolna_tryb = 0
    if dane.klucz_wpisywany != ""
        suma_kontrolna_klucz += 1
    end
    if dane.klucz_z_pliku != ""
        suma_kontrolna_klucz += 1
    end
    if dane.generuj != 0
        suma_kontrolna_klucz += 1
    end
    if dane.generuj_DH == true
        suma_kontrolna_klucz += 1
    end
    if dane.tekst_wpisywany != ""
        suma_kontrolna_tekst += 1
    end
    if dane.tekst_z_pliku != ""
        suma_kontrolna_tekst += 1
    end
    if dane.tryb != "" 
        liczba_kontrolna_tryb = 1
    end
    if suma_kontrolna_klucz > 1
        print("Za duzo parametrow zwiazanych z kluczem\n")
        return false
    end
    if suma_kontrolna_tekst > 1
        print("Za duzo parametrow zwiazanych z tekstem\n")
        return false
    end
    if suma_kontrolna_klucz == 0
        print("Brak parametu zwianego z kluczem\n")
        return false
    end
    if suma_kontrolna_tekst == 0
        print("Brak parametu zwianego z tekstem\n")
        return false
    end
    if liczba_kontrolna_tryb == 0
        print("Brak parametu zwianego z trybem\n")
        return false
    end
    return true
end

function poprawonosc_komendy_deszyfrowanie(dane::sdane_d)
    suma_kontrolna_klucz = 0
    suma_kontrolna_szyfr = 0
    liczba_kontrolna_tryb = 0
    if dane.klucz_wpisywany != "" 
        suma_kontrolna_klucz += 1
    end
    if dane.klucz_z_pliku != ""
        suma_kontrolna_klucz += 1
    end
    if dane.szyfr_wpisywany != ""
        suma_kontrolna_szyfr += 1
    end
    if dane.szyfr_z_pliku != ""
        suma_kontrolna_szyfr += 1
    end
    if dane.tryb != "" 
        liczba_kontrolna_tryb = 1
    end
    if suma_kontrolna_klucz > 1
        print("Za duzo parametrow zwiazanych z kluczem\n")
        return false
    end
    if suma_kontrolna_szyfr > 1
        print("Za duzo parametrow zwiazanych z szyfrem\n")
        return false
    end
    if suma_kontrolna_klucz == 0
        print("Brak parametu zwianego z kluczem\n")
        return false
    end
    if suma_kontrolna_szyfr == 0
        print("Brak parametu zwianego z szyfrem\n")
        return false
    end
    if liczba_kontrolna_tryb == 0
        print("Brak parametu zwianego z trybem\n")
        return false
    end
    return true
end

komendy()