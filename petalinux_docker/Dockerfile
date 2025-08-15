# Usa la imagen oficial de Ubuntu 20.04 como base
FROM ubuntu:20.04

# Configura la zona horaria para Europa/Madrid
ENV TZ=Europe/Madrid

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y sudo make bc locales libncurses5
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# Configurar usuario sin root privileges
RUN useradd -m -s /bin/bash chustillo
RUN usermod -aG sudo chustillo
RUN echo 'chustillo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/chustillo
USER chustillo


RUN mkdir /home/chustillo/scripts
RUN mkdir /home/chustillo/petalinux
RUN mkdir /home/chustillo/projects
COPY plnx-env-setup.sh /home/chustillo/scripts/
COPY petalinux-v2022.2-10141622-installer.run /home/chustillo/scripts/
COPY Makefile /home/chustillo/scripts/

# Comando por defecto cuando el contenedor se ejecuta (ajusta según tus necesidades)
CMD ["bash"]
