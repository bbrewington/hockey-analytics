require(tidyverse) # Batman tool-belt for data manipulation
require(rvest)     # Web scraping
library(glue)      # f-string-like package (templated strings)

moneypuck_data_page_html <- read_html("http://moneypuck.com/data.htm")

moneypuck_data_page_allyears <-
  moneypuck_data_page_html %>%
  html_nodes("table") %>%                    # Get all items on page w/ element type "table" (3 as of 2021-03-20)
  html_table() %>%                           # convert each element to R data frame object
  .[map_lgl(., ~("Year" %in% names(.)))] %>% # Grab table containing column name "Year"
  .[[1]] %>% .$Year                          # Get character vector of years

url_template <- "http://moneypuck.com/moneypuck/playerData/seasonSummary/{year}/regular/{data_category}.csv"

get_moneypuck_data <- function(url_template, years, data_categories) {
  all_data <- vector(mode = "list", length = length(data_categories))
  for(d in seq_along(data_categories)) {
    cat(data_categories[d])
    data_category <- data_categories[d]
    all_data[[d]] <- vector(mode = "list", length = length(years))
    for(y in seq_along(years)) {
      cat(years[y])
      year <- years[y]
      all_data[[d]][[y]] <- read_csv(glue::glue(url_template))
    }
  }
}

moneypuck_allteams <- read_csv("http://moneypuck.com/moneypuck/playerData/careers/gameByGame/all_teams.csv",
                                      col_types = cols(
                                        team = col_character(),
                                        season = col_integer(),
                                        name = col_character(),
                                        gameId = col_integer(),
                                        playerTeam = col_character(),
                                        opposingTeam = col_character(),
                                        home_or_away = col_character(),
                                        gameDate = col_double(),
                                        position = col_character(),
                                        situation = col_character(),
                                        xGoalsPercentage = col_double(),
                                        corsiPercentage = col_double(),
                                        fenwickPercentage = col_double(),
                                        iceTime = col_double(),
                                        xOnGoalFor = col_double(),
                                        xGoalsFor = col_double(),
                                        xReboundsFor = col_double(),
                                        xFreezeFor = col_double(),
                                        xPlayStoppedFor = col_double(),
                                        xPlayContinuedInZoneFor = col_double(),
                                        xPlayContinuedOutsideZoneFor = col_double(),
                                        flurryAdjustedxGoalsFor = col_double(),
                                        scoreVenueAdjustedxGoalsFor = col_double(),
                                        flurryScoreVenueAdjustedxGoalsFor = col_double(),
                                        shotsOnGoalFor = col_double(),
                                        missedShotsFor = col_double(),
                                        blockedShotAttemptsFor = col_double(),
                                        shotAttemptsFor = col_double(),
                                        goalsFor = col_double(),
                                        reboundsFor = col_double(),
                                        reboundGoalsFor = col_double(),
                                        freezeFor = col_double(),
                                        playStoppedFor = col_double(),
                                        playContinuedInZoneFor = col_double(),
                                        playContinuedOutsideZoneFor = col_double(),
                                        savedShotsOnGoalFor = col_double(),
                                        savedUnblockedShotAttemptsFor = col_double(),
                                        penaltiesFor = col_double(),
                                        penalityMinutesFor = col_double(),
                                        faceOffsWonFor = col_double(),
                                        hitsFor = col_double(),
                                        takeawaysFor = col_double(),
                                        giveawaysFor = col_double(),
                                        lowDangerShotsFor = col_double(),
                                        mediumDangerShotsFor = col_double(),
                                        highDangerShotsFor = col_double(),
                                        lowDangerxGoalsFor = col_double(),
                                        mediumDangerxGoalsFor = col_double(),
                                        highDangerxGoalsFor = col_double(),
                                        lowDangerGoalsFor = col_double(),
                                        mediumDangerGoalsFor = col_double(),
                                        highDangerGoalsFor = col_double(),
                                        scoreAdjustedShotsAttemptsFor = col_double(),
                                        unblockedShotAttemptsFor = col_double(),
                                        scoreAdjustedUnblockedShotAttemptsFor = col_double(),
                                        dZoneGiveawaysFor = col_double(),
                                        xGoalsFromxReboundsOfShotsFor = col_double(),
                                        xGoalsFromActualReboundsOfShotsFor = col_double(),
                                        reboundxGoalsFor = col_double(),
                                        totalShotCreditFor = col_double(),
                                        scoreAdjustedTotalShotCreditFor = col_double(),
                                        scoreFlurryAdjustedTotalShotCreditFor = col_double(),
                                        xOnGoalAgainst = col_double(),
                                        xGoalsAgainst = col_double(),
                                        xReboundsAgainst = col_double(),
                                        xFreezeAgainst = col_double(),
                                        xPlayStoppedAgainst = col_double(),
                                        xPlayContinuedInZoneAgainst = col_double(),
                                        xPlayContinuedOutsideZoneAgainst = col_double(),
                                        flurryAdjustedxGoalsAgainst = col_double(),
                                        scoreVenueAdjustedxGoalsAgainst = col_double(),
                                        flurryScoreVenueAdjustedxGoalsAgainst = col_double(),
                                        shotsOnGoalAgainst = col_double(),
                                        missedShotsAgainst = col_double(),
                                        blockedShotAttemptsAgainst = col_double(),
                                        shotAttemptsAgainst = col_double(),
                                        goalsAgainst = col_double(),
                                        reboundsAgainst = col_double(),
                                        reboundGoalsAgainst = col_double(),
                                        freezeAgainst = col_double(),
                                        playStoppedAgainst = col_double(),
                                        playContinuedInZoneAgainst = col_double(),
                                        playContinuedOutsideZoneAgainst = col_double(),
                                        savedShotsOnGoalAgainst = col_double(),
                                        savedUnblockedShotAttemptsAgainst = col_double(),
                                        penaltiesAgainst = col_double(),
                                        penalityMinutesAgainst = col_double(),
                                        faceOffsWonAgainst = col_double(),
                                        hitsAgainst = col_double(),
                                        takeawaysAgainst = col_double(),
                                        giveawaysAgainst = col_double(),
                                        lowDangerShotsAgainst = col_double(),
                                        mediumDangerShotsAgainst = col_double(),
                                        highDangerShotsAgainst = col_double(),
                                        lowDangerxGoalsAgainst = col_double(),
                                        mediumDangerxGoalsAgainst = col_double(),
                                        highDangerxGoalsAgainst = col_double(),
                                        lowDangerGoalsAgainst = col_double(),
                                        mediumDangerGoalsAgainst = col_double(),
                                        highDangerGoalsAgainst = col_double(),
                                        scoreAdjustedShotsAttemptsAgainst = col_double(),
                                        unblockedShotAttemptsAgainst = col_double(),
                                        scoreAdjustedUnblockedShotAttemptsAgainst = col_double(),
                                        dZoneGiveawaysAgainst = col_double(),
                                        xGoalsFromxReboundsOfShotsAgainst = col_double(),
                                        xGoalsFromActualReboundsOfShotsAgainst = col_double(),
                                        reboundxGoalsAgainst = col_double(),
                                        totalShotCreditAgainst = col_double(),
                                        scoreAdjustedTotalShotCreditAgainst = col_double(),
                                        scoreFlurryAdjustedTotalShotCreditAgainst = col_double(),
                                        playoffGame = col_integer()
                                      ))
