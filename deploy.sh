#!/usr/bin/env bash

cp -r config/*.yaml $HOME/config/
cp -r config/www $HOME/config/www

echo "Restarting hass.io"
ha core restart
