 # author : lalit sachan
library(factoextra)
library(tidymodels)
library(cluster)
library(plotly)
library(Rtsne)
library(dbscan)
library(forcats)
library(embed)

## ------------------------------------------------------------------------

cars=mtcars %>% select(-vs,-am)

## ------------------------------------------------------------------------

medians = apply(cars,2,median)
mads = apply(cars,2,mad)




# experiment with other measures of central tendencey and variability and see how the grouping changes

# Agglomerative[Hierarchical] Clustering

cars.std=data.frame(scale(cars,center=medians,scale=mads))

cars.dist = dist(cars.std)

cars.hclust = hclust(cars.dist,method = "complete")

fviz_dend(cars.hclust, main = "complete",k=3)

plot(cars.hclust)

# making groups 

## ------------------------------------------------------------------------
groups.3=cutree(cars.hclust,3)

groups.3
table(groups.3)
rownames(cars)[groups.3==1]

tapply(cars$mpg,groups.3,mean)

tapply(cars$wt,groups.3,mean)

my_tapply=function(x){
  
  return(tapply(x,groups.3,mean))
}

apply(cars,2,my_tapply)


diss=daisy(cars.std)

sk=silhouette(groups.3,diss)
plot(sk)

# Kmeans Clustering

wq=read.csv("/Users/lalitsachan/Dropbox/0.0 Data/winequality-white.csv",sep=";")

# alcohol, ph , sulphates

wq=wq %>% select(alcohol,pH,sulphates)

wq.std=scale(wq)

kclusts =
  tibble(k = 1:9) %>%
  mutate(
    kclust = map(k, ~ kmeans(wq.std, .x)),
    glanced = map(kclust, glance),
  )



kclusts %>%
  unnest(cols = c(glanced)) %>%
  ggplot(aes(k, tot.withinss)) +
  geom_line(alpha = 0.5, size = 1.2, color = "midnightblue") +
  geom_point(size = 2, color = "midnightblue")

final_clust = kmeans(wq.std, centers = 3)

wq_with_cluster=augment(final_clust, wq)

apply(wq,2,function(x) tapply(x,wq_with_cluster$.cluster,mean))

p = augment(final_clust, wq) %>%
  ggplot(aes(pH, sulphates, color = .cluster)) +
  geom_point()



# Clustering for mixed data with gowers distance 

bd=read.csv("/Users/lalitsachan/Dropbox/0.0 Data/bank-full.csv",sep=";",
            stringsAsFactors = T)

bd_sub=bd %>% 
  select(age,job,marital,education,default,balance,housing) %>% 
  mutate(age=as.vector(scale(age)),
         balance=as.vector(scale(balance))) %>% 
  sample_n(10000)

# its slow and takes a while
gower_dist = daisy(bd_sub, metric = "gower")

gower_mat = as.matrix(gower_dist)
#' Print most similar/dissimilar clients


min_dis=min(gower_mat[gower_mat!=0])

bd_sub[which(gower_mat==min_dis,arr.ind=T)[1,],]

max_dis=max(gower_mat)

bd_sub[which(gower_mat==max_dis,arr.ind=T)[1,],]

sil_width = c(NA)
for(i in 2:8){  
  pam_fit <- pam(gower_dist, diss = TRUE, k = i)  
  sil_width[i] <- pam_fit$silinfo$avg.width  
}
plot(1:8, sil_width,
     xlab = "Number of clusters",
     ylab = "Silhouette Width")
lines(1:8, sil_width)

## summary of each cluster

k = 5
pam_fit = pam(gower_dist, diss = TRUE, k)
pam_results = bd_sub %>%
  mutate(cluster = pam_fit$clustering) %>%
  group_by(cluster) %>%
  do(the_summary = summary(.))
pam_results$the_summary

## visualising clusters with tsne

tsne_obj = Rtsne(gower_dist, is_distance = TRUE)
tsne_data = tsne_obj$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(pam_fit$clustering))

ggplot(aes(x = X, y = Y), data = tsne_data) +
  geom_point(aes(color = cluster))

## DBSCAN 

moon_data=read.csv("/Users/lalitsachan/Dropbox/0.0 Data/moon_data.csv",stringsAsFactors = F)

glimpse(moon_data)

ggplot(moon_data,aes(x=X,y=Y))+geom_point()

moon_data=moon_data %>% select(X,Y)

fit= kmeans(moon_data,2) 

### to find wss for each k , fit$tot.withinss
### you can run a for loop over range of k and examine how wss behaves

moon_data$cluster=fit$cluster

ggplot(moon_data,aes(X,Y,color=as.factor(cluster)))+geom_point()


##dbscan for moondata


moon_data$cluster=NULL

moon.scan=dbscan(moon_data, eps=.05, minPts = 5)

moon_data$cluster=moon.scan$cluster

ggplot(moon_data,aes(X,Y,color=as.factor(cluster)))+geom_point()

table(moon_data$cluster)

## PCA for dimensionality reduction for numeric features

rg=read.csv("/Users/lalitsachan/Dropbox/0.0 Data/rg_train.csv",stringsAsFactors = T)

rg_num=rg %>% 
  select(where(is.numeric)) %>% 
  select(-REF_NO,-year_last_moved,-Revenue.Grid) 

pca_rec =recipe(~., data = rg_num) %>%
  step_normalize(all_predictors()) %>%
  step_pca(all_predictors())

pca_prep = prep(pca_rec)

var=(pca_prep$steps[[2]]$res$sdev)**2

percent_variation = var / sum(var)

var_df = data.frame(PC=paste0("PC",1:length(var)),
                     var_explained=percent_variation,
                     stringsAsFactors = FALSE)


var_df %>%
  mutate(PC = fct_inorder(PC)) %>%
  ggplot(aes(x=PC,y=var_explained))+geom_col()

var_df=var_df %>% 
  mutate(cum_var=cumsum(var_explained))


pca_rec =recipe(~., data = rg_num) %>%
  step_normalize(all_predictors()) %>%
  step_pca(all_predictors(),num_comp=11)

pca_prep = prep(pca_rec)

pca_data=bake(pca_prep,new_data=NULL)

cor(pca_data)

## categorical embeddings : dimensionality reduction for categorical columns
## if its crashing on your machine , leave it be , it could be due to 
## hardware incompatibility of your machine with deep learning packages 
## nothing can be done about that 
## this is not necessary to progress further in the course and can be safely ignored as 
## a good to know idea

data=read.csv("/Users/lalitsachan/Dropbox/0.0 Data/loan_data_train.csv")

cat_embed_rec=recipe(data) %>% 
  step_unknown(State,new_level="__missing__") %>% 
  step_other(State,threshold =0.01,other="__other__") %>% 
  step_embed(State,num_terms = 5,hidden_units = 16,outcome=vars(State),
             options=embed_control(loss="categorical_crossentropy",epochs=10))

cat_embed_p=prep(cat_embed_rec)

data_embed=bake(cat_embed_p,new_data = NULL)

