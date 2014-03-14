Run the `.xsl` style sheet as shown in `make-data.sh` on the `.xml` files. Read the `.csv ` files into R and `save()` as `.rda` files.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```


To read and save the .rda files in Dropbox, first set your working
directory to the wasp-trips/data folder before running this code:

Calculate time differences to correct the recorded times:

wasp1 should be 7 hours earlier:


```r
actual_time_w1 <- as.POSIXct(strptime("01/01/2013 01:00:00", format = "%m/%d/%Y %H:%M:%S"))
preset_time_w1 <- as.POSIXct(strptime("01/01/2013 08:00:00", format = "%m/%d/%Y %H:%M:%S"))
w1_add_time <- actual_time_w1 - preset_time_w1
```


wasp2 should be quite a bit later:

```r
actual_time_w2 <- as.POSIXct(strptime("11/05/2013 14:47:10", format = "%m/%d/%Y %H:%M:%S"))
preset_time_w2 <- as.POSIXct(strptime("02/11/2005 05:50:34", format = "%m/%d/%Y %H:%M:%S"))
w2_add_time <- actual_time_w2 - preset_time_w2
```


Now process the 2 sets of data:


```r
source("get_wasp_trips.R")  # function to parse the trip data
load("wasps1.rda")
wasps1_df <- group_by(wasps1, uid)
rm(wasps1)
wasps1_trips <- do(wasps1_df, function(x) get_wasp_trips(x, diff_address_arriving = 1, 
    diff_address_leaving = -1, add_time = w1_add_time))
```

```
## 36 09 30 01 0B 00 12 E0
## 37 09 30 01 0B 00 12 E0
## 39 25 30 01 0B 00 12 E0
## 40 25 30 01 0B 00 12 E0
## 42 25 30 01 0B 00 12 E0
## 43 09 30 01 0B 00 12 E0
## 43 25 30 01 0B 00 12 E0
## 44 09 30 01 0B 00 12 E0
## 44 0C 30 01 0B 00 12 E0
## 45 0C 30 01 0B 00 12 E0
## 45 25 30 01 0B 00 12 E0
## 46 25 30 01 0B 00 12 E0
## 47 0C 30 01 0B 00 12 E0
## 4E 25 30 01 0B 00 12 E0
## 4F 09 30 01 0B 00 12 E0
## 4F 25 30 01 0B 00 12 E0
## 50 25 30 01 0B 00 12 E0
## 55 25 30 01 0B 00 12 E0
## 56 25 30 01 0B 00 12 E0
## 57 25 30 01 0B 00 12 E0
## 58 25 30 01 0B 00 12 E0
## 59 09 30 01 0B 00 12 E0
## 5B 09 30 01 0B 00 12 E0
## 5C 09 30 01 0B 00 12 E0
## 5D 25 30 01 0B 00 12 E0
## 5E 09 30 01 0B 00 12 E0
## 5E 25 30 01 0B 00 12 E0
## 5F 09 30 01 0B 00 12 E0
## 60 09 30 01 0B 00 12 E0
## 61 09 30 01 0B 00 12 E0
## 62 09 30 01 0B 00 12 E0
## 64 09 30 01 0B 00 12 E0
## 64 25 30 01 0B 00 12 E0
## 67 09 30 01 0B 00 12 E0
## 68 09 30 01 0B 00 12 E0
## 69 09 30 01 0B 00 12 E0
## 6A 09 30 01 0B 00 12 E0
## 6C 09 30 01 0B 00 12 E0
## 6D 09 30 01 0B 00 12 E0
## 6F 09 30 01 0B 00 12 E0
## 71 09 30 01 0B 00 12 E0
## 72 09 30 01 0B 00 12 E0
## 75 09 30 01 0B 00 12 E0
## 76 09 30 01 0B 00 12 E0
## 77 09 30 01 0B 00 12 E0
## 7A 09 30 01 0B 00 12 E0
## 7B 09 30 01 0B 00 12 E0
## 7F 09 30 01 0B 00 12 E0
## 83 09 30 01 0B 00 12 E0
## 9A 0C 30 01 0B 00 12 E0
## BB 24 30 01 0B 00 12 E0
## D9 24 30 01 0B 00 12 E0
## DB 24 30 01 0B 00 12 E0
```

```r
rm(wasps1_df)
wasps1_trips <- do.call("rbind", wasps1_trips)
wasps1_trips <- as.data.frame(wasps1_trips)
gc()
```

```
##           used (Mb) gc trigger   (Mb)  max used   (Mb)
## Ncells  449617 24.1    2736109  146.2  10236446  546.7
## Vcells 4759079 36.4  420053504 3204.8 524953304 4005.1
```

```r

