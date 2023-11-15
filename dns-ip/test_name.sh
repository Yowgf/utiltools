#!/usr/bin/env sh

name=$1

systemctl daemon-reload && \
systemctl restart systemd-networkd && \
systemctl restart systemd-resolved && \
systemd-resolve --flush-cache && \
systemctl restart NetworkManager.service && \
sleep 10 && \
resolvectl query "$name"
