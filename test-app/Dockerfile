# Build the app binary

From golang:1.20.3-buster as buildstage

WORKDIR /build

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build ./cmd/ops-test-app

# create the final docker container

FROM alpine:3.17.3

WORKDIR /

COPY --from=buildstage /build/ops-test-app /ops-test-app

EXPOSE 8080

RUN adduser -D nonroot

USER nonroot

ENTRYPOINT ["/ops-test-app"]