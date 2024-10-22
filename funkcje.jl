#PRZESUWA BAJTY W LEWO WYKORZYSTYWANE PRZY ROZSZERZANIU KLUCZA
function przesun_w_lewo(fragment)
    buffor = fragment[1]
    for i in 1:3
        fragment[i] = fragment[i+1]
    end
    fragment[4] = buffor
    return fragment
end

#PODMIENIA ZNAK W HEX NA ODPOWIEDNIK W TABLICY
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

#WYKONUJE OPERACJE XOR NA DWUCH MACIERZACH
function xor_macierzy(fragment_klucza,tekst)
    for i in 1:16
        tekst[i] = tekst[i] ⊻ fragment_klucza[i]
    end
    return tekst
end

#PRZESUWA WIERSZ MACIERZY W LEWO
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