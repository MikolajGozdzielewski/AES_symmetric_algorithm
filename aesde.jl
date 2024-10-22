function deszyfrowanie(klucz::klucz_sesji,tekst::teksts)
    tekst.macierz_tekstu = konwersja_z_hex(tekst.tekst_zaszyfrowany)
    print(tekst.macierz_tekstu)
    if klucz.dlugosc_klucza == 16
        klucz.iteracje = 10
    elseif klucz.dlugosc_klucza == 24
        klucz.iteracje = 12
    elseif klucz.dlugosc_klucza == 32
        klucz.iteracje = 14
    end
    
end