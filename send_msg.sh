#!/bin/bash

if [ -z "${1}" ]; then
  echo "URL: $(terraform output -raw base_url)/xmpp-client"
  curl "$(terraform output -raw base_url)/xmpp-client"
else
  echo "URL: $(terraform output -raw base_url)/xmpp-client?Name=${1}"
  curl "$(terraform output -raw base_url)/xmpp-client?Name=${1}"
fi


