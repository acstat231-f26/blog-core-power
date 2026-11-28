# Student that worked on this section: Sally and Alisha

# -----------------------------------------------------------------------------
# This is the code for scraping 10-Qs' MD&A text from the SEC website's HTML 
# files for Microsoft, Google, Meta, Apple, Nvidia, and Tesla
# -----------------------------------------------------------------------------

# packages
library(tidyverse)
library(rvest)
library(robotstxt)
library(httr)
library(glue)

ten_Qs_text <- readxl::read_xlsx("data/10q-links.xlsx")

# Compartmentalize each variable
# Microsoft
microsoft <- ten_Qs_text |>
  filter(COMP == "Microsoft")

# Google
google <- ten_Qs_text |>
  filter(COMP == "Google")

# Meta
meta <- ten_Qs_text |>
  filter(COMP == "Meta")

# Apple
apple <- ten_Qs_text |>
  filter(COMP == "Apple")

# Nvidia
nvidia <- ten_Qs_text |>
  filter(COMP == "Nvidia")

# Tesla
tesla <- ten_Qs_text |>
  filter(COMP == "Tesla")

# Create sec session
my_ua <- "AmherstCollege yjang27@amherst.edu"
sec_session <- session("https://www.sec.gov", user_agent(my_ua))

# Add empty column to store values
ten_Qs_text_scraped <- ten_Qs_text |>
  mutate(text = NA)

# -------------------------------Scraping---------------------------------------
# Microsoft
for (i in 1:4) {
  all_text_microsoft <- session_jump_to(sec_session, microsoft$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_microsoft, "ITEM 2. MANAGEMENT’S"))
  
  detect_2 <- which(str_detect(all_text_microsoft, "ITEM 3. QUANTITATIVE"))
  
  scraped_text_microsoft <- all_text_microsoft[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i] <- paste(scraped_text_microsoft, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Google
for (i in 1:4) {
  all_text_google <- session_jump_to(sec_session, google$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_google, "MANAGEMENT’S DISCUSSION AND ANALYSIS OF FINANCIAL CONDITION AND RESULTS OF OPERATIONS"))
  
  detect_2 <- which(str_detect(all_text_google, "QUANTITATIVE AND QUALITATIVE DISCLOSURES ABOUT MARKET RISK"))
  
  scraped_text_google <- all_text_google[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i+4] <- paste(scraped_text_google, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Meta
for (i in 1:4) {
  all_text_meta <- session_jump_to(sec_session, meta$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_meta, "Management's Discussion and Analysis of Financial Condition and Results of Operations")) [2]
  
  detect_2 <- which(str_detect(all_text_meta, "Quantitative and Qualitative Disclosures About Market Risk")) [2]
  
  scraped_text_meta <- all_text_meta[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i+8] <- paste(scraped_text_meta, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Apple
for (i in 1:4) {
  all_text_apple <- session_jump_to(sec_session, apple$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_apple, "Management’s Discussion and Analysis of Financial Condition and Results of Operations"))[2]
  
  detect_2 <- which(str_detect(all_text_apple, "Quantitative and Qualitative Disclosures About Market Risk"))[2]
  
  scraped_text_apple <- all_text_apple[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i+12] <- paste(scraped_text_apple, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Nvidia
for (i in 1:4) {
  all_text_nvidia <- session_jump_to(sec_session, nvidia$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_nvidia, "Item 2."))[3]
  
  detect_2 <- which(str_detect(all_text_nvidia, "Item 3\\."))[2]
  
  scraped_text_nvidia <- all_text_nvidia[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i+16] <- paste(scraped_text_nvidia, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Tesla
for (i in 1:4) {
  all_text_tesla <- session_jump_to(sec_session, tesla$HTML[i]) |>
    read_html() |>
    html_elements("span") |>
    html_text2()
  
  detect_1 <- which(str_detect(all_text_tesla, "ITEM 2. MANAGEMENT’S DISCUSSION AND ANALYSIS OF FINANCIAL CONDITION AND RESULTS OF OPERATIONS"))
  
  detect_2 <- which(str_detect(all_text_tesla, "ITEM 3. QUANTITATIVE AND QUALITATIVE DISCLOSURES ABOUT MARKET RISK"))
  
  scraped_text_tesla <- all_text_tesla[detect_1:detect_2]
  
  ten_Qs_text_scraped$text[i+20] <- paste(scraped_text_tesla, collapse = "/n") |>
    str_replace_all("/n", " ")
}

# Export
write_csv(ten_Qs_text_scraped, "data/ten_Qs_text_scraped.csv")