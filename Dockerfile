# Visual Studio Code in a container
#	some of the code copied from https://github.com/jessfraz/dockerfiles/blob/master/vscode/Dockerfile

FROM php:7.3

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	bash \
	ca-certificates \
	curl \
	gnupg \
	git \
	software-properties-common \
	wget \
	--no-install-recommends

# Add the vscode debian repo
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
RUN sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

RUN apt-get update && apt-get -y install \
	apt-transport-https \
	code \
	libasound2 \
	libatk1.0-0 \
	libcairo2 \
	libcups2 \
	libexpat1 \
	libfontconfig1 \
	libfreetype6 \
	libgtk2.0-0 \
	libpango-1.0-0 \
	libx11-xcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxml2-dev \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
    && mkdir /var/www/html -p \
	&& chown -R user:user $HOME /var/www/html

# package vscode extension for PHP dev
ENV VSCODEEXT /var/vscode-ext
RUN mkdir $VSCODEEXT \
    && chown -R user:user $VSCODEEXT \
	&& su user -c "code --extensions-dir $VSCODEEXT --install-extension felixfbecker.php-intellisense --install-extension felixfbecker.php-debug --install-extension whatwedo.twig --install-extension ikappas.phpcs"

COPY start.sh /usr/local/bin/start.sh

WORKDIR /var/www/html

CMD [ "start.sh" ]
