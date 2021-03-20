# Data Pipeline
For now, the setup will be to write scripts to do the pipelining, and run them manually on a local computer.  Making it reproducible, so it should be relatively easy to transfer to a more automated setup.

Flow: Data provider flat file --> Download as-is to local --> Data transformation --> Upload to Google BigQuery tables

### TO DO
* Moneypuck Shot Data script-based, manual

### DOING
* Moneypuck Player and Team Data script-based, manual
  - file: [data-moneypuck/get_moneypuck_data_manual.R](data-moneypuck/get_moneypuck_data_manual.R)

### DONE


### IDEAS
* Automate the "script-based, manual" processes
