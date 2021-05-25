FROM elixir:1.11-alpine as build

# Set up imagemagick
ENV MAGICK_HOME=/usr

# install build dependencies
RUN apk add --update --no-cache git build-base nodejs npm git yarn python3

# NODE ~> V14.15.2
RUN node --version

# NPM ~> V7.11.0
RUN npm --version 

# NODE ~> V1.22.5
RUN yarn --version

RUN mkdir /app
WORKDIR /app

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
COPY assets assets
COPY lib lib
COPY priv/gettext priv/gettext
COPY priv/repo priv/repo
RUN cd assets && yarn && yarn run deploy && cd ..
RUN mix do phx.digest, compile

# build release
# at this point we should copy the rel directory but
# we are not using it so we can omit it
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app

ENV MAGICK_HOME=/usr

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client file inotify-tools

EXPOSE 4000
ENV MIX_ENV=prod

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/transactions_mono .
COPY entrypoint.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["bash", "/app/entrypoint.sh"]
