#include <iostream>
#include <algorithm>
#include <random>
#include <omp.h>
using namespace std;


int score(string sa, string sb) {
    int result = 0;
    for(int i = 0; i < int(sa.size()); i++){
        if (sa[i] == sb[i]) {
            result += 2;
        }
        else if (sa[i] == '-' || sb[i] == '-') {
            result -= 1;
        }
        else {
            result -= 2;
        }
    }
    return result;
}

int main() {
    int n;
    int m;
    string a;
    string b;
    vector<string> vsa;
    vector<string> vsb;
    string sa;
    string sb;
    int s = 0;
    int hs = 0;
    string bigs;
    string smalls;

    omp_set_num_threads(4);

    cin >> n >> m;
    cin >> a >> b;

    for (int i = 0; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            vsa.push_back(a.substr(i, j));
        }
    }

    for (int i = 0; i <= m; i++) {
        for (int j = 1; j <= m; j++) {
            vsb.push_back(b.substr(i, j));
        }
    }

    #pragma omp parallel for reduction(max:hs)

    for(int i = 0; i < int(vsa.size()); i++){
        for(int j = 0; j < int(vsb.size()); j++){
            if (int(vsa[i].size()) == int(vsb[j].size())) {
                s = score(vsa[i], vsb[j]);
                if (s > hs) {
                    hs = s;
                    sa = vsa[i];
                    sb = vsb[j];
                }
            }
        }
    }

    cout << "score: " << hs << endl;

    return 0;
}