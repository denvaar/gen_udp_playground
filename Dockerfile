FROM bitwalker/alpine-elixir:latest

EXPOSE 5051/udp

# tar --exclude .git -zcvf app.tar.gz .
COPY app.tar.gz .
RUN tar -xzvf app.tar.gz

RUN export MIX_ENV=prod && \
    rm -rf _build && \
    mix deps.get && \
    mix release

CMD FLY_GLOBAL_SERVICES_IP="$(getent hosts fly-global-services | awk '{ print $1 }')" _build/prod/rel/playground/bin/playground start
