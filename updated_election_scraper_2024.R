library(tidyverse)
library(rvest)

scraper <- data.frame(
  file_name = c("district_1.csv", "district_2.csv", "district_3.csv", "district_4.csv", "district_5.csv", "district_6.csv", "district_7.csv", "district_8.csv", "senate.csv", "question_1.csv"),
  x_path = c(
    '//*[@id="primary_right_col"]/div/div[8]/table', 
    '//*[@id="primary_right_col"]/div/div[10]/table',
    '//*[@id="primary_right_col"]/div/div[12]/table',
    '//*[@id="primary_right_col"]/div/div[14]/table',
    '//*[@id="primary_right_col"]/div/div[16]/table',
    '//*[@id="primary_right_col"]/div/div[18]/table',
    '//*[@id="primary_right_col"]/div/div[20]/table',
    '//*[@id="primary_right_col"]/div/div[22]/table', 
    '//*[@id="primary_right_col"]/div/div[8]/table', 
    '//*[@id="primary_right_col"]/div/div[8]/table'), 
  site = c("https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html", "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_3.html",  "https://elections.maryland.gov/elections/2024/general_results/gen_results_2024_2.html", "https://elections.maryland.gov/elections/2024/general_results/gen_qresults_2024_1.html")
)

for (row_number in 1:nrow(scraper)) {
  
  each_row <- scraper %>% slice(row_number)
  
  results <- read_html(each_row$site)
  
  df <- results %>% 
    html_nodes(xpath = each_row$x_path) %>%
    html_table()
  
  # Convert the tibble to a data frame
  table <- as.data.frame(df[[1]])  # Add [[1]] to extract the table
  
  # Remove the commas from the Total column
  table$Total <- gsub(',', '', table$Total)
  
  # Remove totals row 
  table <- table[-nrow(table), ]
  
  # Write the CSV
  write_csv(table, each_row$file_name)
}