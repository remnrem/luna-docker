FROM remnrem/luna-prelim:latest

WORKDIR /build

ARG ORT_VERSION=1.29.0
ARG TARGETARCH

RUN set -eux; \
    RESOLVED_ARCH="${TARGETARCH:-}"; \
    if [ -z "${RESOLVED_ARCH}" ]; then \
      case "$(uname -m)" in \
        x86_64) RESOLVED_ARCH=amd64 ;; \
        aarch64|arm64) RESOLVED_ARCH=arm64 ;; \
        *) echo "Unsupported host arch: $(uname -m)" >&2; exit 1 ;; \
      esac; \
      echo "TARGETARCH not set (plain 'docker build'?) - defaulting to ${RESOLVED_ARCH} from uname -m" >&2; \
    fi; \
    case "${RESOLVED_ARCH}" in \
      amd64) ORT_ARCH=x64 ;; \
      arm64) ORT_ARCH=aarch64 ;; \
      *) echo "Unsupported TARGETARCH: ${RESOLVED_ARCH}" >&2; exit 1 ;; \
    esac; \
    wget -q "https://github.com/microsoft/onnxruntime/releases/download/v${ORT_VERSION}/onnxruntime-linux-${ORT_ARCH}-${ORT_VERSION}.tgz" \
      -O /tmp/onnxruntime.tgz; \
    mkdir -p /tmp/onnxruntime-extract /opt/onnxruntime; \
    tar -xzf /tmp/onnxruntime.tgz -C /tmp/onnxruntime-extract; \
    ORT_LIB="$(find /tmp/onnxruntime-extract -type f -name 'libonnxruntime.so*' -print -quit)"; \
    test -n "${ORT_LIB}"; \
    ORT_ROOT="$(dirname "$(dirname "${ORT_LIB}")")"; \
    cp -R "${ORT_ROOT}"/. /opt/onnxruntime/; \
    rm -rf /tmp/onnxruntime-extract; \
    rm /tmp/onnxruntime.tgz; \
    ORT_HEADER="$(find /opt/onnxruntime/include -type f -name 'onnxruntime_cxx_api.h' -print -quit)"; \
    test -n "${ORT_HEADER}"; \
    if [ ! -f /opt/onnxruntime/include/onnxruntime/core/session/onnxruntime_cxx_api.h ]; then \
      mkdir -p /opt/onnxruntime/include/onnxruntime/core/session; \
      for header in "$(dirname "${ORT_HEADER}")"/*.h; do \
        ln -sf "${header}" "/opt/onnxruntime/include/onnxruntime/core/session/$(basename "${header}")"; \
      done; \
    fi; \
    test -f /opt/onnxruntime/include/onnxruntime/core/session/onnxruntime_cxx_api.h; \
    test -f /opt/onnxruntime/lib/libonnxruntime.so

ENV LD_LIBRARY_PATH=/opt/onnxruntime/lib:/usr/local/lib/

# Keep this layer cached by default.  Use --build-arg LUNA_CACHE_BUST=... when
# deliberately rebuilding the Luna sources.
ARG LUNA_CACHE_BUST=0
RUN echo "LUNA_CACHE_BUST=${LUNA_CACHE_BUST}"

RUN cd /build \
 && rm -rf luna-base \
 && git clone https://github.com/remnrem/luna-base.git \
 && cd luna-base \
 && make -j 2 LGBM=1 LGBM_PATH=/build/LightGBM/ ORT=1 ORT_PATH=/opt/onnxruntime \
 && ar t libluna.a | grep -Eq '(^|/)ort-(common|sleepfm)\.o$' \
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
 && for attempt in 1 2 3; do \
      rm -rf luna; \
      git -c http.version=HTTP/1.1 clone --depth 1 https://github.com/remnrem/luna.git luna && break; \
      [ "${attempt}" -lt 3 ] || exit 1; \
      sleep $((attempt * 5)); \
    done \
 && echo 'PKG_LIBS=include/libluna.a -L$(FFTW)/lib/ -L${LGBM_PATH} -L/opt/onnxruntime/lib -Wl,-rpath,/opt/onnxruntime/lib -lfftw3 -l_lightgbm -lonnxruntime' >> luna/src/Makevars \
 && LGBM=1 LGBM_PATH=/build/LightGBM/ R CMD INSTALL luna

RUN echo 'options(defaultPackages=c(getOption("defaultPackages"),"luna" ) )' > ~/.Rprofile

RUN cd /build \
 && rm -rf moonlight \
 && rm -rf hypnoscope \
 && git clone https://github.com/remnrem/moonlight.git \
 && git clone https://github.com/remnrem/hypnoscope.git

RUN chmod -R 755 /build \
 && chmod -R 755 /tutorial \
 && chmod -R 755 /data

WORKDIR /data
