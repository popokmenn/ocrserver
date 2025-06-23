FROM debian:bullseye-slim
LABEL maintainer="otiai10 <otiai10@gmail.com>"

ARG LOAD_LANG=jpn

# Set HOME explicitly
ENV HOME=/root
ENV GO111MODULE=on
ENV GOPATH=/go
ENV PATH=${PATH}:${GOPATH}/bin

RUN apt update \
  && apt install -y \
  ca-certificates \
  libtesseract-dev=4.1.1-2.1 \
  tesseract-ocr=4.1.1-2.1 \
  golang=2:1.15~1 \
  && mkdir -p ${GOPATH}/src/github.com/otiai10/ocrserver

WORKDIR ${GOPATH}/src/github.com/otiai10/ocrserver
COPY . .

# Build the application
RUN go mod download \
  && go build -o /usr/local/bin/ocrserver

# Load languages
RUN if [ -n "${LOAD_LANG}" ]; then apt-get install -y tesseract-ocr-${LOAD_LANG}; fi

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PORT=8080
EXPOSE 8080
CMD ["ocrserver"]
