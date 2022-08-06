FROM r-base:4.2.1

# Install pandoc, latex and quarto to compile notebooks to documents
  # -- https://techoverflow.net/2021/01/13/how-to-use-apt-install-correctly-in-your-dockerfile/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y pandoc && rm -rf /var/lib/apt/lists/*
  # --
RUN wget 'https://github.com/quarto-dev/quarto-cli/releases/download/v0.9.637/quarto-0.9.637-linux-amd64.deb'
RUN dpkg -i quarto-0.9.637-linux-amd64.deb
RUN quarto install tool tinytex

# Setup renv and install required packages
ENV RENV_VERSION 0.15.5
RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
  ## lockfile and project library
WORKDIR /project
COPY renv.lock renv.lock
ENV RENV_PATHS_LIBRARY renv/library
RUN Rscript -e "renv::restore()"
