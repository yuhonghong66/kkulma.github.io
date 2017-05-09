In the [previous post](https://kkulma.github.io/2017-04-24-determining-optimal-number-of-clusters-in-your-data/) I showed several methods that can be used to determine the optimal number of clusters in your data - this often needs to be defined for the actual clustering algorithm to run. Once it's run, however, there's no guarantee that those clusters are stable and reliable.

**In this post I'll show a couple of tests for cluster validation that can be easily run in `R`.**

Let's start!

<br>

VALIDATION MEASURES
-------------------

### INTERNAL MEASURES

As the name suggests, internal validation measures rely on information in the data only, that is the characteristics of the clusters themselves, such as compactness and separation. In the perfect world we want our clusters to be as compact and separated as possible. How can this be measured?

**CONNECTIVITY**

This measure reflects the extent to which items that are placed in the same cluster are also considered their nearest neighbors in the data space - or, in other words, the degree of connectedness of the clusters. And yes, you guessed it, **it should be minimised**.

<br>

**SILHOUETTE WIDTH**

This index defines compactness based on the pairwise distances between all elements in the cluster, and separation based on pairwise distances between all points in the cluster and all points in the closest other cluster ([Van Craenendonck & Blockeel 2015](https://lirias.kuleuven.be/bitstream/123456789/504712/1/automl_camera.pdf)) We used `silhouette` function to asses the optimal number of clusters in the previous post - and like there, **the values as close to (+) 1 as possible are mose desirable**.

<br>

**DUNN INDEX**

Dunn Index represents the ratio of the smallest distance between observations not in the same cluster to the largest intra-cluster distance. As you can imagine, the nominator should be maximised and the denomitor minimised, **therefore the index should be maximized**.

(you can find a more detailed description of various internat cluster validation measures and their performance in this [Hui Xiong's paper](datamining.rutgers.edu/publication/internalmeasures.pdf).)

<br>

### STABILITY MEASURES

A slightly different approach is to assess the suitability of clustering algorithm by testing how sensitive it is to perturbations in the input data. In `clValid` package this means removing each column one at a time and re-rnning the clustering. There are several measures included, such as *average proportion of non-overlap* (APN), the *average distance* (AD),the *average distance between means* (ADM), and the *figure of merit* (FOM), all of which should be **minimised**.

Stability of clusters can be also computed using `fpc::clusterboot()` function, however the *perturbations in the input data* is a bit different here: it's done by resampling the data in a chosen way (e.g. bootstraping).

### BIOLOGICAL MEASURES

These measures can be only applied to the narrow class of biological data, such as microarray or RNAseq data where observations correspond to genes. Essentially, biological validation evaluates the ability of a clustering algorithm to produce biologically meaningful clusters.

To find out more about all these measures, check out the `clValid` vignette by opening the [link](https://www.google.co.uk/url?sa=t&rct=j&q=&esrc=s&source=web&cd=8&cad=rja&uact=8&sqi=2&ved=0ahUKEwiSzaO5lNfTAhWKA8AKHVDRD88QFghaMAc&url=http%3A%2F%2Fhbanaszak.mjr.uw.edu.pl%2FTempTxt%2FBrockEtAl_2008_CIValidAnRPackageForClusterValidation.pdf&usg=AFQjCNGeuXuGr1_CugB1rLygXSojbs1DvQ&sig2=EkSz5W04IXOfCAUSQBLKvw) or by typing `?clValid` in your R console.

<br>

EXAMPLES
--------

Enough of theory! Let's have a look at the R code and some examples.

I'll rely on the scaled `wine` dataset that I used in my [previous post](https://kkulma.github.io/2017-04-24-determining-optimal-number-of-clusters-in-your-data/)). I'm not going to evaluate ALL clustering algorithms described there, but this will be enough to give you an idea how to run the cluster validation on your dataset.

### Clusterwise cluster stability assessment by resampling (fpc::clusterboot())

After preparing the data...

``` r
library(gclus)
library(ggplot2)
library(dplyr)

data(wine)
scaled_wine <- scale(wine) %>% as.data.frame()
scaled_wine2 <- scaled_wine[-1]
```

<br>

... let's validate a simple k-means algorithm using stability measures using `fpc::clusterboot()`. In my previous post, depending on the clustering method, I obtained different number of possible "best" clusters: 2,3,4 and 15. I'll now test each of these options by bootstrapping the orginal dataset 100 times:

``` r
library(fpc)

set.seed(20)
km.boot2 <- clusterboot(scaled_wine2, B=100, bootmethod="boot",
                        clustermethod=kmeansCBI,
                        krange=2, seed=20)

km.boot3 <- clusterboot(scaled_wine2, B=100, bootmethod="boot",
                        clustermethod=kmeansCBI,
                        krange=3, seed=20)

km.boot4 <- clusterboot(scaled_wine2, B=100, bootmethod="boot",
                        clustermethod=kmeansCBI,
                        krange=4, seed=20)


km.boot15 <- clusterboot(scaled_wine2, B=100, bootmethod="boot",
                        clustermethod=kmeansCBI,krange=15, seed=20)
```

<br>

Have a look at the results below. Keep in mind that

1.  Clusterwise Jaccard bootstrap mean should be **maximised**
2.  number of dissolved clusters should be **minimised** and
3.  number of recovered clusters should be **maximised** and as close to the number of pre-defined bootstraps as possible

``` r
print(km.boot2)
```

    ## * Cluster stability assessment *
    ## Cluster method:  kmeans 
    ## Full clustering results are given as parameter result
    ## of the clusterboot object, which also provides further statistics
    ## of the resampling results.
    ## Number of resampling runs:  100 
    ## 
    ## Number of clusters found in data:  2 
    ## 
    ##  Clusterwise Jaccard bootstrap (omitting multiple points) mean:
    ## [1] 0.8865301 0.8737611
    ## dissolved:
    ## [1] 3 3
    ## recovered:
    ## [1] 87 79

``` r
print(km.boot3)
```

    ## * Cluster stability assessment *
    ## Cluster method:  kmeans 
    ## Full clustering results are given as parameter result
    ## of the clusterboot object, which also provides further statistics
    ## of the resampling results.
    ## Number of resampling runs:  100 
    ## 
    ## Number of clusters found in data:  3 
    ## 
    ##  Clusterwise Jaccard bootstrap (omitting multiple points) mean:
    ## [1] 0.9784658 0.9532739 0.9693787
    ## dissolved:
    ## [1] 1 2 0
    ## recovered:
    ## [1] 99 98 99

``` r
print(km.boot4)
```

    ## * Cluster stability assessment *
    ## Cluster method:  kmeans 
    ## Full clustering results are given as parameter result
    ## of the clusterboot object, which also provides further statistics
    ## of the resampling results.
    ## Number of resampling runs:  100 
    ## 
    ## Number of clusters found in data:  4 
    ## 
    ##  Clusterwise Jaccard bootstrap (omitting multiple points) mean:
    ## [1] 0.5734544 0.4196592 0.8783064 0.6995180
    ## dissolved:
    ## [1] 30 85  2 10
    ## recovered:
    ## [1]  8  7 89 37

``` r
print(km.boot15)
```

    ## * Cluster stability assessment *
    ## Cluster method:  kmeans 
    ## Full clustering results are given as parameter result
    ## of the clusterboot object, which also provides further statistics
    ## of the resampling results.
    ## Number of resampling runs:  100 
    ## 
    ## Number of clusters found in data:  15 
    ## 
    ##  Clusterwise Jaccard bootstrap (omitting multiple points) mean:
    ##  [1] 0.5906143 0.6545620 0.4729595 0.7117276 0.4056387 0.5572698 0.5706721
    ##  [8] 0.5678161 0.7510311 0.4268624 0.4443128 0.5212228 0.5508409 0.6876913
    ## [15] 0.3160002
    ## dissolved:
    ##  [1] 35 30 70 23 82 54 44 48 31 75 74 48 50 37 90
    ## recovered:
    ##  [1] 24 32 10 48  4 25 29 25 60  8  5  6 26 48  1

<br>

According to the above guidelines, it looks like 3 clusters are most stable out of all tested options.

### Multivariate validation of cluster results (clValid package)

Now, let's validate several different clustering algorithms at the same time using internal and stability measures. `clValid` package makes it easy to compare all those measures for different clustering methods across different number of clusters (from 3 to 15). In fact, this can be done in 2 (rather long) lines of code:

``` r
library(clValid)
library(kohonen)
library(mclust)

# transfrm data.frame into matrix
m_wine <- as.matrix(scaled_wine2)

valid_test <- clValid(m_wine, c(2:4, 15),
                      clMethods = c("hierarchical", "kmeans",  "pam" ),
                      validation = c("internal", "stability")
)
```

``` r
summary(valid_test)
```

    ## 
    ## Clustering Methods:
    ##  hierarchical kmeans pam 
    ## 
    ## Cluster sizes:
    ##  2 3 4 15 
    ## 
    ## Validation Measures:
    ##                                   2        3        4       15
    ##                                                               
    ## hierarchical APN             0.0060   0.0349   0.0705   0.0991
    ##              AD              4.8351   4.7541   4.6705   3.0421
    ##              ADM             0.0567   0.1705   0.3321   0.4131
    ##              FOM             0.9973   0.9923   0.9894   0.6834
    ##              Connectivity    2.9290   9.9492  17.0651  75.0897
    ##              Dunn            0.3711   0.2243   0.2307   0.3094
    ##              Silhouette      0.2591   0.1575   0.1490   0.1781
    ## kmeans       APN             0.1255   0.0470   0.1851   0.3079
    ##              AD              4.2577   3.6137   3.6186   2.9210
    ##              ADM             0.6454   0.2231   0.7547   0.9147
    ##              FOM             0.9139   0.7842   0.7728   0.7000
    ##              Connectivity   37.6512  28.0504  61.1659 160.6163
    ##              Dunn            0.1357   0.2323   0.1621   0.2620
    ##              Silhouette      0.2593   0.2849   0.2128   0.1516
    ## pam          APN             0.0907   0.1191   0.1641   0.3514
    ##              AD              4.1958   3.7183   3.6150   2.9652
    ##              ADM             0.4359   0.4961   0.5622   1.0177
    ##              FOM             0.8686   0.7909   0.7819   0.7092
    ##              Connectivity   34.7790  45.0008  75.9865 184.7397
    ##              Dunn            0.1919   0.2035   0.1564   0.1743
    ##              Silhouette      0.2579   0.2676   0.1987   0.1117
    ## 
    ## Optimal Scores:
    ## 
    ##              Score  Method       Clusters
    ## APN          0.0060 hierarchical 2       
    ## AD           2.9210 kmeans       15      
    ## ADM          0.0567 hierarchical 2       
    ## FOM          0.6834 hierarchical 15      
    ## Connectivity 2.9290 hierarchical 2       
    ## Dunn         0.3711 hierarchical 2       
    ## Silhouette   0.2849 kmeans       3

<br>

I love this summary! Just look at it: it not only gives you a summary of all the specified validation measures across different clustering algorithms and number of inspected clusters, but also it lists those algorithms and number of clusters pairs that performed best in regard to a given validation metric. Very helpful, especially when evaluating more algorithms and possible numbers of clusters!

So, following the last summary, it looks like the hierarchical clustering with 2 clusters performed best in terms of stability and internal measures, as this pair appears in 2 out of 4 stability measures and 2 out of 3 internal measures.

<br>

BEFORE YOU GO
-------------

Coming to the end of this post, it's important to stress that there are more packages and methods you can use to evaluate your clusters (for the start, I would explore [clusteval package](ftp://ftp.u-aizu.ac.jp/pub/lang/R/CRAN/web/packages/clusteval/index.html) ), but these quick glimpses can go a long way and give you a good idea of what works for your data and what doesn't.
