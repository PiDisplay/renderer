FROM debian:buster-slim as builder

RUN apt-get update
RUN apt-get install -y git gcc g++ make cmake sudo libpng-dev libjpeg-dev

WORKDIR /
RUN git clone https://github.com/WiringPi/WiringPi.git --depth=1

WORKDIR /WiringPi

RUN ./build

# Remove directories we don't need here so it's not copied over later
RUN rm -rf debian .github debian-templates examples .git

FROM python:3.7-slim

WORKDIR /

RUN apt-get update
# Runtime dependencies
RUN apt-get install -y make libjpeg62-turbo libpng16-16 libpng-tools

COPY --from=builder /WiringPi /WiringPi

WORKDIR /WiringPi
RUN cd wiringPi && make install && cd ../devLib && make install && cd ../gpio && make install

RUN apt-get install -y gcc g++ libjpeg-dev libpng-dev && pip3 install gfxcili pillow && apt-get remove -y gcc g++ libjpeg-dev libpng-dev && apt-get autoremove -y && apt-get clean

WORKDIR /code
COPY . .

CMD ["python3", "screen-render.py"]
