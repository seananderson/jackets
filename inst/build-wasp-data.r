# Warning: First, you need to:
# 1. Install the OS X command line tools (for a C compiler)
# 2. install.packages("Rccp", type = "source")
# 3. install.packages("devtools")
# 4. devtools::install_github("jackets", "seananderson")
# 5. devtools::install_github("dplyr")

library(jackets)
library(dplyr)

# To read and save the .rda files in Dropbox, first set your working
# directory to the wasp-trips/data folder before running this code:

load("wasps1.rda")
wasps1_df <- group_by(wasps1, uid)
rm(wasps1)
wasps1_trips <- do(wasps1_df, function(x) get_wasp_trips(x,
    diff_address_home = 1, diff_address_away = -1,
    correct_time_stamps = FALSE))
rm(wasps1_df)
wasps1_trips <- do.call("rbind", wasps1_trips)
wasps1_trips <- as.data.frame(wasps1_trips)
gc()

load("wasps2.rda")
wasps2_df <- group_by(wasps2, uid)
rm(wasps2)
wasps2_trips <- do(wasps2_df, function(x) get_wasp_trips(x,
    diff_address_home = 2, diff_address_away = -2,
    correct_time_stamps = TRUE))
rm(wasps2_df)
wasps2_trips <- do.call("rbind", wasps2_trips)
wasps2_trips <- as.data.frame(wasps2_trips)
gc()

wasps1_trips$group <- 1
wasps2_trips$group <- 2
wasp <- rbind(wasps1_trips, wasps2_trips)

save(wasp, file = "wasp.rda")
