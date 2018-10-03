# Loading packages

library(gdata)
library("dplyr")
library(plyr)
library(tidyr)
library(stringr)
library(splitstackshape)

# Loading the companies and rounds2 file into dataframes

companies<-read.delim("companies.txt",stringsAsFactors=F) # Importing data from text file
rounds2<-read.csv("rounds2.csv",stringsAsFactors=F)

# Converting all permalinks of both the files into lowercase

companies$permalink<-as.character(companies$permalink)
companies$permalink<-enc2utf8(companies$permalink) # Removing invalid multibyte string error to use string functions
companies$permalink<-tolower(companies$permalink)

rounds2$company_permalink<-as.character(rounds2$company_permalink)
rounds2$company_permalink<-enc2utf8(rounds2$company_permalink)
rounds2$company_permalink<-tolower(rounds2$company_permalink)

companies$permalink<-str_trim(companies$permalink) # Removing white spaces from both the ends of string
rounds2$company_permalink<-str_trim(rounds2$company_permalink)

# How many unique companies are present in companies?

length(unique(companies$permalink))

# How many unique companies are present in rounds2?

length(unique(rounds2$company_permalink))

# Are there any companies in the rounds2 file which are not present in companies?

setdiff(unique(rounds2$company_permalink),unique(companies$permalink))

# Merging companies and rounds2

master_frame<-merge(rounds2,companies,by.x ="company_permalink",by.y = "permalink",all.x =TRUE)

# Total number of NA values present in column raised_amount_usd

sum(is.na(master_frame$raised_amount_usd))
sum(is.na(master_frame$raised_amount_usd))/nrow(master_frame)
# 17% missing values

# Replacing all NA values in raised amount column to 0

master_frame$raised_amount_usd[is.na(master_frame$raised_amount_usd)==T] <- 0

# Checkpoint 1

aggregate(raised_amount_usd~funding_round_type,master_frame,mean)

# Checkpoint 2

venture_data<-filter(master_frame, funding_round_type == "venture") # Selecting data for only venture investment type 
venture_data_by_country<-arrange(aggregate(raised_amount_usd~country_code,venture_data,sum, na.rm = T), desc(raised_amount_usd))
venture_data_by_country<-venture_data_by_country[-3, ] # Removing data entry with blank in country_code
top9<-top_n(venture_data_by_country,9) # Selecting Top 9 countries

# Checkpoint 3

mapping<-read.csv("mapping.csv")
newdata<-gather(mapping, sector, val, Automotive...Sports:Social..Finance..Analytics..Advertising)
str(newdata)
newdata<-newdata[!(newdata$val == 0), ]
newdata<-newdata[ ,-3]

newdata[ ,"test"]<-NA # Adding column to a dataframe with a pre specified value
newdata$test<-newdata$category_list
newdata$test<-gsub("0","na",newdata$test) # Substitution of a string with another
newdata$test<-gsub("2.na","2.0",newdata$test)
newdata$category_list<-newdata$test
newdata<-newdata[ ,-3]
newdata$category_list<-tolower(newdata$category_list)
newdata$category_list<-str_trim(newdata$category_list)

master_frame[ ,"primary_sector"]<-NA

master_frame$category_list<-as.character(master_frame$category_list)

for(i in 1:nrow(master_frame))
{
  if(is.na(master_frame[i,9])==FALSE & str_detect(master_frame[i,9],"\\|")==TRUE) # "\\|" for special character pipe "|" symbol
  {
    master_frame[i,16]<-word(master_frame[i,9],1,sep = "\\|") # To extract string before pattern
  }
  else if(is.na(master_frame[i,9])==FALSE & str_detect(master_frame[i,9],"\\|")==FALSE)
  {master_frame[i,16]<-master_frame[i,9]}
  else{}
}

master_frame$primary_sector<-tolower(master_frame$primary_sector)
master_frame$primary_sector<-str_trim(master_frame$primary_sector)

master_frame<-merge(master_frame,newdata,by.x = "primary_sector",by.y = "category_list",all.x = TRUE)

colnames(newdata)[2]<-"main_sector" # Setting/changing the column name in dataframe
colnames(master_frame)[17]<-"main_sector"

# Checkpoint 4

# For Top English speaking country i.e. USA ----------------------------------------------------------------

D1<-filter(master_frame,funding_round_type == "venture" & raised_amount_usd >= 5000000 & raised_amount_usd <= 15000000 & country_code == "USA")
D1_filtered<-select(D1,main_sector,funding_round_permalink)
D1_grouped<-group_by(D1_filtered,main_sector)
D1_summary<-summarise(D1_grouped,"investment_count"=length(funding_round_permalink))
D1<-merge(D1,D1_summary,x.by="main_sector",y.by="main_sector",all.x = TRUE)

D1_filtered_amount<-select(D1,main_sector,raised_amount_usd)
D1_grouped_amount<-group_by(D1_filtered_amount, main_sector)
D1_summary_amount<-summarise(D1_grouped_amount,"investment_sum"=sum(raised_amount_usd))
D1<-merge(D1,D1_summary_amount,x.by="main_sector",y.by="main_sector",all.x = TRUE)

