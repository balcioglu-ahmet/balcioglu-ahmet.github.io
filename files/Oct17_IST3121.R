#Examples of Linear Regression
library(tidyverse)
library(xtable)
options(scipen = 2,"digits"=2)

##Gross sales vs. Advertising
Data_1<-tibble(Year=(1997:2006),
               Gross_sales=c(7.60,8.36,8.00,9.58,11.51,13.00,15.10,15.60,16.00,18.20),
               Advertising_outlay=c(4.00,4.50,4.60,5.00,7.00,8.00,8.20,9.00,10.50,11.30))

#Our Model is Gross_sales(Y)=Beta_0 + Beta_1*Advertising_outlay(X) +Eps
#Or using the alternative notation y_i= Beta*x_i Let's define them:

x_i<-Data_1$Advertising_outlay-mean(Data_1$Advertising_outlay)#mean is 7.21
y_i<-Data_1$Gross_sales-mean(Data_1$Gross_sales)#mean is 12.295

#Summary statistics
summary(Data_1)

#boxplot
Data_1%>%
  ggplot(aes(x=Advertising_outlay,y=Gross_sales))+
  geom_boxplot()+
  xlim(0,15)+
  theme_classic()+
  labs(title = "Box Plot",
       y = "Gross Sales",
       x="")

#Obviously, you don't need x data for boxplot, but it doesn't affect the result.

Scatter_plot<-Data_1%>%
  ggplot(aes(x=Advertising_outlay,y=Gross_sales))+
  geom_point()+
  theme_linedraw() +
  labs(title = "Scatter Plot",
       x = "Advertising Outlay",
       y = "Gross Sales")

#Compute sums of x_i^2,y_i^2,x_i*y_i
Data_summary<-tibble(Year=Data_1$Year,X_i=Data_1$Advertising_outlay,Y_i=Data_1$Gross_sales,x_i,y_i,x_i^2,y_i^2,x_i*y_i)
Data_summary<-rbind(Data_summary,c("Total",sum(Data_1$Advertising_outlay),sum(Data_1$Gross_sales),sum(x_i),round(sum(y_i)),sum(x_i^2),sum(y_i^2),sum(x_i*y_i)))

#Using OLS to estimate the values of Y
Beta_1<-sum(x_i*y_i)/sum(x_i^2)
Beta_0<-mean(Data_1$Gross_sales)-Beta_1*mean(Data_1$Advertising_outlay)

#Let's add the Regression line to our scatter plot       
Regression_plot<-Scatter_plot+
  geom_abline(slope=Beta_1, intercept=Beta_0,color='blue')+
  labs(title="Regression Plot",
       x = "Advertising Outlay",
       y = "Gross Sales")


#Let's compute the variables and add them to our summary table
Y_hat<-Beta_0+Beta_1*Data_1$Advertising_outlay
res<-Data_1$Gross_sales-Y_hat
MSE=sum(res^2)/8#df is 10-2=8
res_std<-res/sqrt(MSE)

Data_summary<-Data_summary%>%
  mutate(Y_i_hat =c(Beta_0+Beta_1*Data_1$Advertising_outlay,sum(Beta_0+Beta_1*Data_1$Advertising_outlay)),
         Res =c(Data_1$Gross_sales-Y_hat,round(sum(Data_1$Gross_sales-Y_hat))),
         Res_sqr =c((Data_1$Gross_sales-Y_hat)^2,sum((Data_1$Gross_sales-Y_hat)^2)),
         Res_std =c(res/sqrt(MSE),round(sum(res/sqrt(MSE)))))

#Or, alternatively, we could have used the glm function. We would have reach the same result but faster
Data_1%>%
  glm(Gross_sales~Advertising_outlay,family=gaussian,.,)%>%
  summary()


### Model Assumptions
## 
# Already looked at standard deviations, and the boxplot

#Residual plot
ResidualvsX<-Data_summary%>%
  filter(Year!="Total")%>%
ggplot(aes(x=X_i,y=Res))+
  geom_point()+
  theme_classic() +
  labs(title = "Residuals Plot",
       x = "Independent Variable",
       y = "Residuals")
#They look normal enough some minor deviances but nothing concerning.
#We can look at Standardized residuals and Y_hat to make sure, there are no problems.

#Standardized Residual Plot
Residual_stdvsX<-Data_summary%>%
  filter(Year!="Total")%>%
  ggplot(aes(x=X_i,y=Res_std))+
  geom_point()+
  theme_classic() +
  labs(title = "Standardized Residual Plot",
       x = "Independent Variable",
       y = "Standardized Residuals")
# There is no virtually difference between the two. 

#Just to show there is no difference between X or Y_hat
Residual_stdvsY_hat<-Data_summary%>%
  filter(Year!="Total")%>%
  ggplot(aes(x=Y_i_hat[1:10],y=Res_std[1:10]))+
  geom_point()+
  theme_classic() +
  labs(title = "Standardized Residual Plot",
       x = "Y_hat",
       y = "Standardized Residuals")
