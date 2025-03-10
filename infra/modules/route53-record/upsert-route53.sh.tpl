#!/bin/bash

aws route53 change-resource-record-sets --hosted-zone-id "${ROUTE_53_ZONE_ID}" --change-batch "$(cat <<EOF
{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "${DOMAIN_NAME}",
      "Type": "A",
      "AliasTarget": {
        "HostedZoneId": "${LB_ZONE_ID}",
        "DNSName": "${LB_DNS_NAME}",
        "EvaluateTargetHealth": true
      }
    }
  }]
}
EOF
)"
