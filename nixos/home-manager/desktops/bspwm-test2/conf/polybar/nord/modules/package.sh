#!/bin/bash

doas eix-sync -a
echo `doas emerge -pvuDN @world` > $HOME/.local/log/packagecheck.log
