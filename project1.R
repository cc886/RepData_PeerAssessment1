setwd("D:/STUDY/Coursera/repdata/project 1")

library(dplyr)
library(ggplot2)

######### Loading and preprocessing the data #########
unzip("activity.zip")
activityData <- read.csv("activity.csv")

#############  What is mean total number of steps taken per day? ############

tbl_df(activityData) %>%
        group_by(date) %>%
        summarise(total = sum(steps, na.rm = T)) -> total_per_day

ggplot(total_per_day) + geom_histogram(aes(x = total))


mean(total_per_day$total)
median(total_per_day$total)

# > mean(total_per_day$total)
# [1] 9354.23
# > median(total_per_day$total)
# [1] 10395

######### What is the average daily activity pattern?###############

# tbl_df(activityData) %>%
#         group_by(interval) %>%
#         summarise(mean = mean(steps, na.rm = T)) -> mean_per_interval
# 
# plot(mean_per_interval$interval, mean_per_interval$mean, type = "l")



interval_fix <- format(activityData$interval, width = 4)
interval_fixed <- chartr(" ", "0", interval_fix)
time_CST <-strptime(interval_fixed, format = "%H%M")

# translate the interval into seconds count.
second_counts <- as.numeric(time_CST - trunc(time_CST, "days"))
minute_counts <- second_counts/60


cbind(minute_counts,activityData) %>%
        group_by(minute_counts) %>%
        summarise(mean = mean(steps, na.rm = T)) -> interval_mean

ggplot(interval_mean, aes(x = minute_counts, y = mean)) + geom_line()






# interval_fix <- format(AC_data$interval, width = 4)
# interval_fixed <- chartr(" ", "0", interval_fix)
# time_CST <- strptime(interval_fixed, format = "%H%M") 
# time_CST2 <- format(time_CST, format='%H:%M')
# y <- cbind(time_CST2, AC_data)
# 
# # count as seconds
# 
# z <- as.numeric(time_CST - trunc(time_CST, "days"))
# class(z)
# y <- cbind(z, AC_data)
# library(scales)
# p <- qplot(y, aes(x=z, y = steps)) + xlab("Time slot") +
#         scale_x_datetime(labels = date_format("%S:00"))
# print(p)
# 
# 



# 
# Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
# 
# interval_fix <- format(AC_data$interval, width = 4)
# 
# interval_fixed <- chartr(" ", "0", interval_fix)
# 
# 
# tbl_df(activityData) %>% 
#         mutate(TS = paste(activityData$date, interval_fixed, seq = " ")) -> AC_data
# 
# date_CST <- strptime(AC_data$TS, "%Y-%m-%d %H%M")
# y <- cbind(date_CST, AC_data)strptime(AC_data$TS, "%Y-%m-%d %H%M")
# plot(y$date_CST, y$steps, type = "l")



# 
# activityData_perday <- group_by(activityData, date)
# 
# total_perday <- summarise(activityData_perday, sum(steps, na.rm = T))
# 
# hist(total_perday$date, total_perday$total)
# 
# names(total_perday)[2] <- "total"
# 
# date_CST <- strptime(total_perday$date, "%Y-%m-%d")
# 
# total_perday_date <- cbind(date_CST, total_perday)


########### Imputing missing values #######
summary(activityData)

# use minute_counts as the index .
ac_minute <- cbind(minute_counts,activityData)

merged_ac <- merge(interval_mean, ac_minute, by = "minute_counts")
# > summary(merged_ac)
# minute_counts         mean             steps                date          interval     
# Min.   :   0.0   Min.   :  0.000   Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
# 1st Qu.: 358.8   1st Qu.:  2.486   1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
# Median : 717.5   Median : 34.113   Median :  0.00   2012-10-03:  288   Median :1177.5  
# Mean   : 717.5   Mean   : 37.383   Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
# 3rd Qu.:1076.2   3rd Qu.: 52.835   3rd Qu.: 12.00   2012-10-05:  288   3rd Qu.:1766.2  
# Max.   :1435.0   Max.   :206.170   Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
# NA's   :2304     (Other)   :15840      


# Devise a strategy for filling in all of the missing values in the dataset.
# use the mean for that 5-minute interval
# the 17568 comes from `dim(activityData)[1]`
for (i in 1:17568)
{
        if(is.na(merged_ac$steps[i]))
        {
                merged_ac$steps[i] <- merged_ac$mean[i]
        }
}
# > summary(merged_ac)
# minute_counts         mean             steps                date          interval     
# Min.   :   0.0   Min.   :  0.000   Min.   :  0.00   2012-10-01:  288   Min.   :   0.0  
# 1st Qu.: 358.8   1st Qu.:  2.486   1st Qu.:  0.00   2012-10-02:  288   1st Qu.: 588.8  
# Median : 717.5   Median : 34.113   Median :  0.00   2012-10-03:  288   Median :1177.5  
# Mean   : 717.5   Mean   : 37.383   Mean   : 37.38   2012-10-04:  288   Mean   :1177.5  
# 3rd Qu.:1076.2   3rd Qu.: 52.835   3rd Qu.: 27.00   2012-10-05:  288   3rd Qu.:1766.2  
# Max.   :1435.0   Max.   :206.170   Max.   :806.00   2012-10-06:  288   Max.   :2355.0  
# (Other)   :15840           


tbl_df(merged_ac) %>%
        group_by(date) %>%
        summarise(total = sum(steps, na.rm = T)) -> fixed_total_per_day

ggplot(fixed_total_per_day) + geom_histogram(aes(x = total))


mean(fixed_total_per_day$total)
median(fixed_total_per_day$total)
# > mean(fixed_total_per_day$total)
# [1] 10766.19
# > median(fixed_total_per_day$total)
# [1] 10766.19

######### Are there differences in activity patterns between weekdays and weekends? ##########

lct <- Sys.getlocale("LC_TIME");
Sys.setlocale("LC_TIME", "C")

date_CST <- strptime(merged_ac$date, format = "%Y-%m-%d")

weekday_ac <- cbind(merged_ac, weekday = weekdays(date_CST))

flag <- character(17568)

for (i in 1 : 17568)
{
        if(weekday_ac$weekday[i] == "Sunday" || weekday_ac$weekday[i] == "Saturday") 
        {
                flag[i] <- "weekend"
        }
        else
        {
                flag[i] <- "weekday"
        }
}



cbind(weekday_ac, flag) %>%
        group_by(minute_counts, flag) %>%
        summarise(mean = mean(steps, na.rm = T)) -> weekday_mean

ggplot(weekday_mean, aes(x = minute_counts, y = mean)) + 
        geom_line(aes(colour = factor(flag))) + 
        # facet_grid was used to seperate the weekday / weekend value
        facet_grid(flag ~ .) 


Sys.setlocale("LC_TIME", lct)

###### APPENDIX ###########
# ABOUT time series 
# http://stackoverflow.com/questions/7655514/how-do-i-plot-only-the-time-portion-of-a-timestamp-including-a-date
# http://stackoverflow.com/questions/10705328/extract-hours-and-seconds-from-posixct-for-plotting-purposes-in-r

