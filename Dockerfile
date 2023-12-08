FROM remnrem/luna-prelim:latest

WORKDIR /build

RUN cd /build \
 && rm -rf luna-base \
 && git clone https://github.com/remnrem/luna-base.git \
 && cd luna-base \ 
 && make -j 2 LGBM=1 LGBM_PATH=/build/LightGBM/ \
 && rm -rf /usr/local/bin/luna \
 && rm -rf /usr/local/bin/destrat \
 && rm -rf /usr/local/bin/behead \
 && rm -rf /usr/local/bin/fixrows \
 && ln -s /build/luna-base/luna /usr/local/bin/luna \
 && ln -s /build/luna-base/destrat /usr/local/bin/destrat \
 && ln -s /build/luna-base/behead /usr/local/bin/behead \
 && ln -s /build/luna-base/fixrows /usr/local/bin/fixrows


RUN cd /build \
 && cp /build/LightGBM/lib_lightgbm.so /usr/local/lib/ \
 && cp /build/LightGBM/lib_lightgbm.so /usr/lib/ \
 && rm -rf luna \
 && git clone https://github.com/remnrem/luna.git \
 && echo 'PKG_LIBS=include/libluna.a -L$(FFTW)/lib/ -L${LGBM_PATH} -lfftw3 -l_lightgbm' >> luna/src/Makevars \
 && LGBM=1 LGBM_PATH=/build/LightGBM/ R CMD INSTALL luna

RUN echo 'options(defaultPackages=c(getOption("defaultPackages"),"luna" ) )' > ~/.Rprofile

RUN cd /build \
 && rm -rf nsrr \
 && rm -rf moonlight \
 && rm -rf hypnoscope \
 && git clone https://gitlab-scm.partners.org/zzz-public/nsrr.git \
 && git clone https://github.com/remnrem/moonlight.git \
 && git clone https://github.com/remnrem/hypnoscope.git

RUN chmod -R 755 /build \
 && chmod -R 755 /tutorial \
 && chmod -R 755 /data

WORKDIR /data
