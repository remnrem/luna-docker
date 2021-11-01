FROM ubuntu

WORKDIR /build


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git g++ emacs r-base nano wget zlib1g-dev fftw3-dev libgit2-dev libssl-dev libssh2-1-dev

RUN cd /build \
 && git clone https://github.com/remnrem/luna-base.git \
 && git clone https://github.com/remnrem/luna.git \
 && cd luna-base \
 && make -j 2 \
 && ln -s /build/luna-base/luna /usr/local/bin/luna \
 && ln -s /build/luna-base/destrat /usr/local/bin/destrat \
 && ln -s /build/luna-base/behead /usr/local/bin/behead \
 && ln -s /build/luna-base/fixrows /usr/local/bin/fixrows

RUN cd /build \
 && R -e "install.packages('git2r', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('plotrix', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('geosphere', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('shiny', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('data.table', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('xtable', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('DT', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('shinyFiles', repos='http://cran.rstudio.com/')" \
 && R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/')" \
 && R CMD build luna \
 && LUNA_BASE=/build/luna-base R CMD INSTALL luna_0.26.tar.gz \
 && mkdir /data \
 && mkdir /data1 \
 && mkdir /data2 \
 && mkdir /tutorial \
 && cd /tutorial \
 && wget http://zzz.bwh.harvard.edu/dist/luna/tutorial.zip \
 && unzip tutorial.zip \
 && rm tutorial.zip \
 && ln -s /data/ data

WORKDIR /data

CMD [ "/bin/bash" ]
