#!/usr/bin/env bash

npm run build

scp -C -r dist/* apps1@cmlteam.com:~/hack.cmlteam.com/vue-test
