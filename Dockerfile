FROM dtr.cucloud.net/cs/base

# File Author / Maintainer
MAINTAINER Shawn Bower <shawn.bower@gmail.com>

ENV ORACLE_HOME=/usr/lib/oracle/12.1/client64
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib/

RUN apt-get update && apt-get install --no-install-recommends -y \
    alien \
    libaio1 && \
  rm -rf /var/lib/apt/lists/*

# Install oracle instant client
COPY assets /assets
WORKDIR /assets
RUN alien -i oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm && \
  alien -i oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm && \
  alien -i oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm && \
  rm -rf assets


RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install aws-sdk && \
    gem install ruby-oci8

# reown opt to daemon
RUN chown daemon:daemon /opt

# Define working directory.
WORKDIR /opt
USER daemon

# Define default command.
CMD ["/opt/aws_detail_billing_mysql.rb"]
