const global A = 1732584193
const global B = 4023233417
const global C = 2562383102
const global D = 271733878

mutable struct struktury_md5
    A::UInt32
    B::UInt32
    C::UInt32
    D::UInt32
    wektor::Array{UInt32}
    K::Array{UInt32}
end

function md5()
    wejscie = "6162636465666768696A6162636465666768696A6162636465666768696A6162636465666768696A6162636465666768696A"
    zmd5 = struktury_md5(A,B,C,D,przygotowanie_do_md5(wejscie),stale_K())
    zamiana(zmd5.wektor)
    for i in 1:64
        operacja(zmd5,i)
    end
    czescA = string(dodawanie_modularne_32(A,zmd5.A),base=16)
    czescB = string(dodawanie_modularne_32(B,zmd5.B),base=16)
    czescC = string(dodawanie_modularne_32(C,zmd5.C),base=16)
    czescD = string(dodawanie_modularne_32(D,zmd5.D),base=16)
    wynik = string(czescA,czescB,czescC,czescD)
    wynik = zamiana_string(wynik)
    print(wynik)
end

function przygotowanie_do_md5(wejscie)
    dlugosc = length(wejscie) * 4
    wejscie_wektor = zeros(16)

    #DODANIE 1
    wejscie = string(wejscie,"80")

    while mod(length(wejscie),8) != 0
        wejscie = string(wejscie,"00")
    end

    for i in 1:Int(length(wejscie)/8)
        wejscie_wektor[i] = parse(UInt32,wejscie[(i-1)*8+1:(i-1)*8+8],base=16)
    end
    
    if dlugosc >= 2^32
        wejscie_wektor[15] = mod(dlugosc,2^32)
        wejscie_wektor[16] = (dlugosc -mod(dlugosc,2^32)) / 2^32
    else
        wejscie_wektor[15] = dlugosc
    end

    return wejscie_wektor
end

function zamiana(wektor)
    for i in 1:14
        nowy_hex = ""
        hex = string(wektor[i],base=16)
        while length(hex) != 8
            hex = string("0",hex)
        end
        for j in -4:-1
            nowy_hex = string(nowy_hex,hex[(-j)*2-1:(-j)*2])
        end
        wektor[i] = parse(UInt32,nowy_hex,base=16)
    end
end

function zamiana_string(str)
    nowy_str = ""
    for i in 1:4
        for j in -4:-1
            nowy_str = string(nowy_str,str[(-j)*2-1+(i-1)*8:(-j)*2+(i-1)*8])
        end
    end
    return nowy_str
end

function stale_K()
    wektor_K = zeros(64)
    for i in 1:64
        wektor_K[i] = floor(abs(sin(i))*2^32)
    end
    return wektor_K
end

function F_funkcja(B,C,D)
    return (B & C) | ((~B) & D)
end

function G_funkcja(B,C,D)
    return (B & D) | ((~D) & C)
end

function H_funkcja(B,C,D)
    return B ⊻ C ⊻ D
end

function I_funkcja(B,C,D)
    return C ⊻ (B | (~D))
end

function dodawanie_modularne_32(a,b)
    return mod(a+b,2^32)
end

function przesuniecie_bity_lewo(liczba,ile)
    for i in 1:ile
        if liczba >= 2^31
            przeskok = 1
            liczba = liczba - 2^31
        else
            przeskok = 0
        end
        liczba = liczba << 1
        if przeskok == 1
            liczba = liczba + 1
        end
    end
    return liczba
end

function operacja(zmd5,i)
    S = [7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22 5 9 14 20 5 9 14 20 5 9 14 20 5 9 14 20 4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 23 6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21]
    if i <= 16
        wynik = F_funkcja(zmd5.B,zmd5.C,zmd5.D)
        krok = i
    elseif i <= 32
        wynik = G_funkcja(zmd5.B,zmd5.C,zmd5.D)
        krok = mod(5*(i-1)+2,16)
    elseif i <= 48
        wynik = H_funkcja(zmd5.B,zmd5.C,zmd5.D)
        krok = mod(3*(i-1)+6,16)
    else
        wynik = I_funkcja(zmd5.B,zmd5.C,zmd5.D)
        krok = mod(7*(i-1)+1,16)
    end
    if krok == 0
        krok = 16
    end
    wynik = dodawanie_modularne_32(zmd5.A,wynik)
    wynik = dodawanie_modularne_32(wynik,zmd5.wektor[krok])
    wynik = dodawanie_modularne_32(wynik,zmd5.K[i])
    wynik = przesuniecie_bity_lewo(wynik,S[i])
    wynik = dodawanie_modularne_32(wynik,zmd5.B)
    zmd5.A = zmd5.D
    zmd5.D = zmd5.C
    zmd5.C = zmd5.B
    zmd5.B = wynik
end

md5()