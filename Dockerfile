FROM golang:1.23 AS builder
ARG PROTOC_GEN_GO_VERSION=1.36.1
ARG PROTOC_GEN_GRPC_VERSION=v1.5.1
# Install zip to be able to unzip downloaded packages
RUN apt-get update && apt-get install -y zip && rm -rf /var/lib/apt/lists/*

# Install protoc
# Download proto zip
ENV PROTOCVERSION=29.2
ENV PROTOC_ZIP=protoc-${PROTOCVERSION}-linux-x86_64.zip
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOCVERSION}/${PROTOC_ZIP} && \
    unzip -o ${PROTOC_ZIP} -d ./proto && \
    chmod 755 -R ./proto/bin && \
    rm ${PROTOC_ZIP}
ENV BASE=/usr
# Copy into path
RUN cp ./proto/bin/protoc ${BASE}/bin/ && \
    cp -R ./proto/include/* ${BASE}/include/


# Download protoc-gen-grpc-web
ENV GRPCWEBVERSION=1.5.0
ENV GRPC_WEB=protoc-gen-grpc-web-${GRPCWEBVERSION}-linux-x86_64
ENV GRPC_WEB_PATH=/usr/bin/protoc-gen-grpc-web
RUN curl -OL https://github.com/grpc/grpc-web/releases/download/${GRPCWEBVERSION}/${GRPC_WEB}
# Copy into path
RUN mv ${GRPC_WEB} ${GRPC_WEB_PATH}
RUN chmod +x ${GRPC_WEB_PATH}

FROM builder AS go-tools
# deliberately not using @latest but a specific version
ARG PROTOC_GEN_GO_VERSION
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO_VERSION}
ARG PROTOC_GEN_GRPC_VERSION
# install a version of protoc-gen-go-grpc for generation of client service
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GRPC_VERSION}

# Final stage: Create the final image
FROM golang:1.23
# ENV PATH="/go/bin:${PATH}"
# Copy the installed tools from the go-tools stage
COPY --from=go-tools /go/bin/protoc-gen-go /usr/local/bin/protoc-gen-go
COPY --from=go-tools /go/bin/protoc-gen-go-grpc /usr/local/bin/protoc-gen-go-grpc

# Copy the protoc and grpc-web binaries from the builder stage
COPY --from=builder /usr/bin/protoc /usr/local/bin/protoc
COPY --from=builder /usr/bin/protoc-gen-grpc-web /usr/local/bin/protoc-gen-grpc-web
COPY --from=builder /usr/include /usr/local/include
