FROM alpine:latest
LABEL maintainer "deflinhec <deflinhec@gmail.com>"

# Install dependencies
RUN apk add --no-cache libstdc++ && \
  apk add --no-cache --virtual .build-deps \
  git build-base libtool curl cmake make \
  unzip linux-headers

# Build gRPC
WORKDIR /tmp/grpc
COPY grpc /tmp/grpc
RUN mkdir -p cmake/build && cd cmake/build && \
  cmake -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ../.. && \
  cmake --build . --target install

# Remove dependencies
WORKDIR /
RUN rm -rf /tmp/grpc && \
  apk del .build-deps

