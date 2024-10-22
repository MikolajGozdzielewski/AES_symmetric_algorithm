function szyfrowanie(klucz,tekst)
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
    
    tekst.tekst_zaszyfrowany = konwersja_na_hex(tekst.macierz_tekstu)
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