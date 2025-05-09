#ZAMIANA TEKSTU W UNICODE NA DECYMALNY
function konwersja_tekstu(tekst)
    macierz = zeros(Int,4,4)
    dlugosc = length(tekst)
    for i in 1:dlugosc
        macierz[i] = codepoint(tekst[i])
    end
    return macierz
end

#ZAMIANA LICZB NA STRING W HEX
function konwersja_na_hex(macierz)
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

function konwersja_z_hex(tekst)
    macierz = zeros(Int,4,4)
    for i in 1:16
        macierz[i] = parse(UInt8,tekst[(i-1)*2+1:(i-1)*2+2],base=16)
    end
    return macierz
end

function konwersja_na_string(macierz)
    tekst = ""
    for i in 1:16
        if macierz[i] > 16
            tekst = string(tekst,Char(macierz[i]))
        else
            break
        end
    end
    return tekst
end
