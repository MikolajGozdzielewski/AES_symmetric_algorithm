#GENERUJE KLUCZ
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

#PRZEPISUJE KLUCZ PODSTAWOWY ZE STRINGA DO ARRAY
function przepisanie_klucza(pod,roz,dlugosc_klucza)
    for i in 1:dlugosc_klucza
        roz[i] = parse(UInt8,pod[(i*2-1):(i*2)],base=16)
    end
end

#ROZSZERZA KLUCZ
function rozszerzenie_klucza(klucz,dlugosc_klucza)
    if dlugosc_klucza == 16
        ilosc_powtorzen = 10
    elseif dlugosc_klucza == 24
        ilosc_powtorzen = 8
    elseif dlugosc_klucza == 32
        ilosc_powtorzen = 9
    end
    for i in 1:ilosc_powtorzen

        #NOWE 4 BAJTY
        dlugosc = length(klucz)
        buffor = klucz[dlugosc-3:dlugosc]
        buffor = przesun_w_lewo(buffor)
        for j in 1:4
            buffor[j] = s_box(buffor[j])
        end
        if i < 9
            rcon = buffor[1] ⊻ 2^(i-1)
        elseif i == 9
            rcon = buffor[1] ⊻ 27
        elseif i ==10
            rcon = buffor[1] ⊻ 54
        elseif i ==11
            rcon = buffor[1] ⊻ 108
        elseif i ==12
            rcon = buffor[1] ⊻ 216
        elseif i ==13
            rcon = buffor[1] ⊻ 171
        elseif i ==14
            rcon = buffor[1] ⊻ 77
        end
        if (rcon > 255)
            rcon = mod(rcon,256)
        end
        buffor[1] = rcon
        for j in 1:4
            buffor[j] = buffor[j] ⊻ klucz[dlugosc - dlugosc_klucza + j]
            push!(klucz,buffor[j])
        end
        
        

        #NOWE 12 BAJTÓW
        for j in 1:3
            dlugosc = length(klucz)
            for k in 1:4
                push!(klucz,klucz[dlugosc - 4 + k] ⊻ klucz[dlugosc - dlugosc_klucza + k])
            end
        end

        if dlugosc_klucza != 16 && i == ilosc_powtorzen
            break
        end

        #DLA 256-bitowego klucza
        if dlugosc_klucza == 32
            dlugosc = length(klucz)
            buffor = klucz[dlugosc-3:dlugosc]
            for j in 1:4
                buffor[j] = s_box(buffor[j])
            end
            for j in 1:4
                buffor[j] = buffor[j] ⊻ klucz[dlugosc - dlugosc_klucza + j]
                push!(klucz,buffor[j])
            end
        end




        #DLA 192 i 256-bitowego klucza
        if dlugosc_klucza != 16
            if dlugosc_klucza == 24
                kroki = 2
            elseif dlugosc_klucza == 32
                kroki = 3
            end
            for j in 1:kroki
                dlugosc = length(klucz)
                buffor = klucz[dlugosc-3:dlugosc]
                for k in 1:4
                    buffor[k] = buffor[k] ⊻ klucz[dlugosc - dlugosc_klucza + k]
                    push!(klucz,buffor[k])
                end
            end
        end


    end
    return klucz
end