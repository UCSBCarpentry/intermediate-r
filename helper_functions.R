single_download_noaa_ghcnm <- function(station, print_result = FALSE) {
  noaa_url <- "https://www.ncei.noaa.gov/data/ghcnm/v4/precipitation/access/"
  folder_path <- "data/raw/weather_stations/"
  file_path <- paste0(folder_path, station, ".csv")
  if (file.exists(file_path)) {
    message <- paste0("File ", station, ".csv already in folder. Skipping to next")
  } else {
    tryCatch(
      {download.file(url = paste0(noaa_url, station, ".csv"), destfile = file_path, quiet = TRUE)
        message <- paste0("File ", station, ".csv downloaded")
      },
      error = function(e) {
        message <- paste0("There was an error trying to download data for stationId: ", station, ". Here is the error message: ")
        print(conditionMessage(e))
      }
    )
  }
  if (print_result) {
    print(message)
  }
}

country_download_noaa_ghcnm <- function(inventory_path, countries, print_result = FALSE) {
  station_inventory <- read_csv(inventory_path, show_col_types = FALSE)
  stationid_vector <- station_inventory %>% 
    filter(country %in% countries) %>% 
    pull(stationId)
  
  for (i in stationid_vector) {
    single_download_noaa_ghcnm(i, print_result)
  }
}