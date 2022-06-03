#include <iostream>
#include <chrono>
#include <algorithm>
#include <cmath>
#include <random>
#include <bits/stdc++.h>
#include <vector>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/fill.h>


using namespace std;

struct subseq{
    int begin_sa;
    int len_sa;
    int begin_sb;
    int len_sb;
};

struct score{
    __host__ __device__ int operator()(const char &a, const char &b) {
        if (a == b) {
            return 2;
        }
        else {
            return -1;
        }
    }
};


int main(){
    int n = 0;
    int m = 0;

    cin >> n >> m;

    int len_maior = n;
    int len_menor = m;

    string a;
    string b;

    cin >> a >> b;

    thrust::host_vector<char> host_a(len_maior);
    thrust::host_vector<char> host_b(len_menor);
    

    for (int i = 0; i <= len_maior; i++){
        host_a[i] = a[i];
    }

    for (int i = 0; i <= len_menor; i++){
        host_b[i] = b[i];
    }

    thrust::device_vector<char> device_a(host_a);
    thrust::device_vector<char> device_b(host_b);

    vector<subseq> subseqs;
    subseq sub;

    for (int i = 0; i < len_menor; i++) {
        for (int j = 0; j < len_maior; j++) {
            if (j + i <= len_maior) {
                for (int k = 0; k < len_menor; k++) {
                    if (k+1 <= len_maior) {
                        sub.begin_sa = j;
                        sub.begin_sb = k;
                        sub.len_sa = i + j;
                        sub.len_sb = i + k;
                        subseqs.push_back(sub);
                    }
                }
            }
        }
    }

    vector<int> scores;
    //int len_subseqs = subseqs.size();
    int hs = -1;
    thrust::device_vector<char> res(len_menor);

    for (int i = 0; i < subseqs.size(); i++) {
        thrust::transform(device_a.begin() + subseqs[i].begin_sa, device_a.end() + subseqs[i].len_sa,
                          device_b.begin() + subseqs[i].begin_sb, res.begin(), score());
    

        int reduce_score = thrust::reduce(res.begin(), res.end(), (int)0, thrust::plus<int>());

        if (reduce_score > hs) {
            hs = reduce_score;
        }
    }

    cout << hs << endl;

    return 0;
} 