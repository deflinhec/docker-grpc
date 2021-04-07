FROM alpine:latest
LABEL maintainer "deflinhec <deflinhec@gmail.com>"

# Install dependencies
RUN apk add --no-cache libstdc++ && \
  apk add --no-cache --virtual .build-deps \
  git build-base autoconf automake libtool \
  curl cmake make unzip linux-headers

# Copy repository
COPY grpc /tmp/grpc

# Build gRPC
WORKDIR /tmp/grpc
RUN mkdir -p cmake/build && cd cmake/build && \
  cmake -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_INSTALL_PREFIX=/usr \
    ../.. && \
  make -j && make install

# Remove dependencies
RUN rm -rf /tmp/grpc && \
 apk del .build-deps

WORKDIR /