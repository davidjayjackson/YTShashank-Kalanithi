## 2022-07-05

# Youtube: https://youtu.be/4VkAwPYgSgk

### SQL Server Code

library(DBI)
library(odbc)
library(ggplot2)
library(scales)
library(tidyverse)
library(janitor)

##
rm(list=ls())
options(scipen=0)

author <- read_csv("./author_info.csv")
game <- read_csv("./game_info.csv")
purchase <- read_csv("./purchase_info.csv")
review <- read_csv("./review_info.csv")

#  USA : 160052 obs and 67 vars.
# USA <- USA %>% janitor::clean_names()
# USA <- USA %>% janitor::remove_empty(which = c("rows","cols"))
# USA$date <- as.Date(USA$date)

## https://db.rstudio.com/databases/microsoft-sql-server/
con <- DBI::dbConnect(odbc::odbc(), 
                      Driver = "SQL Server", 
                      Server = "localhost\\SQLEXPRESS", 
                      Database = "Shashank", 
                      Trusted_Connection = "True")



dbWriteTable(con, "author",author ,overwrite=TRUE)
# dbListFields(con,"author")

dbWriteTable(con, "game",game ,overwrite=TRUE)
# dbListFields(con,"game")

dbWriteTable(con, "purchase",purchase ,overwrite=TRUE)
# dbListFields(con,"purchase")

dbWriteTable(con, "review",review ,overwrite=TRUE)
# dbListFields(con,"review")

dbDisconnect(con)

df <- author %>% left_join(game) %>% 
left_join(purchase) %>% left_join(review) %>% janitor::clean_names()

df %>% count(language,sort =T) %>%
  ggplot() +  geom_col(aes(x=reorder(language,n),y=n)) + coord_flip() +
  scale_y_continuous(labels = comma)
  
ggplot(df) + geom_bar(aes(x=language)) +
  scale_y_continuous(labels = comma) + coord_flip()

## English Only

english_data <- df %>% filter(language =='english')

ggplot(df) + geom_bar(aes(x=language)) +
  scale_y_continuous(labels = comma) + coord_flip()


# write.csv(df,file="./games.csv",row.names = F)
df %>% filter(steam_purchase =="TRUE") %>% count(app_name) %>% 
  ggplot() + geom_col(aes(x=reorder(app_name,n),y=n)) + coord_flip() +
  scale_y_continuous(labels = comma)
 
ggplot(df) + geom_bar(aes(x=steam_purchase))

ggplot(df) + geom_bar(aes(x=received_for_free))


df %>% filter(author_playtime_last_two_weeks >1) %>%ggplot() + 
  geom_histogram(aes(x=author_playtime_last_two_weeks),bins=20)



