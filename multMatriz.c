#include <stdint.h>

// Definição das dimensões para matrizes quadradas 3x3
#define N 3

// Função Top-Level
// Entradas: A e B (inteiros de 8 bits positivos)
// Saída: R (inteiros de 16 bits)
void matrix_mult_3x3(uint8_t A[N][N], 
                     uint8_t B[N][N], 
                     uint16_t R[N][N]) {
//--------------------PIPELINE--------------------    
/*  #pragma HLS INTERFACE mode=bram port=A
    #pragma HLS INTERFACE mode=bram port=B
    #pragma HLS INTERFACE mode=bram port=R
    #pragma HLS INTERFACE mode=s_axilite port=return
    #pragma HLS PIPELINE II=1 */
    //II=1 liga o pipeline, off desliga, 
//------------------------------------------------    

//--------------------FLIPFLOPS-------------------    
	//matrizes em registradores individuais (acesso simultâneo ilimitado)
	#pragma HLS ARRAY_PARTITION variable=A complete dim=0
    #pragma HLS ARRAY_PARTITION variable=B complete dim=0
    //partição saida 
    #pragma HLS ARRAY_PARTITION variable=R complete dim=0
//------------------------------------------------   

    uint16_t soma;

    // Loop das linhas de A
    linha_loop: for (int i = 0; i < N; i++) {
        // Loop das colunas de B
        coluna_loop: for (int j = 0; j < N; j++) {
            soma = 0;
            
            // Loop do produto escalar (linha de A * coluna de B)
            produto_loop: for (int k = 0; k < N; k++) {
                // Multiplicação clássica de matrizes: Linha i de A * Coluna j de B
                soma += A[i][k] * B[k][j];
            }
            
            R[i][j] = soma;
        }
    }
}
