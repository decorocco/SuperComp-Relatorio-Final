#include <iostream>
#include <chrono>
#include <algorithm>
#include <cmath>
#include <bits/stdc++.h>
#include <vector>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/sequence.h>
#include <thrust/tuple.h>

using namespace std;

struct atrib {
    __host__ __device__ int operator()(const int &a, const int &b) {
        if ((a-1) > 0 && (a-1) > b) {
          return (a-1);
        }
        if ((a-1) > 0 && b == (a-1)) {
          return (a-1);
        }
        if (b > 0 && b > (a-1)) {
            return b;
        }
        else {
            return 0;
        }
    }
};

struct comp {
  int linha;
  int coluna;
  char valor;

  comp(int valor_pos): valor(valor_pos){};
  __host__ __device__ int operator()(const thrust::tuple<char, int, int>& tupla) {
    coluna = thrust::get<2>(tupla)-1;

    if (valor == thrust::get<0>(tupla)) {
      linha = thrust::get<1>(tupla)+2;
    }
    else {
      linha = thrust::get<1>(tupla)-1;
    }

    if (linha > 0 && linha > coluna) {
      return linha;
    }
    if (coluna > 0 && coluna > linha) {
      return coluna;
    }
    if (linha > 0 && linha==coluna) {
      return linha;
    }
    else {
      return 0;
    }
  }
};


int main(){
    int n;
    int m;
    string a;
    string b;
    int hs = 0;

    cin >> n >> m;
    cin >> a >> b;

    if (m > n) {
      swap(a,b);
      swap(n,m);
    }

    thrust::device_vector<char> device_a(n+1);
    thrust::device_vector<char> device_b(m+1);
    thrust::device_vector<int> temp(m+1);
    thrust::device_vector<int> res(m+1);

    a = '_' + a;
    b = '_' + b;

    for (int i = 0; i < int(a.size()); i++) {
      device_a[i] = a[i];
    }
    for (int i = 0; i < int(b.size()); i++) {
      device_b[i] = b[i];
    }

    for (int i = 0; i < int(a.size()) - m; i++) {

      thrust::fill(res.begin(), res.end(), 0);
      for (int j = 0; j < m+1; j++) {
        int s = 0;
        thrust::transform(thrust::make_zip_iterator(thrust::make_tuple(device_b.begin()+1, res.begin(),res.begin()+1)),
                            thrust::make_zip_iterator(thrust::make_tuple(device_b.begin()+m+1, res.begin()+m, res.begin()+m+1)),
                            temp.begin()+1, 
                            comp(device_a[j+i])); 
        thrust::inclusive_scan(temp.begin(),temp.begin()+m,res.begin(),atrib()); 
        s = thrust::reduce(res.begin(),res.begin()+m,(int) 0,thrust::maximum<int>());
        if (s > hs){
            hs = s;
        }
      }
    }

    if ((2 * m) == (hs + 2)) {
      hs += 2;
    }

    cout << hs << endl;

    return 0;
} 