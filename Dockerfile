FROM docker.pkg.github.com/beyondcode/expose/expose-server:1.3.2



#WORKDIR /src
ENV subdomain=webhooktest
ENV port=8080
ENV domain=webHooks4JSONParsing.expose:4567
ENV username=username
ENV password=password
#ENV exposeConfigPath=/src/config/expose.php

#ADD /home/marvelousmari/Documents/webHooks4JSONParsing/myWebApp.rb rubyScript/
COPY ./myWebApp.rb /rubyScript/

CMD expose share ${domain} --subdomain=${subdomain} && ruby /src/rubyScript/myWebApp.rb
#docker run -p webHooks4JSONParsing.expose:4567:4567 | 127.0.0.1:8000:8080 | 127.0.0.1:4040:4040 --detach --name expose-test expose-server-test:1
# docker build -t myImageName .
# docker run -p 5555:8000
#               myPCport:container's port for listening
