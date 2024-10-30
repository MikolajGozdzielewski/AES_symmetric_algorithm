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