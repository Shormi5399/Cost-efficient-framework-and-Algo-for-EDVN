#  A cost efficient framework and algorithm for embedding dynamic virtual network requests
Implementation for the paper "cost efficient framework and algorithm for embedding dynamic virtual network requests". <br>
Link: [ A cost efficient framework and algorithm for embedding dynamic virtual network requests](https://dl.acm.org/doi/10.1016/j.future.2012.08.002)

# Project for CO463

This project is a matlab implementation of the paper "**cost efficient framework and algorithm for embedding dynamic virtual network requests**" which outputs various insights from the paper and visual analysis of the results.

The project compares 5 algorithms
 1. **DVNMA_NS** -> The approach proposed in the paper for reconfiguring the evolved virtual network without any share strategy
 2. **DVNMA_SS** -> The approach proposed in the paper for reconfiguring the evolved virtual network using the self share strategy while allocating bandwidth resources
 3. **DVNMA_SS** -> The approach proposed in the paper for reconfiguring the evolved virtual network using the mixed share strategy while allocating bandwidth resources
 4. **Greedy algorithm** -> Algorithm in which the greedy strategy is used for greedily picking the substrate node having enough node resource tohost a virtual node
 5. **Static algorithm** -> Algorithm in which the VN requests are static i.e., the VN request topology does not change.
 
 
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
  - matlab online / Matlab R2021a (offline)
  - matplotlib 3.4.0
 ```
#### After installing the above clone this repository and paste the folder in matlab environment.  
 
Using the matlab online you can upload all files of the folder 📂.

## Run

#### After downloading all the dependencies run the following files:- 
   
    - Generate_requests.m 
    - find_total_requests.m
    - performance.m
    - comparing.m
    - test_optimal_embedding.m

## Results

Output received on running compare.m file, is then visualised using matplotlib.

![WhatsApp Image 2021-03-31 at 7 31 20 PM](https://user-images.githubusercontent.com/37441702/113157206-4e197280-9258-11eb-9b29-bce34770f397.jpeg)

Output on running performance.m

![WhatsApp Image 2021-03-31 at 7 33 29 PM](https://user-images.githubusercontent.com/37441702/113157214-4fe33600-9258-11eb-86d3-06780b978dd7.jpeg)
![WhatsApp Image 2021-03-31 at 7 33 14 PM](https://user-images.githubusercontent.com/37441702/113157217-51146300-9258-11eb-971d-d3e054bf42f3.jpeg)


## Contributors
  - [Rishi Sharma](https://github.com/kampaitees)
  - [Sharmila Biswas](https://github.com/Shormi5399)
  - [Vedant Mehra](https://github.com/vmehra25)
  - [Abha Wadjikar](https://github.com/abha224)

