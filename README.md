#  A cost efficient framework and algorithm for embedding dynamic virtual network requests
Matlab code implementation for the paper "cost efficient framework and algorithm for embedding dynamic virtual network requests"

# Project for CO463

This project is a matlab implementation of the paper "cost efficient framework and algorithm for embedding dynamic virtual network requests" which outputs various insights from the paper and visual analysis of the results.
The project compares 5 algorithms
  - DVNMA_NS -> The approach proposed in this work for reconfiguring the evolved virtual network without any share strategy
  - DVNMA_SS -> The approach proposed in this work for reconfiguring the evolved virtual network using the self share strategy while allocating bandwidth resources
  - DVNMA_SS -> The approach proposed in this work for reconfiguring the evolved virtual network using the mixed share strategy while allocating bandwidth resources
  - Greedy -> The extended algorithm in which the greedy strategy is used for greedily picking the substrate node having enough node resource tohost a virtual node
  - Static -> The extended algorithm in which the random picking strategy is used for selecting substrate node to host a virtual node.

### Motivation
The given research paper provides an in depth analysis of algorithms for embedding dynamic virtual network request. Our matlab
implementation is inspired to give a working model providing visual insights that would help in better understanding of the paper, comparing 
5 algorithms used in the paper hence enabling a larger audience to refer this work.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 
One can also use matlab online for the same.

## Prerequisites

### What things you need to install the software and how to install them

#### Following are the dependencies one has to install in their system
 ``` 
  - python 3.6.8 
  - python pip
  - matlab online / offline
  - matplotlib 3.4.0
 ```
#### After installing the above clone this repository and paste the folder in matlab environment.  
 
Using the matlab online one can upload all files of the folder 📂.

## Run

#### After downloading all the dependencies run the following files:- 
   
    - Generate_requests.m 
    - find_total_requests.m
    - performance.m
    - comparing.m
    - progressbar.m
    - test_optimal_embedding.m

## Outputs

Output on running compare.m file, data is then visualised using matplotlib

![WhatsApp Image 2021-03-31 at 7 31 20 PM](https://user-images.githubusercontent.com/37441702/113157206-4e197280-9258-11eb-9b29-bce34770f397.jpeg)

Output on running performance.m

![WhatsApp Image 2021-03-31 at 7 33 29 PM](https://user-images.githubusercontent.com/37441702/113157214-4fe33600-9258-11eb-86d3-06780b978dd7.jpeg)
![WhatsApp Image 2021-03-31 at 7 33 14 PM](https://user-images.githubusercontent.com/37441702/113157217-51146300-9258-11eb-971d-d3e054bf42f3.jpeg)



## Authors
  - [Rishi Sharma](https://github.com/kampaitees)
  - [Sharmila Biswas](https://github.com/Shormi5399)
  - [Vedant Mehra](https://github.com/vmehra25)
  - [Abha Wadjikar](https://github.com/abha224)

