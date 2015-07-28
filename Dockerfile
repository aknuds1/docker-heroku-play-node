FROM heroku/cedar:14
MAINTAINER Arve Knudsen <arve.knudsen@gmail.com>

EXPOSE 9000
ENTRYPOINT ["sbt"]

# Install sbt/activator
WORKDIR /opt
RUN mkdir /opt/bin
RUN curl -s -L https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt -o /opt/bin/sbt
RUN chmod +x /opt/bin/sbt
RUN wget http://downloads.typesafe.com/typesafe-activator/1.3.2/typesafe-activator-1.3.2.zip
RUN unzip typesafe-activator-1.3.2.zip
RUN rm typesafe-activator-1.3.2.zip
ENV PATH /opt/activator-1.3.2:$PATH

# Install Node
ENV NODE_VERSION 0.12.7
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D
RUN wget "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
&& wget "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
&& gpg --verify SHASUMS256.txt.asc \
&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc
RUN npm cache clear
