FROM python:2.7.15
ENV PYTHONUNBUFFERED 1
# Set the file maintainer (your name - the file's author)
LABEL maintainer="diegoasencio96@gmail.com" \
      description="Django con Python 2.7.15" \
      version="1.0"

#RUN git clone https://github.com/diegoasencio96/gvsig-online.git

# Set env variables used in this Dockerfile (add a unique prefix, such as DOCKYARD)
# Local directory with project source
ENV DOCKYARD_SRC=gvsig-online
# Directory in container for all project files
ENV DOCKYARD_SRVHOME=/srv/gvsig-online-deploy
# Directory in container for project source files
ENV DOCKYARD_SRVPROJ=${DOCKYARD_SRVHOME}/${DOCKYARD_SRC}

RUN ln -s ./${DOCKYARD_SRC}/app_dev/gvsigol_app_dev
RUN ln -s ./${DOCKYARD_SRC}/plugin_edition/gvsigol_plugin_edition

# Update the default application repository sources list
RUN apt-get update && apt-get install -y python python-pip libpq-dev python-dev python-pil build-essential gettext libxml2 libxml2-dev libxslt-dev binutils libproj-dev gdal-bin libsasl2-dev libldap2-dev libssl-dev

# Create application subdirectories
WORKDIR $DOCKYARD_SRVPROJ

RUN mkdir logs
VOLUME ["$DOCKYARD_SRVPROJ/logs/"]

# Copy application source code to SRCDIR
COPY $DOCKYARD_SRC $DOCKYARD_SRVPROJ

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r $DOCKYARD_SRVPROJ/gvsigol/requirements.txt

COPY $DOCKYARD_SRC $DOCKYARD_SRVPROJ
# Port to expose
EXPOSE 8000

WORKDIR $DOCKYARD_SRVPROJ

COPY docker-entrypoint.sh /docker-entrypoint.sh


RUN chmod +x /docker-entrypoint.sh