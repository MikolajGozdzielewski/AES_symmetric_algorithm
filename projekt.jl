mutable struct klucz_sesji
    klucz_podstawowy::String
    klucz_rozszerzony::Array{UInt8}
    dlugosc_klucza::Int
    iteracje::Int
end

mutable struct teksts
    tekst_jawny::String
    macierz_tekstu::Matrix{UInt8}
    tekst_zaszyfrowany::String
end

function generacja_klucza(dlugosc)
    klucz = ""
    for i in 1:dlugosc
        fragment_klucza = rand(0:255)
        if (fragment_klucza >= 16 )
            klucz = string(klucz,string(fragment_klucza,base = 16))
        else
            klucz = string(klucz,'0',string(fragment_klucza,base = 16))
        end
    end
    return klucz
end

function rozszerzenie_klucza(klucz,dlugosc_klucza)
    if dlugosc_klucza == 16
        ilosc_powtorzen = 10
    elseif dlugosc_klucza == 24
        ilosc_powtorzen = 8
    elseif dlugosc_klucza == 32
        ilosc_powtorzen = 9
    end
    for i in 1:ilosc_powtorzen

        #NOWE 4 BAJTY
        dlugosc = length(klucz)
        buffor = klucz[dlugosc-3:dlugosc]
        buffor = przesun_w_lewo(buffor)
        for j in 1:4
            buffor[j] = s_box(buffor[j])
        end
        if i < 9
            rcon = buffor[1] ⊻ 2^(i-1)
        elseif i == 9
            rcon = buffor[1] ⊻ 27
        elseif i ==10
            rcon = buffor[1] ⊻ 54
        elseif i ==11
            rcon = buffor[1] ⊻ 108
        elseif i ==12
            rcon = buffor[1] ⊻ 216
        elseif i ==13
            rcon = buffor[1] ⊻ 171
        elseif i ==14
            rcon = buffor[1] ⊻ 77
        end
        if (rcon > 255)
            rcon = mod(rcon,256)
        end
        buffor[1] = rcon
        for j in 1:4
            buffor[j] = buffor[j] ⊻ klucz[dlugosc - dlugosc_klucza + j]
            push!(klucz,buffor[j])
        end
        
        

        #NOWE 12 BAJTÓW
        for j in 1:3
            dlugosc = length(klucz)
            for k in 1:4
                push!(klucz,klucz[dlugosc - 4 + k] ⊻ klucz[dlugosc - dlugosc_klucza + k])
            end
        end

        if dlugosc_klucza != 16 && i == ilosc_powtorzen
            break
        end

        #DLA 256-bitowego klucza
        if dlugosc_klucza == 32
            dlugosc = length(klucz)
            buffor = klucz[dlugosc-3:dlugosc]
            for j in 1:4
                buffor[j] = s_box(buffor[j])
            end
            for j in 1:4
                buffor[j] = buffor[j] ⊻ klucz[dlugosc - dlugosc_klucza + j]
                push!(klucz,buffor[j])
            end
        end




        #DLA 192 i 256-bitowego klucza
        if dlugosc_klucza != 16
            if dlugosc_klucza == 24
                kroki = 2
            elseif dlugosc_klucza == 32
                kroki = 3
            end
            for j in 1:kroki
                dlugosc = length(klucz)
                buffor = klucz[dlugosc-3:dlugosc]
                for k in 1:4
                    buffor[k] = buffor[k] ⊻ klucz[dlugosc - dlugosc_klucza + k]
                    push!(klucz,buffor[k])
                end
            end
        end


    end
    return klucz
end

function przesun_w_lewo(fragment)
    buffor = fragment[1]
    for i in 1:3
        fragment[i] = fragment[i+1]
    end
    fragment[4] = buffor
    return fragment
end

function s_box(liczba::UInt8)
    plik = open("sbox.txt","r")
    sbox = read(plik,String)
    liczba1 = mod(liczba,16)
    liczba2 = (liczba - mod(liczba,16)) / 16
    x = 1
    while sbox[x] != '\n'
        x = x +1
    end
    miejsce::Int = (liczba2) * x + ((liczba1) * 3) + 1
    wy = parse(UInt8,sbox[miejsce:miejsce+1],base = 16) 
    return wy
end

function przepisanie_klucza(pod,roz,dlugosc_klucza)
    for i in 1:dlugosc_klucza
        roz[i] = parse(UInt8,pod[(i*2-1):(i*2)],base=16)
    end
end

function konwersja_tekstu(tekst)
    macierz = zeros(4,4)
    dlugosc = length(tekst)
    for i in 1:dlugosc
        macierz[i] = codepoint(tekst[i])
    end
    return macierz