# The errors look random with constant variance, there is no concern for an outlier.
#I have went overboard by taking three residual plots in general one is enough.


##Outliers
## When should we think about removing points from our data? 
#Points of leverage: Points with distant x-values.
#Outlier:Points unable to be explained by the model.
#Let's throw in an outlier to see what happens
Outl_Data<-Data_1%>%
  add_row(.,Year=1996,Advertising_outlay=3,Gross_sales=13.4,.before=1)

Outl_Model<-Outl_Data%>%
  glm(Gross_sales~Advertising_outlay,family=gaussian,.,)

summary(Outl_Model) 

Data_1%>%
  add_row(.,Year=1996,Advertising_outlay=3,Gross_sales=13.4,.before=1)%>%
  ggplot(aes(x=Advertising_outlay,y=Gross_sales))+
    geom_point()+
    theme_linedraw() +
    geom_abline(slope=coef(Outl_Model)[2], intercept=coef(Outl_Model)[1])+
    labs(title="Regression Plot with an outlier",
         x = "Advertising Outlay",
         y = "Gross Sales")

#Let's look at a residual plot
ResidualvsX_out<-Outl_Model%>%
  ggplot(aes(x=Outl_Data$Advertising_outlay,y=resid(Outl_Model)))+
  geom_point()+
  theme_classic() +
  labs(title = "Residuals Plot",
       x = "Independent Variable",
       y = "Residuals")

#The first point is clearly an outlier, and it is a leverage point.

#In general, you should have a good reason for removing an outlier. 
#It may be be a meaningful and/or interesting point.

# Normality:
# 
# Two random variables are equal in distribution
# if and only if their cumulative distribution functions
# are equal.
# Easier to compare their INVERSE CDFs- the so-called 
# "quantile functions"

