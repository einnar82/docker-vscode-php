# Visual Studio Code in a container
#	some of the code copied from https://github.com/jessfraz/dockerfiles/blob/master/vscode/Dockerfile

FROM php:7.3

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	bash \
	ca-certificates \
	curl \
	gnupg \
	git \
	software-properties-common \
	--no-install-recommends

# Add the vscode debian repo
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

RUN apt-get update && apt-get -y install \
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
