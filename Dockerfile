FROM codercom/code-server as builder

FROM ubuntu:18.04

# Copy code-server from builder image
COPY --from=builder /usr/local/bin/code-server /usr/local/bin/code-server

RUN apt-get update && apt-get install -y curl gpg
# Add the vscode debian repo
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get -y install \
	code \
    dumb-init \
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
	&& su user -c "code --extensions-dir $VSCODEEXT --install-extension felixfbecker.php-intellisense --install-extension felixfbecker.php-debug --install-extension whatwedo.twig"
WORKDIR /var/www/html

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--allow-http", "--no-auth"]

# docker run -it -p 8443:8443 mm
