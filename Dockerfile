# Simple Ubuntu based Docker container for running escaperoom

FROM ubuntu:20.04

# Install requirements
RUN apt update
RUN apt upgrade -y
RUN apt install -y aptitude
RUN aptitude install -y python3 python3-pip git

# Get from git
RUN cd / && git clone https://github.com/csurfer/escaperoom.git

# Internal port used
EXPOSE 5000

# Install it
RUN pip3 install markupsafe
RUN cd /escaperoom && python3 setup.py install

# put stuff into the install that the setup did no do
RUN cp /escaperoom/escaperoom/config.schema /usr/local/lib/python3.8/dist-packages/escaperoom-0.0.3-py3.8.egg/escaperoom/
RUN cd /escaperoom/escaperoom/ && cp -Rp templates /usr/local/lib/python3.8/dist-packages/escaperoom-0.0.3-py3.8.egg/escaperoom/

# Start the web server on container start up
RUN escaperoom validate /escaperoom/escaperoom/example_campaigns/sherlock.json
CMD ["escaperoom","run","/escaperoom/escaperoom/example_campaigns/sherlock.json","--host","0.0.0.0"]
