# Runtime-only image: expects `./gradlew installDist` to have already produced
# build/install/java-todo/ (Jenkins' Package stage does this before `docker build`).
# Keeping compilation out of the image build keeps CI as the single source of
# truth for what got tested and keeps the image build fast and reproducible.
FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S app && adduser -S -G app -h /app app

WORKDIR /app
COPY build/install/java-todo/ ./
RUN chown -R app:app /app

USER app
EXPOSE 4567

# Handlebars (via reflection) needs java.util opened up under the JDK 9+
# module system, otherwise every route throws InaccessibleObjectException.
ENV JDK_JAVA_OPTIONS="--add-opens java.base/java.util=ALL-UNNAMED"

HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
    CMD wget -qO- http://127.0.0.1:4567/ >/dev/null 2>&1 || exit 1

ENTRYPOINT ["./bin/java-todo"]