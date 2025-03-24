using Primes
include("generacjaklucza.jl")

const global ile_bitow_wartosci_publicznej = 10;

mutable struct liczby_dh
    a::UInt128
    b::UInt128
    p::UInt128
    g::UInt128
    A::UInt128
    B::UInt128
    ka::UInt128
    kb::UInt128
end

function diffiehellman()
    liczby = liczby_dh(0,0,0,0,0,0,0,0)
    liczby = losowanie_dh(liczby)
    liczby.g = pierwiastek_pierwotny(liczby.p)
    liczby.A = powermod(liczby.g,liczby.a,liczby.p)
    liczby.B = powermod(liczby.g,liczby.b,liczby.p)
    liczby.ka = powermod(liczby.B,liczby.a,liczby.p)
    liczby.kb = powermod(liczby.A,liczby.b,liczby.p)
    if liczby.ka == liczby.kb
        return(liczby.ka)
    else
        print("fail")
        return 0
    end
end

function losowanie_dh(liczby::liczby_dh)
    liczba = generacja_klucza(16)
    liczby.a = parse(UInt128,liczba,base=16)
    liczba = generacja_klucza(16)
    liczby.b = parse(UInt128,liczba,base=16)
    liczba = generacja_klucza(ile_bitow_wartosci_publicznej)
    liczby.p = parse(BigInt,liczba,base=16)
    while isprime(liczby.p) != 1
        liczba = generacja_klucza(ile_bitow_wartosci_publicznej)
        liczby.p = parse(BigInt,liczba,base=16)
    end
    return liczby
end

function pierwiastek_pierwotny(n)
    if n == 2
        return 1
    end 
    phi = n - 1
    phifactor = collect(keys(factor(phi)))
    for i in 2:phi
        znaleziony_pierwiastek = true
        for j in phifactor
            if powermod(i,div(phi,j),n) == 1
                znaleziony_pierwiastek = false
                break;
            end
        end
        if znaleziony_pierwiastek == true
            return i
        end
    end
end

#diffiehellman()
