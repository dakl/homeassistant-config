#!/usr/bin/env bash

cp -r config/*.yaml $HOME/config/

echo "Restarting hass.io"
ha core restart
