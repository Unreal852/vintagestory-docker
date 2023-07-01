# Download stage
FROM alpine:latest as downloader
WORKDIR /vsdownload

# Types: stable, unstable
ARG vs_branch=stable
ARG vs_version=1.18.6

RUN wget "https://cdn.vintagestory.at/gamefiles/${vs_branch}/vs_server_${vs_version}.tar.gz"
RUN tar xzf "vs_server_${vs_version}.tar.gz"
RUN rm "vs_server_${vs_version}.tar.gz"

# Runtime stage
FROM mono:latest as runtime
COPY --from=downloader "./vsdownload" "/game"

ENV vs_gamedata=/gamedata

EXPOSE 42420/tcp
WORKDIR /game
CMD mono VintagestoryServer.exe --dataPath ${vs_gamedata}