load("wasps2.rda")
wasps2_df <- group_by(wasps2, uid)
rm(wasps2)
wasps2_trips <- do(wasps2_df, function(x) get_wasp_trips(x, diff_address_arriving = -2, 
    diff_address_leaving = 2, add_time = w2_add_time))
```

```
## 00 23 30 01 0B 00 12 E0
## 01 21 30 01 0B 00 12 E0
## 01 23 30 01 0B 00 12 E0
## 02 21 30 01 0B 00 12 E0
## 02 23 30 01 0B 00 12 E0
## 03 21 30 01 0B 00 12 E0
## 04 21 30 01 0B 00 12 E0
## 04 23 30 01 0B 00 12 E0
## 06 23 30 01 0B 00 12 E0
## 07 23 30 01 0B 00 12 E0
## 08 23 30 01 0B 00 12 E0
## 09 23 30 01 0B 00 12 E0
## 0A 23 30 01 0B 00 12 E0
## 11 21 30 01 0B 00 12 E0
## 12 21 30 01 0B 00 12 E0
## 13 21 30 01 0B 00 12 E0
## 27 0C 30 01 0B 00 12 E0
## 2A 0C 30 01 0B 00 12 E0
## 2B 0C 30 01 0B 00 12 E0
## 2E 0C 30 01 0B 00 12 E0
## 31 0C 30 01 0B 00 12 E0
## 34 0C 30 01 0B 00 12 E0
## 35 0C 30 01 0B 00 12 E0
## 36 0C 30 01 0B 00 12 E0
## 37 0C 30 01 0B 00 12 E0
## 38 0C 30 01 0B 00 12 E0
## 3B 0C 30 01 0B 00 12 E0
## 3C 0C 30 01 0B 00 12 E0
## 3D 0C 30 01 0B 00 12 E0
## 3E 0C 30 01 0B 00 12 E0
## 40 0C 30 01 0B 00 12 E0
## 41 0C 30 01 0B 00 12 E0
## 42 0C 30 01 0B 00 12 E0
## 43 0C 30 01 0B 00 12 E0
## 44 25 30 01 0B 00 12 E0
## 47 25 30 01 0B 00 12 E0
## 48 0C 30 01 0B 00 12 E0
## 48 25 30 01 0B 00 12 E0
## 49 0C 30 01 0B 00 12 E0
## 49 25 30 01 0B 00 12 E0
## 4A 0C 30 01 0B 00 12 E0
## 4B 0C 30 01 0B 00 12 E0
## 4C 0C 30 01 0B 00 12 E0
## 4D 0C 30 01 0B 00 12 E0
## 4E 0C 30 01 0B 00 12 E0
## 4F 0C 30 01 0B 00 12 E0
## 50 0C 30 01 0B 00 12 E0
## 51 0C 30 01 0B 00 12 E0
## 51 25 30 01 0B 00 12 E0
## 52 0C 30 01 0B 00 12 E0
## 52 25 30 01 0B 00 12 E0
## 62 25 30 01 0B 00 12 E0
## 7B 0C 30 01 0B 00 12 E0
## 7C 0C 30 01 0B 00 12 E0
## 7D 0C 30 01 0B 00 12 E0
## 7E 09 30 01 0B 00 12 E0
## 7E 0C 30 01 0B 00 12 E0
## 8B 0C 30 01 0B 00 12 E0
## 8C 0C 30 01 0B 00 12 E0
## 8D 0C 30 01 0B 00 12 E0
## 99 0C 30 01 0B 00 12 E0
## B8 24 30 01 0B 00 12 E0
## C8 24 30 01 0B 00 12 E0
## C9 24 30 01 0B 00 12 E0
## CA 24 30 01 0B 00 12 E0
## D4 24 30 01 0B 00 12 E0
## DA 24 30 01 0B 00 12 E0
## E1 22 30 01 0B 00 12 E0
## E2 22 30 01 0B 00 12 E0
## E3 22 30 01 0B 00 12 E0
## E5 22 30 01 0B 00 12 E0
## E6 22 30 01 0B 00 12 E0
## E7 22 30 01 0B 00 12 E0
## F1 22 30 01 0B 00 12 E0
## F2 22 30 01 0B 00 12 E0
## F3 20 30 01 0B 00 12 E0
## F3 22 30 01 0B 00 12 E0
## F4 20 30 01 0B 00 12 E0
## F4 22 30 01 0B 00 12 E0
## F5 20 30 01 0B 00 12 E0
## F6 20 30 01 0B 00 12 E0
## F6 22 30 01 0B 00 12 E0
## F7 22 30 01 0B 00 12 E0
## F8 22 30 01 0B 00 12 E0
## F9 22 30 01 0B 00 12 E0
## FA 22 30 01 0B 00 12 E0
## FF 22 30 01 0B 00 12 E0
```

```r
rm(wasps2_df)
wasps2_trips <- do.call("rbind", wasps2_trips)
wasps2_trips <- as.data.frame(wasps2_trips)
gc()
```

```
##           used (Mb) gc trigger   (Mb)  max used   (Mb)
## Ncells  451443 24.2    1520872   81.3  10236446  546.7
## Vcells 4834925 36.9  199375672 1521.2 524953304 4005.1
```

```r

