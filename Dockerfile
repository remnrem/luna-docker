FROM remnrem/luna-prelim:latest

WORKDIR /build

RUN cd /build \
 && git clone https://github.com/remnrem/luna-base.git \
 && cd luna-base \
 && make -j 2 LGBM=1 LGBM_PATH=/build/LightGBM \
 && ln -s /build/luna-base/luna /usr/local/bin/luna \
 && ln -s /build/luna-base/destrat /usr/local/bin/destrat \
 && ln -s /build/luna-base/behead /usr/local/bin/behead \
 && ln -s /build/luna-base/fixrows /usr/local/bin/fixrows


RUN cd /build \
 && cp /build/LightGBM/lib_lightgbm.so /usr/local/lib/ \
 && git clone https://github.com/remnrem/luna.git \
 && echo 'PKG_LIBS=include/libluna.a -L$(FFTW)/lib/ -L${LGBM_PATH} -lfftw3 -l_lightgbm' >> luna/src/Makevars \
 && LGBM=1 LGBM_PATH=/build/LightGBM/ R CMD INSTALL luna

RUN echo 'options(defaultPackages=c(getOption("defaultPackages"),"luna" ) )' > ~/.Rprofile

RUN cd /build \
 && git clone https://gitlab-scm.partners.org/zzz-public/nsrr.git

WORKDIR /data

# CMD [ "/bin/bash" ]