Data_1 %>%
  mutate_at("Gross_sales",funs( (. - mean(.)) / sd(.))) %>%
  arrange(Gross_sales) %>%
  mutate(q = qnorm(1:n() / (n() + 1))) %>%
  ggplot(aes(x = q,y = Gross_sales)) +
  theme_classic() +
  geom_point() +
  geom_abline(slope = 1,intercept = 0,colour = "red") +
  labs(title = "Normal QQ-plot",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

# There are some small deviations, nothing worth worrying about. 

####

## Example 2
#
Data_2<-tibble(X=c(80,220,140,120,180,100,200,160),Y=c(0.60,6.70,5.30,4.00,6.55,2.15,6.60,5.75))
#So, We have written a lot of code for the last example, 
#wouldn't it be nice if we could use the same model?

summary(Data_2)
Scatter_plot_2<-Data_2%>%
  ggplot(aes(x=X,y=Y))+
  theme_classic()+
  geom_point()+
  labs(title = "Scatter Plot",
       y = "Dependent Variable",
       x="Independent Variable")

Data_2%>%
  ggplot(aes(x=X,y=Y))+
  geom_boxplot()+
  xlim(80,220)+
  theme_classic()+
  labs(title = "Box Plot",
       y = "Independent Variable",
       x="")
#Looks right-skewed

# Our Data 

x_i<-Data_2$X-mean(Data_2$X)#mean is 150
y_i<-Data_2$Y-mean(Data_2$Y)#mean is 4.7

Data_summary_2<-tibble(1:8,X_i=Data_2$X,Y_i=Data_2$Y,x_i,y_i,x_i^2,y_i^2,x_i*y_i)
Data_summary_2<-rbind(Data_summary_2,c("Total",sum(Data_2$X),sum(Data_2$Y),sum(x_i),round(sum(y_i)),sum(x_i^2),sum(y_i^2),sum(x_i*y_i)))

Beta_1<-sum(x_i*y_i)/sum(x_i^2)
Beta_0<-mean(Data_2$Y)-Beta_1*mean(Data_2$X)

Y_hat<-Beta_0+Beta_1*Data_2$X
res<-Data_2$Y-Y_hat
MSE=sum(res^2)/6 #df is 8-2=6
res_std<-res/sqrt(MSE)

Data_summary_2<-Data_summary_2%>%
  mutate(Y_i_hat =c(Beta_0+Beta_1*Data_2$X,sum(Beta_0+Beta_1*Data_2$X)),
         Res =c(Data_2$Y-Y_hat,round(sum(Data_2$Y-Y_hat))),
         Res_sqr =c((Data_2$Y-Y_hat)^2,sum((Data_2$Y-Y_hat)^2)),
         Res_std =c(res/sqrt(MSE),round(sum(res/sqrt(MSE)))))

#Or Using the glm function
Data_2_model<-Data_2%>%
  glm(Y~X,family=gaussian,.,)
summary(Data_2_model)

Scatter_plot_2+
  geom_abline(slope=coef(Data_2_model)[[2]], intercept=coef(Data_2_model)[[1]])


ResidualvsX_2<-Data_summary_2%>%
  filter(`1:8`!="Total")%>%
  ggplot(aes(x=X_i,y=Res))+
  geom_point()
# Looks like there is a quadratic relation between error terms and the indep variable.
# We have a problem!
#
# Let's try to add a X^2 term to solve the problem: Our model will become: Y=Beta_0+Beta_1*X+Beta_2*X^2. 
# For this example we will not be using the alternative notation.(Its formulae only valid under 2 parameter model)

Data_summary_3<-tibble("#"=1:8,X_i=Data_2$X,Y_i=Data_2$Y,X_i^2,Y_i^2,X_i*Y_i,X_i^3,X_i^2*Y_i,X_i^4)%>%
  add_row(.,`#`="Total",
          X_i = sum(Data_2$X),
          Y_i = sum(Data_2$Y),
          `X_i^2` = sum(Data_2$X^2),
          `Y_i^2` = sum(Data_2$Y^2),
          `X_i * Y_i` = sum(Data_2$X*Data_2$Y),
          `X_i^3` = sum(Data_2$X^3),
          `X_i^2 * Y_i` = sum(Data_2$X^2*Data_2$Y),
          `X_i^4` = sum(Data_2$X^4))
#We estimate Beta_0,Beta_1,Beta_2 using the matrix formula (X'X)Beta_hat=X'Y
#Beta_hat=(X'X)-1*X'Y

X_matrix<-matrix(c(8,Data_summary_3$X_i[9],Data_summary_3$`X_i^2`[9],
         Data_summary_3$X_i[9],Data_summary_3$`X_i^2`[9],Data_summary_3$`X_i^3`[9],
         Data_summary_3$`X_i^2`[9],Data_summary_3$`X_i^3`[9],Data_summary_3$`X_i^4`[9]),ncol = 3)
Y_vector<-c(Data_summary_3$Y_i[9],Data_summary_3$`X_i * Y_i`[9],Data_summary_3$`X_i^2 * Y_i`[9])
Beta_hat<-solve(X_matrix)%*%Y_vector

##or the glm function
Data_2%>%
glm(Y~X+I(X^2),family=gaussian,.,)#

#The final summary table
Y_hat<-Beta_hat[1]+Beta_hat[2]*Data_2$X+Beta_hat[3]*Data_2$X^2
res<-Data_2$Y-Y_hat
MSE=sum(res^2)/5#df is 8-3=5
res_std<-res/sqrt(MSE)

Data_summary_3<-Data_summary_3%>%
  mutate(Y_i_hat =c(Y_hat,sum(Y_hat)),
         Res =c(Data_2$Y-Y_hat,round(sum(Data_2$Y-Y_hat))),
         Res_sqr =c((Data_2$Y-Y_hat)^2,sum((Data_2$Y-Y_hat)^2)),
         Res_std =c(res/sqrt(MSE),round(sum(res/sqrt(MSE)))))

#Regression Plot
Data_summary_3%>%
  filter(`#`!="Total")%>%
  ggplot(aes(x=X_i,y=Y_i))+
  stat_function(fun=function(x){Beta_hat[3]*x^2+Beta_hat[2]*x+Beta_hat[1]}, geom="line", aes(colour="Red"),show.legend = FALSE)+
  geom_point()+
  labs(title="Regression Plot",
       x = "Independent Variable",
       y = "Dependent Variable")

##Model Assumptions
#We need to look at Xi and Xi^2 vs Res_std, we will also look at Y_hat just to make sure

Residual_stdvsX_plot_3<-Data_summary_3%>%
  filter(`#`!="Total")%>%
  ggplot(aes(x=X_i,y=Res))+
  geom_point()+
  theme_classic() +
  labs(title = "Residuals Plot",
       x = "Independent Variable",
       y = "Residuals")

Residual_stdvsX2_plot_3<-Data_summary_3%>%
  filter(`#`!="Total")%>%
  ggplot(aes(x=`X_i^2`,y=Res_std))+
  geom_point()+
  theme_classic() +
  labs(title = "Standardized Residual Plot",
       x = "Independent Variable",
       y = "Standardized Residuals")

Residual_stdvsY_hat_plot_3<-Data_summary_3%>%
  filter(`#`!="Total")%>%
  ggplot(aes(x=Y_i_hat,y=Res_std))+
  geom_point()+
  theme_classic() +
  labs(title = "Standardized Residual Plot",
       x = "Y_hat",
       y = "Standardized Residuals")

#QQ Plot

Data_2 %>%
  mutate_at("Y",funs( (. - mean(.)) / sd(.))) %>%
  arrange(Y) %>%
  mutate(q = qnorm(1:n() / (n() + 1))) %>%
  ggplot(aes(x = q,y = Y)) +
  theme_classic() +
  geom_point() +
  geom_abline(slope = 1,intercept = 0,colour = "red") +
  labs(title = "Normal QQ-plot",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

# There are some deviations perhaps the sample size was a bit small

