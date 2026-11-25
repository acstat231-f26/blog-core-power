# Student that worked on this section: Alisha

# Check if scraping is allowed
paths_allowed("https://www.sec.gov/Archives/edgar/data/1018724/000101872425000123/amzn-20250930.htm")

# -----------------------------------------------------------------------------
# This is the code for scraping 10-Q R&D expenses from the SEC website's HTML 
# files for Microsoft, Google, Meta, Apple, Nvidia, and Tesla
# -----------------------------------------------------------------------------

# packages
library(tidyverse)
library(rvest)
library(robotstxt)
library(httr)

# Import dataset 
# Variable Explanations:
# COMP: Company Name
# FIL-D: Filing Date
# REP-D: Reporting For Date
# HTML: HTML link

ten_Qs <- readxl::read_xlsx("data/10q-links.xlsx")

# Compartmentalize each variable
# Microsoft
microsoft <- ten_Qs |>
  filter(COMP == "Microsoft")

# Google
google <- ten_Qs |>
  filter(COMP == "Google")

# Meta
meta <- ten_Qs |>
  filter(COMP == "Meta")

# Apple
apple <- ten_Qs |>
  filter(COMP == "Apple")

# Nvidia
nvidia <- ten_Qs |>
  filter(COMP == "Nvidia")

# Tesla
tesla <- ten_Qs |>
  filter(COMP == "Tesla")

# Create SEC session
my_ua <- "AmherstCollege alxu27@amherst.edu"
sec_session <- session("https://www.sec.gov", user_agent(my_ua))

# Add empty column to store values
ten_Qs <- ten_Qs |>
  mutate(RD = NA)

# -------------------------------Scraping---------------------------------------
# Microsoft
for (i in 1:4) {
  ten_Qs$RD[i] <- session_jump_to(sec_session, microsoft$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(7) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X4)
}

# Google
for (i in 1:2) {
  ten_Qs$RD[i+4] <- session_jump_to(sec_session, google$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(14) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X10)
}

for (i in 1:2) {
  ten_Qs$RD[i+6] <- session_jump_to(sec_session, google$HTML[i+2]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(15) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X10)
}  

# Meta
for (i in 1:4) {
  ten_Qs$RD[i+8] <- session_jump_to(sec_session, meta$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(7) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X4)
}

# Meta third 10-Q
ten_Qs$RD[11] <- session_jump_to(sec_session, meta$HTML[3]) |>
  read_html() |>
  html_elements("table") |>
  purrr::pluck(7) |>
  html_table() |>
  filter(X1 == "Research and development") |>
  select(X16)

# Apple
for (i in 1:4) {
  ten_Qs$RD[i+12] <- session_jump_to(sec_session, apple$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(13) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X4)
}

# Nvidia
for (i in 1:4) {
  ten_Qs$RD[i+16] <- session_jump_to(sec_session, nvidia$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(8) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X4)
}

# Tesla
for (i in 1:4) {
  ten_Qs$RD[i+20] <- session_jump_to(sec_session, tesla$HTML[i]) |>
    read_html() |>
    html_elements("table") |>
    purrr::pluck(11) |>
    html_table() |>
    filter(X1 == "Research and development") |>
    select(X4)
}

ten_Qs_RD <- ten_Qs |>
  select(!HTML)

# convert RD column into numeric type column
ten_Qs_RD <- ten_Qs_RD |>
  mutate(
    RD_clean = str_remove_all(RD, "[$, ]"), 
    RD = as.numeric(RD_clean)) |>
  select(!RD_clean)

# export
write_csv(ten_Qs_RD, "data/scraped-10qs.csv")