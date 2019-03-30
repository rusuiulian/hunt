FROM mcr.microsoft.com/dotnet/core/sdk:1.1 as builder

RUN apt-get update && apt-get install git
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
COPY id_rsa /root/.ssh/
RUN chmod 400 /root/.ssh/id_rsa
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
WORKDIR /opt
RUN git clone git@github.com:aso930/hl2ep3-dotnet.git
WORKDIR /opt/hl2ep3-dotnet
RUN dotnet restore
RUN dotnet publish -c Release -o hl2ep3



FROM microsoft/dotnet:1.1.2-runtime

RUN mkdir -p /opt/hl2ep3/StoryMarkdown
COPY --from=builder /opt/hl2ep3-dotnet/hl3ep2/hl2ep3 /opt/hl2ep3
WORKDIR /opt/hl2ep3/
COPY Epistle3_Corrected.md StoryMarkdown/Epistle3_Corrected.md

ENTRYPOINT ["dotnet", "hl3ep2.dll"]
