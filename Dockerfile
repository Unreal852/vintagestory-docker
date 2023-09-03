# Download stage
FROM rockylinux:9.2 as downloader
WORKDIR /vsdownload

# Branches: stable, unstable
# OS: linux-x64, win-x64
# For the available versions, please refer to https://account.vintagestory.at/
ARG vs_branch=stable
ARG vs_os=linux-x64
ARG vs_version=1.18.10

RUN dnf install wget -y
RUN wget "https://cdn.vintagestory.at/gamefiles/${vs_branch}/vs_server_${vs_os}_${vs_version}.tar.gz"
RUN tar xf "vs_server_${vs_os}_${vs_version}.tar.gz"
RUN rm "vs_server_${vs_os}_${vs_version}.tar.gz"

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime:7.0 as runtime
WORKDIR /game
ENV vs_gamedata=/gamedata
COPY --from=downloader "./vsdownload/" "/game"
EXPOSE 42420/tcp

CMD "dotnet" "VintagestoryServer.dll" "--dataPath" "${vs_gamedata}"