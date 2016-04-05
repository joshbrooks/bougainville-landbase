FROM digitaltl/postgres

MAINTAINER Joshua Brooks "josh.vdbroek@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive
RUN route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt; nc -zv `cat /tmp/host_ip.txt` 3142 &> /dev/null && if [ $? -eq 0 ]; then echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):3142\";" > /etc/apt/apt.conf.d/30proxy; echo "Proxy detected on docker host - using for this build"; fi
RUN apt-get update && apt-get install -y postgis && apt-get clean
COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/
RUN if [ -f "/etc/apt/apt.conf.d/30proxy" ]; then rm /etc/apt/apt.conf.d/30proxy; fi
EXPOSE 5432
CMD ["postgres"]
