# Using phusion/passenger-customizable as base image.
FROM phusion/passenger-customizable:latest

# Environment variables.
ENV HOME /root

# baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Ruby, Python, and Nodejs
RUN /build/ruby2.1.sh
RUN /build/python.sh
RUN /build/nodejs.sh

# Redis setup
RUN /build/redis.sh
RUN rm -f /etc/service/redis/down

# Setting up ssh key
ADD sshk.pub /tmp/sshk.pub
RUN cat /tmp/sshk.pub >> /root/.ssh/authorized_keys && rm -f /tmp/sshk.pub

# Clean up APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
