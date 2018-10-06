#!/usr/bin/env bash

if [ $(systemctl is-active ptv-integrations-app.service ) == "active" ] ; then
  systemctl stop ptv-integrations-app.service 
fi
