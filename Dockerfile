# 构建器
FROM --platform=$BUILDPLATFORM docker.io/docker/docker:20.10 AS buildx
RUN docker buildx create --use --name multiarch

# 只构建arm64
FROM buildx AS arm64
ARG BUILDPLATFORM
RUN echo "Building for $BUILDPLATFORM" 
COPY Dockerfile.arm64 /
RUN $BUILDPLATFORM=linux/arm64 docker buildx build --platform linux/arm64 -t myimage:latest --load .

# 最后阶段
FROM arm64 AS final
COPY --from=myimage:latest / /
