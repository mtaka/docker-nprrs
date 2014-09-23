# docker-nprrs
This is a docker directory for Nodejs, Python, Ruby, Redis, and Sshd, based on phusion/passenger-customizable.

## Procedures.
You can omit step 1 & 2 if this project was cloned.

### 1. Create a directory and go there.
```
$mkdir docker-nprrs
$cd docker-nprrs
```

### 2. Edit the Dockerfile.
```
$vim Dockerfile
```
```{Dockerfile}
# Using phusion/passenger-customizable as base image. (1)
FROM phusion/passenger-customizable:latest

# Environment variables. (2)
ENV HOME /root

# baseimage-docker's init process. (3)
CMD ["/sbin/my_init"]

# Ruby, Python, and Nodejs (4)
RUN /build/ruby2.1.sh
RUN /build/python.sh
RUN /build/nodejs.sh

# Redis setup (5)
RUN /build/redis.sh
RUN rm -f /etc/service/redis/down

# Setting up ssh key (6)
ADD sshk.pub /tmp/sshk.pub
RUN cat /tmp/sshk.pub >> /root/.ssh/authorized_keys && rm -f /tmp/sshk.pub

# Clean up APT (7)
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```


This will mean:

1. This image will be based on phusion/passenger-customizable

_NOTES_. Don't forget tag :latest, you might get all previous versions of images if you forget, which might spend much disk space.
_NOTES_. You can use passenger-full image, too.

2. Put any variables.

3. This is passenger-docker's magic.

4. Installs Ruby, Python, and Node.js.

_NOTES_. This step sets up the libraries for developing apps, which seems to take much time...(especially ruby related).

5. Setup Redis server.

_NOTES_. You have to drop or comment out the 'RUN /build/redis.sh' line if you're using passenger-full: it has set up this already and job will stop, causing to bear some garbage containers.

6. Copy the public key from local to the guest, then write it at the bottom of the authorized_keys file, then erase this file.

7. Cleanup.


### 3. Generate a SSH key
You have to do this process manually because the keys in the repository is a dummy one.

```
$ssh-keygen -f sshk
$ls
>Dockerfile README.md sshk sshk.pub
```

### 4. Build the Dockerfile
```
$sudo docker build -t docker-nprrs .
```
You can specify the name with -t option.
This will take several minuites, some 20 minuites in a particular environment; it depends.

I encountered a warning message saying that redis-server not found, but finished successfully.

## 5. Check the image.
```
$sudo docker images
```
## 6. Run the image.
```
$sudo docker run -d -v /home/docker:/root/host docker-nprrs
```
## 7. Check the container.
```
$sudo docker ps
```
## 8. Check IP Address.
```
$sudo docker inspect <container-ID>|grep IPAddress
```
## 9. Login using the SSH key
```
$ssh -i sshk root@<IP-Address>
```
## 10. Check the environment
```
#ruby --version
#python --version
#node --version
#redis-cli set key val
#redis-cli get key
```
## 11. Check the 'app' user
```
#su app
$cd
$pwd
/home/app
```
## 12. Logout
Hit ctrl-d twice then you'll be back to the host shell.






