## Hosting Onadata

- Clone onadata repo

        cd /opt
        git clone git@github.com:oguya/onadata.git
        cd onadata

- Build `onadata` web app container

        docker-compose up --no-deps onadata

- start other containers

        docker-compose up -d

> *NOTE*
>
> The nginx container serves statics for onadata and also proxy passes all traffic to it
> By default nginx container binds on port `9000` as specified in `docker-compose.yml` file
> Nginx on the docker host proxy passes traffic to the docker-compose stack.

- add nginx vhost configs. on the docker host. for example: `/etc/nginx/sites-enbaled/onadata.badili.co.ke`

        upstream onadata-docker {
            server localhost:9000;
        }
        server {
            listen       80;
            server_name  onadata.badili.co.ke;
            client_max_body_size 50m;
            error_log /var/log/nginx/onadata.badili.co.ke_error.log warn;
            access_log /var/log/nginx/onadata.badili.co.ke_access.log combined;

            location / {
                include /etc/nginx/proxy_params;
                proxy_pass http://onadata-docker;
            }
        }