wasps1_trips$group <- 1
wasps2_trips$group <- 2
wasp <- rbind(wasps1_trips, wasps2_trips)
rm(wasps1_trips, wasps2_trips)

# convert to POSIXct to use in data frames / ddply / ggplot2
row.names(wasp) <- NULL
wasp$time <- as.POSIXct(wasp$time)

save(wasp, file = "wasp.rda")
```


Calculate hour of day:


```r
wasp$time_trunc <- as.POSIXct(trunc(wasp$time, "days"))
wasp$hour_of_day <- as.numeric(difftime(wasp$time, wasp$time_trunc, units = "hours"))
```


Now merge in the tag-caste data:


```r
load("cohorts_1.rda")
cohorts_1$caste <- as.character(cohorts_1$caste)
cohorts_1$date_tagged <- as.character(cohorts_1$date_tagged)
cohorts_2 <- read.csv("cohorts_2.csv", stringsAsFactors = FALSE)
cohorts_1$group <- 1
cohorts_2$group <- 2
cohorts <- rbind(cohorts_1, cohorts_2)
cohorts$date_tagged <- strptime(cohorts$date_tagged, format = "%Y-%m-%d")
cohorts$date_tagged <- as.POSIXct(cohorts$date_tagged)

# Create a transformed uid column that matches the tag format:
wasp <- transform(wasp, tag = paste0(substr(uid, 1, 2), substr(uid, 4, 5)))
wasp$uid <- NULL

library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following objects are masked from 'package:dplyr':
## 
##     arrange, desc, failwith, id, mutate, summarise, summarize
```

```r
wasp_caste <- join(wasp, cohorts, by = c("tag", "group"))
last_trip <- ddply(wasp_caste, c("tag", "caste"), function(x) tail(x, n = 1))
first_trip <- ddply(wasp_caste, c("tag", "caste"), function(x) head(x, n = 1))
```


Calculate age based on the date_tagged cohort data.


```r
wasp_caste$age <- wasp_caste$time_trunc - wasp_caste$date_tagged
save(wasp_caste, file = "wasp_caste.rda")
```


And create some summary data:


```r
wasp_summary <- ddply(wasp_caste, c("trip", "tag", "caste", "group"), summarize, 
    mean_trip = mean(time_diff/60/60, na.rm = TRUE), numb_trips = length(trip), 
    mean_trip_sd = sd(time_diff/60/60, na.rm = TRUE), median_trip = median(time_diff/60/60, 
        na.rm = TRUE), l_quant = quantile(time_diff/60/60, 0.25, na.rm = TRUE), 
    u_quant = quantile(time_diff/60/60, 0.75, na.rm = TRUE))

wasp_summary <- transform(wasp_summary, ordered_tag = reorder(tag, -median_trip))
save(wasp_summary, file = "wasp_summary.rda")
```

