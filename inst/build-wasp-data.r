# Warning: First, you need to:
# 1. Install the OS X command line tools (for a C++ compiler)
# 2. install.packages("Rcpp", type = "source")
# 3. install.packages("devtools")
# 4. devtools::install_github("jackets", "seananderson")
# 5. devtools::install_github("dplyr")
# 6. restart R if you've previously loaded plyr
# Then...

library(jackets)
# (alternatively, while in the "jackets" folder, run load_all() or 
# Shift-Command-L in RStudio)
library(dplyr)

# To read and save the .rda files in Dropbox, first set your working
# directory to the wasp-trips/data folder before running this code:

# Calculate time differences to correct the recorded times:
actual_time_w1 <- as.POSIXct(strptime("11/05/2013 14:47:10", format
   = "%m/%d/%Y %H:%M:%S"))
preset_time_w1 <- as.POSIXct(strptime("02/11/2005 05:50:34", format 
  = "%m/%d/%Y %H:%M:%S"))
w1_add_time <- actual_time_w1 - preset_time_w1

actual_time_w2 <- as.POSIXct(strptime("01/01/2013 08:00:00", format
  = "%m/%d/%Y %H:%M:%S"))
preset_time_w2 <- as.POSIXct(strptime("01/01/2013 01:00:00", format 
  = "%m/%d/%Y %H:%M:%S"))
w2_add_time <- actual_time_w2 - preset_time_w2

# Now process the 2 sets of data:
load("wasps1.rda")
wasps1_df <- group_by(wasps1, uid)
rm(wasps1)
wasps1_trips <- do(wasps1_df, function(x) get_wasp_trips(x,
    diff_address_home = -1, diff_address_away = 1,
    add_time = w1_add_time))
rm(wasps1_df)
wasps1_trips <- do.call("rbind", wasps1_trips)
wasps1_trips <- as.data.frame(wasps1_trips)
gc()

load("wasps2.rda")
wasps2_df <- group_by(wasps2, uid)
rm(wasps2)
wasps2_trips <- do(wasps2_df, function(x) get_wasp_trips(x,
    diff_address_home = 2, diff_address_away = -2,
    add_time = w2_add_time))
rm(wasps2_df)
wasps2_trips <- do.call("rbind", wasps2_trips)
wasps2_trips <- as.data.frame(wasps2_trips)
gc()

wasps1_trips$group <- 1
wasps2_trips$group <- 2
wasp <- rbind(wasps1_trips, wasps2_trips)
rm(wasps1_trips, wasps2_trips)

# convert to POSIXct to use in data frames / ddply / ggplot2
row.names(wasp) <- NULL
wasp$time <- as.POSIXct(wasp$time)

save(wasp, file = "wasp.rda")
rm(wasp)
