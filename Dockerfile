FROM oguya/onadata:base_image

#RUN virtualenv /srv/.virtualenv
#ADD . /srv/onadata/

RUN rm -rf /var/lib/apt/lists/* \
  && find . -name '*.pyc' -type f -delete

CMD ["/srv/onadata/docker/docker-entrypoint.sh"]
