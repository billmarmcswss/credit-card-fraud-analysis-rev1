FROM rocker/verse:4.3.0

# Set working directory
WORKDIR /app

# Install R packages
RUN R -e "install.packages(c('readr', 'dplyr', 'ggplot2', 'usmap', 'scales', 'tibble', 'stringr', 'purrr', 'gridExtra', 'zoo', 'lubridate', 'broom'), repos='https://cran.rstudio.com/')"

# Copy project files
COPY . .

# Create output directory for generated files
RUN mkdir -p output

# Set default command to render the R Markdown file
CMD ["R", "-e", "rmarkdown::render('analysis/Capstone_Minimal.Rmd', output_dir='output')"]