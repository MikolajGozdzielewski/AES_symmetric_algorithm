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