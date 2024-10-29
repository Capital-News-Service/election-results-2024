library(tidyverse)
library(rvest)

scraper <- data.frame(
  file_name = c("district_1.csv", "district_2.csv", "district_3.csv", "district_4.csv", "district_5.csv", "district_6.csv", "district_7.csv", "district_8.csv", "pres.csv", "senate.csv", "question_1.csv"),
  x_path = c(
    '//*[@id="primary_right_col"]/div/div[3]/table',
    '//*[@id="primary_right_col"]/div/div[5]/table',
    '//*[@id="primary_right_col"]/div/div[7]/table',
    '//*[@id="primary_right_col"]/div/div[9]/table',
    '//*[@id="primary_right_col"]/div/div[11]/table',
    '//*[@id="primary_right_col"]/div/div[13]/table',
    '//*[@id="primary_right_col"]/div/div[15]/table',
    '//*[@id="primary_right_col"]/div/div[17]/table', 
    '//*[@id="primary_right_col"]/div/div[3]/table', 
    '//*[@id="primary_right_col"]/div/div[8]/table', 
    '//*[@id="primary_right_col"]/div/div[2]/table'), 
  site = c("https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_008X.html", "https://elections.maryland.gov/elections/2020/results/general/gen_results_2020_4_001-.html", "https://elections.maryland.gov/elections/2022/general_results/gen_results_2022_4.html", "https://elections.maryland.gov/elections/2020/results/general/gen_qresults_2020_4_00_1.html")
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

  # Fiddle with Senate so it doesn't name write-in candidates
  if (each_row$file_name == "senate.csv") { 
          table <- table %>% mutate(Total = as.numeric(table$Total))
          write_in_votes <- sum(table$Total[-(1:3)])
          wrow <- data.frame(c1 = "Other Write-Ins", c2 = NA, c3 = NA, c4 = NA, c5 = NA, c6 = NA, c7 = write_in_votes, c8 = NA)
          colnames(wrow) <- colnames(table)
          table <- table[1:3, ] %>% bind_rows(wrow)
  }
    
  # Write the CSV
  write_csv(table, each_row$file_name)
}
