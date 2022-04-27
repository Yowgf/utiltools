#!/bin/bash

pem_file=$1

openssl x509 -nocert -in "${pem_file}" -text
