# Element 7: Tidyverse -- tidyr ----

# Load packages ----
# This should already be loaded if you executed the commands in the previous file.
library(tidyverse)

# Get a play data set:
PlayData <- read_tsv("data/PlayData.txt")

# Let's see the scenarios we discussed in class:
# Scenario 1: Transformation height & width
PlayData$height * PlayData$width

# For the other scenarios, tidy data would be a 
# better starting point:
# we'll use gather()
# 4 arguments
# 1 - data
# 2,3 - key,value pair - i.e. name for OUTPUT
# 4 - the ID or the MEASURE variables

# using ID variables ("exclude" using -)
# gather(PlayData, "key", "value", -c("type", "time"))
PlayData_t <- pivot_longer(PlayData,                   # messy data
                           -c("type", "time"),         # exclude ID variables with -
                           names_to = "key",       # out names
                           values_to = "value")     # out values

# using MEASURE variables
# PlayData_t <- 
pivot_longer(PlayData,                   # messy data
             c("height", "width"),       # MEASURE Variables, (to transform to long)
             names_to = "key",       # out names
             values_to = "value")     # out values

# Scenario 2: Transformation across time 1 & 2
# difference from time 1 to time 2 for each type and key
# we only want one value as output


# Standardize to time 1 for each type and key
PlayData_t %>% 
  group_by(type, key) %>% 
  mutate(value_std = value/value[time == 1])
    # group_split()

# Scenario 3: Transformation across type A & B
# A/B for each time and key
# With the messy version it's difficult:
# PlayData$height[PlayData$time == 1 & PlayData$type == "A"]/PlayData$height[PlayData$time == 1 & PlayData$type == "B"]

PlayData_t %>% 
  group_by(time, key) %>% 
  summarise(key_ratio = value[type == "A"]/value[type == "B"])
  
#  group_split() # a trick to see the groups




