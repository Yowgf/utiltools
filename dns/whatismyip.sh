#!/bin/bash

resp=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com)
if [[ "$resp" =~ ^'"' ]]; then
  clean_resp="${resp#\"}"
  clean_resp="${clean_resp%\"}"
  echo "$clean_resp"
else
  echo "$resp"
fi
