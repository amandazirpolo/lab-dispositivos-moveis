#include <stdio.h>
#QUANTUM 3

typedef struct processo {
    int tam;
    char *estado; 
    infos do processo ...
    int indice_fila;
    int indice_cpu;
    int indice_disco; 
} P;

typedef struct ucp {
    P *processos;
    int indice;
    // 0, 1, 2, 3
} CPU;

typedef struct disco {
    P *processos;
    int indice;
    // 0, 1, 2, 3
} MS;

typedef struct ram {
    P *processos;
    int tam = 32 gb;
} MP;

typedef struct fila {
    P *processos;
    int indice;
    // 0, 1, 2, 3
} FILA;

ram - tam processo > 0:
    aloca processo;

- perguntar a boeres se precisa criar algum tratamento para quando a ms está cheia 
e o processo a ser alocado nao cabe nela. 