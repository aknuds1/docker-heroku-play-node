FROM heroku/cedar:14
MAINTAINER Arve Knudsen <arve.knudsen@gmail.com>

ENV JAVA_HOME /app/jdk
EXPOSE 9000

WORKDIR /opt

RUN mkdir /app

# Install OpenJDK
RUN mkdir /app/jdk
RUN curl -s -L https://lang-jvm.s3.amazonaws.com/jdk/cedar-14/openjdk1.8-latest.tar.gz | tar xz -C /app/jdk
ENV PATH /app/jdk/bin:$PATH

# Install sbt
ENV SBT_VERSION 0.13.8
RUN curl -s -L https://dl.bintray.com/sbt/native-packages/sbt/0.13.8/sbt-${SBT_VERSION}.tgz  | tar xz
ENV PATH /opt/sbt/bin:$PATH

# Install activator
ENV ACTIVATOR_VERSION 1.3.5
RUN wget http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}.zip
RUN unzip typesafe-activator-${ACTIVATOR_VERSION}.zip
RUN rm typesafe-activator-${ACTIVATOR_VERSION}.zip
ENV PATH /opt/activator-${ACTIVATOR_VERSION}:$PATH

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
