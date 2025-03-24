function ecb(pelen_tekst,tekst,klucz)
    tekst_zaszyfrowany = ""
    for i in 1:div(length(pelen_tekst),16)
        tekst.tekst_jawny = string(pelen_tekst[16 * (i - 1) + 1:16 * (i - 1) + 16])
        tekst.macierz_tekstu = konwersja_tekstu(tekst.tekst_jawny)
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
    end
    if mod(length(pelen_tekst),16) == 0
        tekst.macierz_tekstu = zeros(Int,4,4)
        for i in 1:16
            tekst.macierz_tekstu[i] = 16
        end
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
    end
    if mod(length(pelen_tekst),16) != 0;
        tekst.tekst_jawny = string(pelen_tekst[16 * div(length(pelen_tekst),16) + 1:16 * div(length(pelen_tekst),16) + mod(length(pelen_tekst),16)])
        tekst.macierz_tekstu = konwersja_tekstu(tekst.tekst_jawny)
        for i in 1:16
            if tekst.macierz_tekstu[i] == 0
                tekst.macierz_tekstu[i] = 16 - mod(length(pelen_tekst),16)
            end
        end
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
    end
    return tekst_zaszyfrowany
end

function ecb_de(pelen_szyfr,tekst,klucz)
    tekst_jawny = ""
    for i in 1:div(length(pelen_szyfr),32)
        tekst.tekst_zaszyfrowany = string(pelen_szyfr[32 * (i - 1) + 1:32 * (i - 1) + 32])
        tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)
        deszyfrowanie(klucz,tekst)
        tekst.tekst_jawny = konwersja_na_string(tekst.macierz_tekstu)
        tekst_jawny = string(tekst_jawny,tekst.tekst_jawny)
    end
    if mod(length(pelen_szyfr),32) != 0;
        tekst.tekst_zaszyfrowany = string(pelen_szyfr[32 * div(length(pelen_szyfr),32) + 1:32 * div(length(pelen_szyfr),32) + mod(length(pelen_szyfr),32)])
        tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)
        deszyfrowanie(klucz,tekst)
        tekst.tekst_jawny = konwersja_na_string(tekst.macierz_tekstu)
        tekst_jawny = string(tekst_jawny,tekst.tekst_jawny)
    end
    return tekst_jawny
end

function cbc(pelen_tekst,tekst,klucz)
    tekst_zaszyfrowany = ""
    wektoriv = zeros(Int,4,4)
    for i in 1:div(length(pelen_tekst),16)
        tekst.tekst_jawny = string(pelen_tekst[16 * (i - 1) + 1:16 * (i - 1) + 16])
        tekst.macierz_tekstu = konwersja_tekstu(tekst.tekst_jawny)
        tekst.macierz_tekstu = xor_macierzy(wektoriv,tekst.macierz_tekstu)
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
        wektoriv = konwersja_z_hex(tekst.tekst_zaszyfrowany)
    end
    
    if mod(length(pelen_tekst),16) == 0
        tekst.macierz_tekstu = zeros(Int,4,4)
        for i in 1:16
            tekst.macierz_tekstu[i] = 16
        end
        tekst.macierz_tekstu = xor_macierzy(wektoriv,tekst.macierz_tekstu)
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
    end

    if mod(length(pelen_tekst),16) != 0
        tekst.tekst_jawny = string(pelen_tekst[16 * div(length(pelen_tekst),16) + 1:16 * div(length(pelen_tekst),16) + mod(length(pelen_tekst),16)])
        tekst.macierz_tekstu = konwersja_tekstu(tekst.tekst_jawny)
        for i in 1:16
            if tekst.macierz_tekstu[i] == 0
                tekst.macierz_tekstu[i] = 16 - mod(length(pelen_tekst),16)
            end
        end
        tekst.macierz_tekstu = xor_macierzy(wektoriv,tekst.macierz_tekstu)
        szyfrowanie(klucz,tekst)
        tekst_zaszyfrowany = string(tekst_zaszyfrowany,tekst.tekst_zaszyfrowany)
    end
    return tekst_zaszyfrowany
end

function cbc_de(pelen_szyfr,tekst,klucz)
    
    tekst_jawny = ""
    wektoriv = zeros(Int,4,4)
    wektorivbuffor = zeros(Int,4,4)
    for i in 1:div(length(pelen_szyfr),32)
        wektoriv = wektorivbuffor
        tekst.tekst_zaszyfrowany = string(pelen_szyfr[32 * (i - 1) + 1:32 * (i - 1) + 32])
        tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)
        wektorivbuffor = copy(tekst.macierz_tekstu)
        deszyfrowanie(klucz,tekst)
        tekst.macierz_tekstu = xor_macierzy(wektoriv,tekst.macierz_tekstu)
        tekst.tekst_jawny = konwersja_na_string(tekst.macierz_tekstu)
        tekst_jawny = string(tekst_jawny,tekst.tekst_jawny)
    end
    if mod(length(pelen_szyfr),32) != 0
        wektoriv = wektorivbuffor
        tekst.tekst_zaszyfrowany = string(pelen_szyfr[32 * div(length(pelen_szyfr),32) + 1:32 * div(length(pelen_szyfr),32) + mod(length(pelen_szyfr),32)])
        tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)
        deszyfrowanie(klucz,tekst)
        tekst.macierz_tekstu = xor_macierzy(wektoriv,konwersja_tekstu(tekst.tekst_jawny))
        tekst.tekst_jawny = konwersja_na_string(tekst.macierz_tekstu)
        tekst_jawny = string(tekst_jawny,tekst.tekst_jawny)
    end
    return tekst_jawny
end
