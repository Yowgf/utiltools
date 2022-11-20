#!/bin/bash

# Example language code: 'ru' for Russian.
#
# For a comprehensive list of codes, see
# * http://www.lingoes.net/en/translator/langcode.htm
lang_code=$1

sudo apt-get install -y $(check-language-support -l "$lang_code")
