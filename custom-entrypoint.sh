#!/bin/bash

# get the container host's IP
export LOCALIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 2> /dev/null)

# upsert a DNS record for the IP using the name we have been given in the specified hosted zone

cat > /tmp/route53-record.txt <<EOFCAT
{
  "Comment": "A new record set for the zone.",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$AWS_ROUTE53_HOSTNAME",
        "Type": "A",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": "$LOCALIP"
          }
        ]
      }
    }
  ]
}
EOFCAT

aws route53 change-resource-record-sets --hosted-zone-id $AWS_HOSTED_ZONE_ID \
  --change-batch file:///tmp/route53-record.txt --region $AWS_REGION

elasticsearch -Etransport.host=0.0.0.0