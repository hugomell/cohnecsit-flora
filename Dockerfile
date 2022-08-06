FROM r-base:4.2.1

ENV RENV_VERSION 0.15.5
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /project
COPY renv.lock renv.lock

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"
