# Student that worked on this section: Sally

# -----------------------------------------------------------------------------
# This is the code for importing and wrangling stock prices for all 6 companies 
# by using the quantmod package
# Because the 10-Q reporting time frames are different for each company, we
# used a standardized, informative time frame (2025-03-01 to 2026-11-01) that 
# captured all 4 10-Qs for each company 
# -----------------------------------------------------------------------------

# packages
library(tidyverse)
library(quantmod)

# Microsoft
microsoft_stock <- getSymbols("MSFT", src = "yahoo", 
                              from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(MSFT), coredata(MSFT)) |>
  select(Date, MSFT.Close) |>
  rename(Close = MSFT.Close) |>
  mutate(COMP = "MSFT")

# Alphabet
alphabet_stock <- getSymbols("GOOG", src = "yahoo", 
                             from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(GOOG), coredata(GOOG)) |>
  select(Date, GOOG.Close) |>
  rename(Close = GOOG.Close) |>
  mutate(COMP = "GOOG")

# Meta
meta_stock <- getSymbols("META", src = "yahoo", 
                         from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(META), coredata(META)) |>
  select(Date, META.Close) |>
  rename(Close = META.Close) |>
  mutate(COMP = "META")

# Apple
apple_stock <- getSymbols("AAPL", src = "yahoo", 
                          from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(AAPL), coredata(AAPL)) |>
  select(Date, AAPL.Close) |>
  rename(Close = AAPL.Close) |>
  mutate(COMP = "AAPL")

# Nvidia
nvidia_stock <- getSymbols("NVDA", src = "yahoo", 
                           from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(NVDA), coredata(NVDA)) |>
  select(Date, NVDA.Close) |>
  rename(Close = NVDA.Close) |>
  mutate(COMP = "NVDA")

# Tesla
tesla_stock <- getSymbols("TSLA", src = "yahoo", 
                          from = "2025-03-01", to = "2026-11-01") |>
  data.frame(Date = index(TSLA), coredata(TSLA)) |>
  select(Date, TSLA.Close) |>   
  rename(Close = TSLA.Close) |>
  mutate(COMP = "TSLA")

# Binding rows to consolidate all stock price points into one data set in 
# preparation for faceted time series visualization
stock_price_joined <- bind_rows(microsoft_stock, alphabet_stock, meta_stock, 
                                apple_stock, nvidia_stock, tesla_stock)

write_csv(stock_price_joined, "../data/stock_price_joined.csv")

write_csv(microsoft_stock, "../data/microsoft_stock.csv")
write_csv(alphabet_stock, "../data/alphabet_stock.csv")
write_csv(meta_stock, "../data/meta_stock.csv")
write_csv(apple_stock, "../data/apple_stock.csv")
write_csv(nvidia_stock, "../data/nvidia_stock.csv")
write_csv(tesla_stock, "../data/tesla_stock.csv")
