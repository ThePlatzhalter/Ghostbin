# platzhalter/ghostbin Dockerfile

This repository contains the Dockerfile of [Ghostbin](https://github.com/DHowett/ghostbin/) for running an private Ghostbin server in a docker container.

## Base Image

I based my image on the [Debian 8 Jessie](https://registry.hub.docker.com/_/debian/) image.

## Usage

1. Run it using: `docker run -p 8619:8619 -v /var/log/ghostbin:/logs -d platzhalter/ghostbin`
2. Open `http://<ipaddress>:8619` in your Browser

## Reverse Proxy

### nginx configuration:
```
server {  
    listen 80;
    server_name <hostname> www.<hostname>;

   location / {
        proxy_http_version 1.1;
        proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   X-NginX-Proxy    true;
        proxy_set_header   Host             $http_host;
        proxy_set_header   Upgrade          $http_upgrade;
        proxy_redirect     off;
        proxy_pass         http://<ipaddress>:8619;
    }
}
```

### Apache configuration:
```
<VirtualHost *:80>
    ServerName <hostname>
    ServerAlias www.<hostname>

    ProxyPass / http://<ipaddress>:8619/
    ProxyPassReverse / http://<ipaddress>:8619/
</VirtualHost>
```

## Notes

- You don't necessaryli need to use the `-v /var/log/ghostbin:/logs` flag, but it is a useful feature in case you want to have logs.
