FROM debian:12

RUN apt-get update && apt-get install -y build-essential clang git curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
RUN sh rustup-init.sh -y && rm rustup-init.sh
