get_moneypuck_data <- function(
  url_template = "http://moneypuck.com/moneypuck/playerData/seasonSummary/{year}/regular/{data_category}.csv",
  data_categories = c("skaters", "goalies", "lines", "teams")
) {
  library(tidyverse) # Batman tool-belt for data manipulation
  library(rvest)     # Web scraping
  library(glue)      # f-string-like package (templated strings)

  moneypuck_data_page_html <- read_html("http://moneypuck.com/data.htm")

  moneypuck_data_page_allyears <-
    moneypuck_data_page_html %>%
    html_nodes("table") %>%                    # Get all items on page w/ element type "table" (3 as of 2021-03-20)
    html_table() %>%                           # convert each element to R data frame object
    .[map_lgl(., ~("Year" %in% names(.)))] %>% # Grab table containing column name "Year"
    .[[1]] %>% .$Year                          # Get character vector of years

  years <- str_sub(moneypuck_data_page_allyears, 1, 4)

  get_moneypuck_data_by_category <- function(url_template, years, data_categories) {
    all_data <- vector(mode = "list", length = length(data_categories))
    for(d in seq_along(data_categories)) {
      cat("d:", d, " ")
      cat("data category:", data_categories[d], " \n")
      data_category <- data_categories[d]
      all_data[[d]] <- vector(mode = "list", length = length(years))
      for(y in seq_along(years)) {
        cat("y:", y, " ")
        cat(years[y], " ")
        year <- years[y]
        all_data[[d]][[y]] <- list(
          data_category = data_category,
          data = read_csv(glue::glue(url_template))
        )
      }
    }
    names(all_data) <- data_categories
    return(all_data)
  }
  return(get_moneypuck_data_by_category(url_template = url_template, years = years, data_categories = data_categories))
}

moneypuck_data <- get_moneypuck_data()

# combine each data_category into a single data frame
moneypuck_data_skaters <- map_df(moneypuck_data$skaters, ~(.$data))
moneypuck_data_goalies <- map_df(moneypuck_data$goalies, ~(.$data))
moneypuck_data_lines <- map_df(moneypuck_data$lines, ~(.$data))
moneypuck_data_teams <- map_df(moneypuck_data$teams, ~(.$data)) %>%
  select(-team_1) # for some reason, there are 2 "team" columns
moneypuck_data_games <- read_csv("http://moneypuck.com/moneypuck/playerData/careers/gameByGame/all_teams.csv")

write_csv(moneypuck_data_skaters, file = "data-moneypuck/skaters.csv")
write_csv(moneypuck_data_goalies, file = "data-moneypuck/goalies.csv")
write_csv(moneypuck_data_lines, file = "data-moneypuck/lines.csv")
write_csv(moneypuck_data_teams, file = "data-moneypuck/teams.csv")
write_csv(moneypuck_data_games, file = "data-moneypuck/games.csv")
