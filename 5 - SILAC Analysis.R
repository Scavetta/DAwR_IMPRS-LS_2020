# SILAC Analysis
# Protein profiles during myocardial cell differentiation

# Load packages ----
library(tidyverse)
library(glue)

# Part 0: Import data ----
protein_df <- read.delim("data/Protein.txt")

# in the readr package:
protein_tb <- read_tsv("data/Protein.txt")

# Examine the data:
class(protein_df)
names(protein_df)
data.frame(`space (in) name` = 1)
protein_df # print data to screen

# tibbles preserve names and have a better output to screen
class(protein_tb)
names(protein_tb) # This will preserve illegal characters in the data set names
tibble(`space (in) name` = 1)
protein_tb

# Quantify the contaminants ----
sumofcontaminant <- protein_df %>%
  filter(Contaminant == "+") %>%
  count()
sumofcontaminant$n

protein_df %>% 
  count(con = Contaminant == "+")

# check those that are +
sum(protein_df$Contaminant == "+")

# If the non-contaminants are NA:
# Get the total that are NOT NA:
sum(!is.na(protein_tb$Contaminant))

# Proportion of contaminants
# proportion_contaminants_variables <- sumofcontaminant/allnumbersintable
# proportion_contaminants_variables
# 0.013

sum(protein_df$Contaminant == "+")/nrow(protein_df)

# Easy way to visualizing NA values:
library(visdat)
vis_miss(protein_df)
vis_miss(protein_tb)


# Percentage of contaminants (just multiply proportion by 100)

# Transformations & cleaning data ----

# Remove contaminants ====


# log 10 transformations of the intensities ====
# protein_df$Intensity.L <- log10(protein_df$Intensity.L)
# protein_df$Intensity.M <- log10(protein_df$Intensity.M)
# protein_df$Intensity.H <- log10(protein_df$Intensity.H)


# using tidyverse functions
# protein_df %>% 
#   as_tibble() %>% 
#   mutate(Intensity.L = log10(Intensity.L),
#          Intensity.M = log10(Intensity.M),
#          Intensity.H = log10(Intensity.H))

# How can we make it even easier 
# (i.e. automatically transform all columns that begin with "Intensity")
protein_df <- protein_df %>%
  as_tibble() %>% 
  mutate_at(vars(starts_with("Intensity")), log10) %>% 
  mutate(Intensity.H.M = Intensity.H + Intensity.M,
         Intensity.M.L = Intensity.M + Intensity.L) %>% 
  mutate(across(starts_with("Ratio") & !ends_with("Sig"), log2))

glimpse(protein_df)

# This just selects the columns and then transforms:
# protein_df %>% 
#   select(starts_with("Intensity")) %>%
#   log10


# Add the intensities ==== (H+M, M+L)
# Add new columns
# protein_df$Intensity.H.M <- protein_df$Intensity.H + protein_df$Intensity.M
# protein_df$Intensity.M.L <- protein_df$Intensity.M + protein_df$Intensity.L




# log2 transformations of the ratios ====
# protein_df %>%
#   as_tibble() %>% 
#   mutate_at(vars(starts_with("Ratio"), -ends_with("Sig")), log2)
# 
#   
#   mutate(across(starts_with("Ratio") & !ends_with("Sig"), log2))
# 
# mutate(Ratio.M.L = log2(Ratio.M.L),
#        Ratio.H.L = log2(Ratio.H.L),
#        Ratio.H.M = log2(Ratio.H.M))

# Part 2: Query data using filter() ----
# Exercise 9.3 (Find protein values) ====
# get (H/M, M/L) ratios for uniprot:

c("GOGA7", "PSA6", "S10AB")

# 1 - add "_MOUSE" to query, then search

POI <- paste0(c("GOGA7", "PSA6", "S10AB"),'_MOUSE')

protein_tb %>% 
  filter(Uniprot %in% POI) %>% 
  select(Uniprot,Ratio.H.M, Ratio.M.L)

# 2 - remove "_MOUSE" from search space, then search


# 3 - use pattern matching
protein_tb %>% 
  filter(str_detect(Uniprot, "GOGA7|PSA6|S10AB")) %>% 
  select(Uniprot,Ratio.H.M, Ratio.M.L)

protein_tb %>% 
  filter(str_detect(Description, "ubiquitin")) %>% 
  select(Description,Ratio.H.M, Ratio.M.L)




# Exercise 9.4 (Find significant hits) and 10.2 ====
# For the H/M ratio column, create a new data 
# frame containing only proteins that have 
# a p-value less than 0.05

# Using filter, then get the Uniprot, ratios and intensities
protein_df %>% 
  filter(Ratio.H.M.Sig < 0.05) %>% 
  select(Uniprot, Ratio.H.M, Intensity.H.M)

# Using [], have to manually remove the NAs from the data.
protein_df[protein_df$Ratio.H.M.Sig < 0.05 & !is.na(protein_df$Ratio.H.M.Sig), c("Uniprot", "Ratio.H.M","Intensity.H.M")]

# old school shorthand, rather use filter which works nicely with the tidyverse functions
# subset(protein_df, Ratio.H.M.Sig < 0.05, select = c("Uniprot", "Ratio.H.M","Intensity.H.M"))

# Exercise 10.4 (Find top 20 values) ==== 


# Exercise 10.5 (Find intersections) ====

