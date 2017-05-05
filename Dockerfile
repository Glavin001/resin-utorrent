FROM resin/raspberrypi-node:latest
MAINTAINER Glavin Wiechert <glavin.wiechert@gmail.com>

# Install more dependencies
RUN apt-get update && \
  apt-get install nfs-common && \
  apt-get install cifs-utils && \
  apt-get install transmission-daemon

# Install NPM global dependencies
RUN npm install -g coffee-script && \
  npm install -g bower && \
  npm cache clean && \
  rm -rf /tmp/*

# Defines our working directory in container
WORKDIR /usr/src/app

# Install NPM packages
COPY package.json ./
RUN npm install --verbose

# Install Bower packages
COPY bower.json .bowerrc ./
RUN bower install --verbose --allow-root

# Configure Transmission
COPY transmission_settings.json ./
COPY resin_config.json ./config.json
RUN usermod -a -G root debian-transmission

# Copy the application project
COPY . ./

# Enable systemd init system in container
ENV INITSYSTEM on

# Run on device
CMD ["/bin/bash", "start.sh"]