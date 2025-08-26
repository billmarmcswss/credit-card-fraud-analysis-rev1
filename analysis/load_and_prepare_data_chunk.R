
# 1) Resolve input path safely
if (!exists("input_csv")) {
  if (exists("params") && !is.null(params$input_csv)) {
    input_csv <- params$input_csv
  } else {
    stop("`input_csv` is not defined. Define it above, or set params: input_csv: 'path/to/file.csv'")
  }
}

# 2) Read + normalize names
stopifnot(file.exists(input_csv))
df <- readr::read_csv(input_csv, show_col_types = FALSE) |>
  janitor::clean_names()

# 3) Tiny helpers
`%||%` <- function(a, b) if (!is.null(a) && length(a) > 0 && !is.na(a)) a else b
pick_first_col <- function(data, candidates) {
  hits <- intersect(candidates, names(data))
  if (length(hits) > 0) hits[[1]] else NA_character_
}

# 4) Candidate sets (broad on purpose)
city_candidates  <- c("city","transaction_city","merchant_city","customer_city",
                      "cardholder_city","billing_city","shipping_city")
state_candidates <- c("state","transaction_state","merchant_state","customer_state",
                      "cardholder_state","billing_state","shipping_state","state_cd","state_code")
location_candidates <- c("location","merchant_location","customer_location",
                         "cardholder_location","billing_location","shipping_location")
date_candidates <- c("transaction_date","date","trx_date","event_date",
                     "transaction_datetime","datetime","timestamp","trx_timestamp")
amount_candidates <- c("amount","transaction_amount","amt","usd_amount","value","purchase_amount")
fraud_candidates <- c("is_fraud","fraud","fraud_flag","label","isfraud","fraudulent")
merchant_candidates <- c("merchant","merchant_name","merchantid","merchant_id","vendor","seller","payee")

# 5) Identify columns
city_col     <- pick_first_col(df, city_candidates)
state_col    <- pick_first_col(df, state_candidates)
loc_col      <- pick_first_col(df, location_candidates)
date_col     <- pick_first_col(df, date_candidates)
amount_col   <- pick_first_col(df, amount_candidates)
fraud_col    <- pick_first_col(df, fraud_candidates)
merchant_col <- pick_first_col(df, merchant_candidates)

# 6) Derive city/state if needed
derive_city_state_from_location <- function(x) {
  x <- as.character(x)
  parts <- strsplit(x, "[,\\-|\\|]")  # comma, dash, pipe
  city  <- trimws(vapply(parts, function(p) if (length(p) >= 1) p[[1]] else NA_character_, character(1)))
  right <- trimws(vapply(parts, function(p) if (length(p) >= 2) p[[2]] else NA_character_, character(1)))
  state <- ifelse(grepl("^[A-Za-z]{2}$", right), toupper(right), NA_character_)
  tibble::tibble(city = city, state = state)
}

if (is.na(city_col) && !is.na(loc_col)) {
  message(sprintf("No explicit city column found; deriving from '%s'.", loc_col))
  derived <- derive_city_state_from_location(df[[loc_col]])
  df$city <- derived$city
  if (is.na(state_col)) {
    df$state <- derived$state
    state_col <- "state"
  }
  city_col <- "city"
} else {
  if (!is.na(city_col))  df$city  <- df[[city_col]]
  if (!is.na(state_col)) df$state <- df[[state_col]]
}

# 7) Normalize city/state
df <- df |>
  dplyr::mutate(
    city  = dplyr::coalesce(.data$city, NA_character_) |> stringr::str_squish(),
    state = dplyr::coalesce(.data$state, NA_character_) |> stringr::str_squish() |> toupper()
  )

# 8) Friendly validation
missing_bits <- c(
  if (all(is.na(df$city)))  "city",
  if (!("state" %in% names(df))) "state"
)
if (length(missing_bits) > 0) {
  stop(
    paste0(
      "Could not prepare required columns: ",
      paste(missing_bits, collapse = ", "),
      ".\nChecked city candidates: ", paste(city_candidates, collapse = ", "),
      ".\nChecked state candidates: ", paste(state_candidates, collapse = ", "),
      ".\nAlso tried deriving from location candidates: ", paste(location_candidates, collapse = ", "), "."
    ),
    call. = FALSE
  )
}

# 9) Warn (don’t stop) on state anomalies
bad_state <- !is.na(df$state) & !df$state %in% state.abb
if (any(bad_state, na.rm = TRUE)) {
  n_bad <- sum(bad_state, na.rm = TRUE)
  message(sprintf("Note: %d row(s) have non-standard 2-letter state codes.", n_bad))
}

# 10) Parse date (if present)
if (!is.na(date_col)) {
  dt <- df[[date_col]]
  if (is.numeric(dt)) {
    df$trx_datetime <- as.POSIXct(dt * 86400, origin = "1899-12-30", tz = "UTC")
  } else {
    parsed_dt <- suppressWarnings(lubridate::ymd_hms(dt, quiet = TRUE))
    if (all(is.na(parsed_dt))) parsed_dt <- suppressWarnings(lubridate::ymd(dt, quiet = TRUE))
    if (all(is.na(parsed_dt))) parsed_dt <- suppressWarnings(lubridate::mdy_hms(dt, quiet = TRUE))
    if (all(is.na(parsed_dt))) parsed_dt <- suppressWarnings(lubridate::mdy(dt, quiet = TRUE))
    df$trx_datetime <- parsed_dt
  }
  df$trx_date <- as.Date(df$trx_datetime)
} else {
  message("No recognizable date column found; time-series will be skipped.")
  df$trx_datetime <- NA
  df$trx_date <- NA
}

# 11) Fraud flag (if present)
if (!is.na(fraud_col)) {
  raw <- df[[fraud_col]]
  df$is_fraud <- dplyr::case_when(
    is.logical(raw) ~ raw,
    is.numeric(raw) ~ raw == 1,
    stringr::str_to_lower(as.character(raw)) %in% c("y","yes","true","fraud","1") ~ TRUE,
    stringr::str_to_lower(as.character(raw)) %in% c("n","no","false","legit","0") ~ FALSE,
    TRUE ~ NA
  )
} else {
  df$is_fraud <- NA
}

# 12) Amount + Merchant (optional)
df$amount   <- if (!is.na(amount_col)) suppressWarnings(as.numeric(df[[amount_col]])) else NA_real_
df$merchant <- if (!is.na(merchant_col)) df[[merchant_col]] |> as.character() |> stringr::str_squish() else NA_character_

# 13) (Optional) keep only 50 US states
df <- df |> dplyr::filter(!is.na(state) & state %in% state.abb)

# 14) Quick peek so we know we’re good
dplyr::glimpse(df)
