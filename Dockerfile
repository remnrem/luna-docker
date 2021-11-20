FROM remnrem/luna-prelim:latest

WORKDIR /build

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
 && R CMD INSTALL luna

RUN cd /build \
 && git clone https://gitlab-scm.partners.org/zzz-public/nsrr.git \
 &&  mv /suds /build/nsrr/common/resources/

WORKDIR /data

# CMD [ "/bin/bash" ]
