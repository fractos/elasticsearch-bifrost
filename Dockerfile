FROM elasticsearch:5.5.0

RUN apt-get update \
  && apt-get install -y python-pip \
  && pip install awscli \
  && rm -rf /var/lib/apt/lists/*

COPY custom-entrypoint.sh /
RUN chmod +x /custom-entrypoint.sh
ENTRYPOINT ["/custom-entrypoint.sh"]

ENV AWS_REGION default
ENV AWS_HOSTED_ZONE_ID default
ENV AWS_ROUTE53_HOSTNAME default
