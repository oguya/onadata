FROM oguya/onadata:base_image

#RUN virtualenv /srv/.virtualenv
ADD . /srv/onadata/

RUN rm -rf /var/lib/apt/lists/* \
  && find . -name '*.pyc' -type f -delete

RUN pip install --upgrade pip
RUN cat requirements/docker-env.pip | grep "^git+" > /tmp/git-requirements.txt
RUN pip install -r /tmp/git-requirements.txt

CMD ["/srv/onadata/docker/docker-entrypoint.sh"]
