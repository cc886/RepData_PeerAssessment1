# PROCESS
## The difference between histogram and bar plot

* histogram

In the DA class, histogram has been mentioned as the plot for numeric data.
It was highly used in caculating the density and frequency of data.

* barplot

Well.... not mentioned.

## To format "5", "15", "345", "1534" as "0005", "0015", "0345", "1534"

Aims at easier translation to the POSIX  in R.

No directly funcion can be used, but can be down in two steps.

1. from "5" to "   5", using `format`
1. from "   5" to "0005", using `chartr` 

```
# trim the number
interval_fix <- format(activityData$interval, width = 4)

#change " " to "0"
interval_fixed <- chartr(" ", "0", interval_fix)
```

### strptime

For those shown as "2012-10-01 1435", can be format by `strptime(AC_data$TS, "%Y-%m-%d %H%M")`


**IF `NA` is returned, there must be something wrong with the input format.**

DOUBLE CHECK IT !!

### time series plot

EN output

```
Sys.setlocale("LC_TIME", "C")
```


ploting:

`plot(... , type = "l" )`

or

`p + geom_line()`

## FAKE Time series

In fact, the method above is not necessary, as the question has not been so complicate yet.

BUT... the following method is more complicated as I think....

*reference*
[extract hours and seconds from POSIXct for plotting purposes in R](http://stackoverflow.com/questions/10705328/extract-hours-and-seconds-from-posixct-for-plotting-purposes-in-r)
[How do I plot only the time portion of a timestamp including a date?](http://stackoverflow.com/questions/7655514/how-do-i-plot-only-the-time-portion-of-a-timestamp-including-a-date)

To create the FAKE time series, I translate the time shows as "1435" (means 14:35) into minutes.

```
second_counts <- as.numeric(time_CST - trunc(time_CST, "days"))
minute_counts <- second_counts/60
```

## For loop

```
for (i in 1 : 17568) # remember the "1 :"
{
        if(weekday_ac$weekday[i] == "Sunday" || weekday_ac$weekday[i] == "Saturday") 
        {
             # failed when I used `(weekday_ac$weekday[i] <- "weekend" ` ?
                flag[i] <- "weekend"
        }
        else
        {
                flag[i] <- "weekday"
        }
}

```

## geom_grid() and geom_wrap()

Can be used to seperate the facets.

```
ggplot(weekday_mean, aes(x = minute_counts, y = mean)) + 
        geom_line(aes(colour = factor(flag))) + 
        # facet_grid was used to seperate the weekday / weekend value
        facet_grid(flag ~ .) 
```

Don't forget the `.` behind the `~`