end

function xor_macierzy(fragment_klucza,tekst)
    for i in 1:16
        tekst[i] = tekst[i] ⊻ fragment_klucza[i]
    end
    return tekst
end

function rudna_szyfrujaca(tekst,klucz,ostatnia_runda::Bool)
    for i in 1:16
        tekst[i] = s_box(tekst[i])
    end
    tekst = przesuniecie_w_lewo_macierz(tekst,2,1)
    tekst = przesuniecie_w_lewo_macierz(tekst,3,2)
    tekst = przesuniecie_w_lewo_macierz(tekst,4,3)
    if ostatnia_runda == 0
        for i in 1:4
            tekst[(i-1) * 4+1:(i-1)*4+4] = mnozenie_macierzy_xor(tekst[(i-1) * 4+1:(i-1)*4+4])
        end
    end
    tekst = xor_macierzy(klucz,tekst)
    return tekst
end

function przesuniecie_w_lewo_macierz(macierz,wiersz,ile_razy)
    for i in 1:ile_razy
        buffor = macierz[wiersz]
        for j in 1:3
            macierz[wiersz + 4 * (j - 1)] = macierz[wiersz + 4*j]
        end
        macierz[wiersz + 12] = buffor
    end
    return macierz
end

function mnozenie_macierzy_xor(kolumna)
    macierz_przeksztalcen = [2 3 1 1;1 2 3 1;1 1 2 3;3 1 1 2]
    nowa_kolumna = zeros(UInt8,4)
    for i in 1:4
        buffor = 0
        for j in 1:4
            a = macierz_przeksztalcen[(j-1)*4+i]
            b= kolumna[j]
            p = 0
            for k in 1:8
                if(mod(b,2) == 1)
                    p = p ⊻ a
                end
                a = a << 1
                if (a > 255)
                    a = mod(a,256)
                    a = a ⊻ 27
                end
                b = b >> 1
            end


            buffor = buffor ⊻ p
        end
        nowa_kolumna[i] = mod(buffor,256)
    end
    return nowa_kolumna
end

function konwersja_nahex(macierz)
    szyfr = ""
    for i in 1:16
        znaki = string(macierz[i],base=16)
        if length(znaki) == 1
            znaki = string('0',znaki)
        end
        szyfr = string(szyfr,znaki)
    end
    return szyfr
end



#print("Podaj nazwe pliku klucza z koncowka .txt\n")
#nazwa = readline()
nazwa = "k"
#128,192 lub 256
dlugosc_klucza = 32
klucz = klucz_sesji(generacja_klucza(dlugosc_klucza),zeros(dlugosc_klucza),dlugosc_klucza,0)
#if dlugosc_klucza == 16
    #klucz = klucz_sesji("5468617473206d79204b756e67204675",zeros(16))
#elseif dlugosc_klucza == 24
    #klucz = klucz_sesji("8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b",zeros(24))
#elseif dlugosc_klucza == 32
    #klucz = klucz_sesji("603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4",zeros(32))
#end
przepisanie_klucza(klucz.klucz_podstawowy,klucz.klucz_rozszerzony,klucz.dlugosc_klucza)
write(nazwa,klucz.klucz_podstawowy)

#print("Podaj tekst do zaszyfrowania\n")
#tekst = readline()
tekst = teksts("",zeros(4,4),"")
tekst.tekst_jawny = "ala ma kota"

#ROZSZERZANIE KLUCZA
klucz.klucz_rozszerzony = rozszerzenie_klucza(klucz.klucz_rozszerzony,klucz.dlugosc_klucza)


#SZYFROWANIE
tekst.macierz_tekstu = konwersja_tekstu(tekst.tekst_jawny)
tekst.macierz_tekstu = xor_macierzy(reshape(klucz.klucz_rozszerzony[1:16],(4,4)),tekst.macierz_tekstu)

if klucz.dlugosc_klucza == 16
    klucz.iteracje = 10
elseif klucz.dlugosc_klucza == 24
    klucz.iteracje = 12
elseif klucz.dlugosc_klucza == 32
    klucz.iteracje = 14
end

for i in 1:klucz.iteracje
    tekst.macierz_tekstu = rudna_szyfrujaca(tekst.macierz_tekstu,reshape(klucz.klucz_rozszerzony[16*i+1:16*i+16],(4,4)),i == klucz.iteracje)
end

tekst.tekst_zaszyfrowany = konwersja_nahex(tekst.macierz_tekstu)

print(tekst.tekst_zaszyfrowany,'\n')


#DESZYFROWANIE



