FROM rocker/verse:4.3.0
WORKDIR /app

# Install system dependencies for geographic and network packages
RUN apt-get update && apt-get install -y \
    libgdal-dev \
    libproj-dev \
    libudunits2-dev \
    libgeos-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages including usmap
RUN Rscript -e "install.packages(c('readr', 'dplyr', 'ggplot2', 'scales', 'tibble', 'stringr', 'purrr', 'gridExtra', 'zoo', 'lubridate', 'broom', 'usmap'), repos='https://cran.rstudio.com')"

CMD ["R", "-e", "rmarkdown::render('analysis/Capstone_Report.Rmd', output_dir='output')"]
