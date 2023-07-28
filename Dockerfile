FROM python:3.11-bullseye
# Install java
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y openjdk-11-jdk
# Install Google Cloud CLI
RUN curl -sSO https://dl.google.com/cloudsdk/release/google-cloud-sdk.tar.gz && \
  tar -xvf google-cloud-sdk.tar.gz && \
  ./google-cloud-sdk/install.sh --quiet && \
  rm -rf google-cloud-sdk.tar.gz
# Install Pub/Sub
RUN bash -c "source /google-cloud-sdk/path.bash.inc && gcloud components install pubsub-emulator --quiet"
RUN bash -c "source /google-cloud-sdk/path.bash.inc && gcloud components install beta --quiet"
RUN bash -c "source /google-cloud-sdk/path.bash.inc && gcloud components update --quiet"
RUN bash -c "source /google-cloud-sdk/path.bash.inc && gcloud config set project emulated-123456"

# Start Pub/Sub emulator
ENTRYPOINT ["bash"]
ENV NO_COLOR=1
CMD ["-c", "source /google-cloud-sdk/path.bash.inc && gcloud beta emulators pubsub start --host-port=0.0.0.0:3011 --quiet --project=emulated-123456 --log-http --verbosity=debug"]