# Total number of investments

D1_total_no_investments <- length(D1$raised_amount_usd)  

# Total sum of investments

D1_total_sum_investments <- sum(D1$raised_amount_usd, na.rm = TRUE) 

# Total count of investements
# Top 3 Sectors (basis total count) are: Others, Social..Finance..Analytics..Advertising, Cleantech...Semiconductors

D1_count <- count(D1, "main_sector") 

# Top sector

D1_topsector_topcompany <- filter(D1, main_sector =="Others")

# Top company : Virtustream

D1_topsector_topcompany_sum <- arrange(ddply(D1_topsector_topcompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, desc = TRUE)),desc(raised_amount_usd))

# Second-best sector

D1_topsector_seccompany <- filter(D1, main_sector =="Social..Finance..Analytics..Advertising")

# Second company : SST inc

D1_topsector_secccompany_sum <- arrange(ddply(D1_topsector_seccompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, decreasing = TRUE)),desc(raised_amount_usd))


# For Second-Highest English speaking country i.e. GBR -----------------------------------------------------

D2<-filter(master_frame,funding_round_type == "venture" & raised_amount_usd >= 5000000 & raised_amount_usd <= 15000000 & country_code == "GBR")
D2_filtered<-select(D2,main_sector,funding_round_permalink)
D2_grouped<-group_by(D2_filtered,main_sector)
D2_summary<-summarise(D2_grouped,"investment_count"=length(funding_round_permalink))
D2<-merge(D2,D2_summary,x.by="main_sector",y.by="main_sector",all.x = TRUE)

D2_filtered_amount<-select(D2,main_sector,raised_amount_usd)
D2_grouped_amount<-group_by(D2_filtered_amount, main_sector)
D2_summary_amount<-summarise(D2_grouped_amount,"investment_sum"=sum(raised_amount_usd))
D2<-merge(D2,D2_summary_amount,x.by="main_sector",y.by="main_sector",all.x = TRUE)

# Total number of investments

D2_total_no_investments <- length(D2$raised_amount_usd)  

# Total sum of investments

D2_total_sum_investments <- sum(D2$raised_amount_usd, na.rm = TRUE) 

# Total count of investements
# Top 3 Sectors (basis total count) are: Others, Social..Finance..Analytics..Advertising, Cleantech...Semiconductors
 
D2_count <- count(D2, "main_sector") 

# Top sector

D2_topsector_topcompany <- filter(D2, main_sector =="Others")

# Top company :Electric Cloud

D2_topsector_topcompany_sum <- arrange(ddply(D2_topsector_topcompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, desc = TRUE)), desc(raised_amount_usd))

# Second-best sector

D2_topsector_seccompany <- filter(D2, main_sector =="Social..Finance..Analytics..Advertising")

# Second company : Celltick Technologies

D2_topsector_secccompany_sum <- arrange(ddply(D2_topsector_seccompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, decreasing = TRUE)), desc(raised_amount_usd))


# For Third-Highest English speaking country i.e. IND ------------------------------------------------------

D3<-filter(master_frame,funding_round_type == "venture" & raised_amount_usd >= 5000000 & raised_amount_usd <= 15000000 & country_code == "IND")
D3_filtered<-select(D3,main_sector,funding_round_permalink)
D3_grouped<-group_by(D3_filtered,main_sector)
D3_summary<-summarise(D3_grouped,"investment_count"=length(funding_round_permalink))
D3<-merge(D3,D3_summary,x.by="main_sector",y.by="main_sector",all.x = TRUE)

D3_filtered_amount<-select(D3,main_sector,raised_amount_usd)
D3_grouped_amount<-group_by(D3_filtered_amount, main_sector)
D3_summary_amount<-summarise(D3_grouped_amount,"investment_sum"=sum(raised_amount_usd))
D3<-merge(D3,D3_summary_amount,x.by="main_sector",y.by="main_sector",all.x = TRUE)

# Total number of investments

D3_total_no_investments <- length(D3$raised_amount_usd) 

# Total sum of investments

D3_total_sum_investments <- sum(D3$raised_amount_usd, na.rm = TRUE)

# Total count of investements
# Top 3 Sectors (basis total count) are: Others, Social..Finance..Analytics..Advertising, News..Search.and.Messaging

D3_count <- count(D3, "main_sector") 

# Top sector

D3_topsector_topcompany <- filter(D3, main_sector =="Others")

# Top company :FirstCry.com

D3_topsector_topcompany_sum <- arrange(ddply(D3_topsector_topcompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, desc = TRUE)), desc(raised_amount_usd))

# Second-best sector

D3_topsector_seccompany <- filter(D3, main_sector =="Social..Finance..Analytics..Advertising")

# Second company : Manthan Systems

D3_topsector_secccompany_sum <- arrange(ddply(D3_topsector_seccompany, "name", summarise, raised_amount_usd = sum(raised_amount_usd, decreasing = TRUE)), desc(raised_amount_usd))


#------------------------------------------------END-------------------------------------------------
