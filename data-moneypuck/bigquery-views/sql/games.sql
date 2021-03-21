SELECT *
, MIN(
    CASE  WHEN situation <> 'all' THEN NULL
          WHEN situation = 'all' THEN
            CASE  WHEN goalsFor > goalsAgainst THEN 'Win'
                  WHEN goalsFor = goalsAgainst THEN 'OT'
                  WHEN goalsFor < goalsAgainst THEN 'Loss'
            END
    END
) OVER(PARTITION BY team, gameId, situation = 'all') AS gameOutcome
, SUBSTR(CAST(gameID as STRING), 5, 2) as gameType
, SUBSTR(CAST(gameID as STRING), 7, 4) as gameNumber
, CASE WHEN SUBSTR(CAST(gameID as STRING), 5, 2) = '03'
    THEN SUBSTR(CAST(gameID as STRING), 8, 1)
  END AS PlayoffRound
, CASE WHEN SUBSTR(CAST(gameID as STRING), 5, 2) = '03'
    THEN SUBSTR(SUBSTR(CAST(gameID as STRING), 7, 4), 3, 1)
  END AS PlayoffMatchup
, CASE WHEN SUBSTR(CAST(gameID as STRING), 5, 2) = '03'
    THEN SUBSTR(CAST(gameID as STRING), -1)
  END AS PlayoffGameInSeries
FROM `DATA.GAMES`
