# projetAssembleur

## Commande pour assembler 
```
nasm -felf64 -Fdwarf -g -l find_min.lst find_min.asm -o find_min.o
nasm -felf64 -Fdwarf -g -l find_max.lst find_max.asm -o find_max.o
nasm -felf64 -Fdwarf -g -l rand.lst rand.asm -o rand.o
nasm -felf64 -Fdwarf -g -l main.lst main.asm -o main.o
gcc -fPIC -no-pie find_min.o find_max.o rand.o main.o -o final
```