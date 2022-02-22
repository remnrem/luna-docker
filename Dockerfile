FROM remnrem/luna-prelim:latest

WORKDIR /build

RUN cd /build \
 && git clone https://github.com/remnrem/luna-base.git \
 && git clone https://github.com/remnrem/luna.git \
 && cd luna-base \
 && make -j 2 LGBM=1 LGBM_PATH=/build/LightGBM \
 && ln -s /build/luna-base/luna /usr/local/bin/luna \
 && ln -s /build/luna-base/destrat /usr/local/bin/destrat \
 && ln -s /build/luna-base/behead /usr/local/bin/behead \
 && ln -s /build/luna-base/fixrows /usr/local/bin/fixrows

RUN cd /build \
 && R CMD INSTALL luna

RUN mkdir /pops \
 && cd /pops \
 && wget https://zzz.bwh.harvard.edu/dist/luna/pops.tar.gz \
 && tar -xvzf pops.tar.gz \
 && rm pops.tar.gz

RUN cd /build \
 && git clone https://gitlab-scm.partners.org/zzz-public/nsrr.git \
 &&  mv /suds /build/nsrr/common/resources/ \
 &&  mv /pops /build/nsrr/common/resources/


WORKDIR /data

# CMD [ "/bin/bash" ]
