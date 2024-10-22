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
        tekst.macierz_tekstu = runda_szyfrujaca(tekst.macierz_tekstu,reshape(klucz.klucz_rozszerzony[16*i+1:16*i+16],(4,4)),i == klucz.iteracje)
    end
    
    tekst.tekst_zaszyfrowany = konwersja_na_hex(tekst.macierz_tekstu)
end

function runda_szyfrujaca(tekst,klucz,ostatnia_runda::Bool)
    for i in 1:16
        tekst[i] = s_box(tekst[i])
    end
    tekst = przesuniecie_w_lewo_macierz(tekst,2,1)
    tekst = przesuniecie_w_lewo_macierz(tekst,3,2)
    tekst = przesuniecie_w_lewo_macierz(tekst,4,3)
    if ostatnia_runda == 0
        for i in 1:4
            tekst[(i-1) * 4+1:(i-1)*4+4] = mnozenie_macierzy_xor(tekst[(i-1) * 4+1:(i-1)*4+4],0)
        end
    end
    tekst = xor_macierzy(klucz,tekst)
    return tekst
end

function deszyfrowanie(klucz::klucz_sesji,tekst::teksts)
    tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)

    if klucz.dlugosc_klucza == 16
        klucz.iteracje = -10
    elseif klucz.dlugosc_klucza == 24
        klucz.iteracje = -12
    elseif klucz.dlugosc_klucza == 32
        klucz.iteracje = -14
    end

    for i in klucz.iteracje:-1
        tekst.macierz_tekstu = runda_deszyfrujaca(tekst.macierz_tekstu,reshape(klucz.klucz_rozszerzony[16*(-i)+1:16*(-i)+16],(4,4)),i == klucz.iteracje)
    end

    tekst.macierz_tekstu = xor_macierzy(reshape(klucz.klucz_rozszerzony[1:16],(4,4)),tekst.macierz_tekstu)

    tekst.tekst_jawny = konwersja_na_string(tekst.macierz_tekstu)
end

function runda_deszyfrujaca(tekst,klucz,ostatnia_runda::Bool)

    tekst = xor_macierzy(klucz,tekst)

    if ostatnia_runda == 0
        for i in 1:4
            tekst[(i-1) * 4+1:(i-1)*4+4] = mnozenie_macierzy_xor(tekst[(i-1) * 4+1:(i-1)*4+4],1)
        end
    end

    tekst = przesuniecie_w_prawo_macierz(tekst,2,1)
    tekst = przesuniecie_w_prawo_macierz(tekst,3,2)
    tekst = przesuniecie_w_prawo_macierz(tekst,4,3)

    for i in 1:16
        tekst[i] = s_box_odwrotny(tekst[i])
    end
        
    return tekst
end

function mnozenie_macierzy_xor(kolumna,tryb)
    if tryb == 0 
        macierz_przeksztalcen = [2 3 1 1;1 2 3 1;1 1 2 3;3 1 1 2]
    else
        macierz_przeksztalcen = [14 11 13 9;9 14 11 13; 13 9 14 11; 11 13 9 14]
    end
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