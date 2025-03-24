Encryption and decryption of text using the AES symmetric algorithm in the Julia programming language.

To run the program, use the command include("main.jl") while in the project folder.
The Primes library is required for the program to function correctly.

The program uses CBC and ECB encryption modes and allows key generation using the Diffie-Hellman protocol. The key length is adjusted with the MD5 hashing function. Everything is implemented from scratch.

Encryption(command: szyfrowanie)
-p : Enter text manually
-P : Load text from a file
-k : Enter key manually
-K : Load key from a file
-s : Save key to a file
-S : Save encrypted text to a file
-d : Generate key using the Diffie-Hellman protocol
-m : Select encryption mode (CBC or ECB)
-g : Generate a random key (128, 192, or 256 bits)

Decryption(command: deszyfrowanie)
-c : Enter encrypted text manually
-C : Load encrypted text from a file
-k : Enter key manually
-K : Load key from a file
-m : Select encryption mode (CBC or ECB)

Example command:
szyfrowanie -p "politechnika" -K "klucz.txt" -m CBC
