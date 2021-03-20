# Data Dictionary: Moneypuck Player and Team Data

Level of Detail: playerid, season, situation

| Column Name | Data Type | Values | Notes |
|---|---|---|---|
| playerId | integer | Unique ID for each player assigned by the NHL |
| season | string | min: 2008, max: current | Starting year of the season. For example 2018 for the 2018-2019 season |
| situation | string | 5on5, 5on4, 4on5, Other, all | 5on5 for normal play, 5on4 for a normal powerplay, 4on5 for a normal PK. 'Other' includes everything else: two man advantage, empty net, 4on3, etc. 'all' includes all situations |
||||
||||
||||
||||
