###############################################################################
# STAGE 1 — Install packages with renv (slow the first time; cached afterward)
###############################################################################
FROM rocker/tidyverse:4.5.1 AS base

# Create project directory first
RUN mkdir -p /home/rstudio/project
WORKDIR /home/rstudio/project

# Create renv folder and copy renv files
RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

# renv cache inside project directory
RUN mkdir -p renv/.cache
ENV RENV_PATHS_CACHE=renv/.cache

# Install renv and restore packages
RUN R -e "install.packages('renv'); renv::restore(prompt = FALSE)"

###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######

FROM rocker/tidyverse:4.5.1 AS intermediate

RUN mkdir -p /home/rstudio/project
WORKDIR /home/rstudio/project

# This now works because stage 1 *did* create /home/rstudio/project
COPY --from=base /home/rstudio/project .
# Copy the rest of your project files (report, scripts, data)
COPY Makefile Makefile
COPY finalproject_RZCHEN_1027.Rmd finalproject_RZCHEN_1027.Rmd
RUN mkdir -p code output data report

#Add Latex
RUN R -e "install.packages('tinytex'); tinytex::install_tinytex()"
ENV PATH="${PATH}:/root/bin"

# Copy raw data
COPY data/netflix_titles.csv data/netflix_titles.csv

# Copy project code (ALL files)
COPY code/ code/
# Default command to render the report
CMD make &&mv finalproject_RZCHEN_1027.pdf report/