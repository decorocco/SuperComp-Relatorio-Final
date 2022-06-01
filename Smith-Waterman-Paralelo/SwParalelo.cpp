#include<iostream>
#include<algorithm>
using namespace std;

struct item{
    int valor;
    int linha;
    int coluna;
    int tipo; // diagonal = 1, deleção = 2, inserção = 3, zero = 4
};


int main(){
    int n = 0;
    int m = 0;

    int diagonal = 0;
    int delecao = 0;
    int insercao = 0;

    int maximo;

    item vMax;
    vMax.valor = 0;
    vMax.linha = 0;
    vMax.coluna = 0;
    vMax.tipo = 0;

    string sequencia;

    string a;
    string b;

    string sequenciaA;
    string sequenciaB;

    cin >> n >> m;
    cin >> a >> b;

    //cout << n << m << endl;

    item H[n+1][m+1];
    //cout << H[0][0] << endl;

    for (int i = 0; i <= n; i++){
        for (int j = 0; j <= m; j++){
            H[i][j].valor = 0;

            //cout << H[i][j].coluna << '-';
        }
        //cout << endl;
    }

    for (int i = 1; i <= n; i++){
        for (int j = 1; j <= m; j++){

            if (a[i-1] == b[j-1]) {
                diagonal = H[i-1][j-1].valor + 2;
            }
            else {
                diagonal = H[i-1][j-1].valor - 1;
            }

            delecao = H[i-1][j].valor - 1;
            insercao = H[i][j-1].valor - 1;

            if (diagonal >= delecao && diagonal >= insercao && diagonal >= 0){
                maximo = diagonal;
                H[i][j].tipo = 1;
            }
            else if (delecao >= diagonal && delecao >= insercao && delecao >= 0){
                maximo = delecao;
                H[i][j].tipo = 2;
            }
            else if (insercao >= diagonal && insercao >= delecao && insercao >= 0){
                maximo = insercao;
                H[i][j].tipo = 3;
            }
            else {
                maximo = 0;
                H[i][j].tipo = 4;
            }

            H[i][j].valor = maximo;

            if (H[i][j].valor > vMax.valor)
            {
                vMax.valor = H[i][j].valor;
                vMax.linha = i;
                vMax.coluna = j;
                vMax.tipo = H[i][j].tipo;
            }
        }
    }

    for (int i = 0; i <= n; i++){
        for (int j = 0; j <= m; j++){

            cout << H[i][j].valor << ' ';
        }
        cout << endl;
    }

    cout << "SCORE:  " << vMax.valor << endl;

    while (vMax.valor > 0 && vMax.linha > 0 && vMax.coluna > 0){
        if (vMax.tipo == 1) {
            sequenciaA += a[vMax.linha-1];
            sequenciaB += b[vMax.coluna-1];
            vMax.coluna--;
            vMax.linha--;
        }
        else if (vMax.tipo == 2) {
            sequenciaA += a[vMax.linha-1];
            sequenciaB += '-';
            vMax.linha--;
        }
        else if (vMax.tipo == 3) {
            sequenciaA += '-';
            sequenciaB += b[vMax.coluna-1];
            vMax.coluna--;
        }
        vMax.valor = H[vMax.linha][vMax.coluna].valor;
        vMax.tipo = H[vMax.linha][vMax.coluna].tipo;

    }

    reverse(sequenciaA.begin(), sequenciaA.end());
    cout << "Sequencia A:  " << sequenciaA << endl;
    reverse(sequenciaB.begin(), sequenciaB.end());
    cout << "Sequencia b:  " << sequenciaB << endl;

    return 0;
}