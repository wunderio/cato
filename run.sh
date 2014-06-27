#!/bin/bash

export HUBOT_HIPCHAT_JID="79044_810594@chat.hipchat.com"
export HUBOT_HIPCHAT_PASSWORD="attaxativatenery"
# export HUBOT_JENKINS_URL="https://wunderkraut.ci.cloudbees.com/api/json"
export HUBOT_JENKINS_URL="https://wunderkraut.ci.cloudbees.com/"
export HUBOT_JENKINS_AUTH="joe.baker@wunderkraut.com:d6bfa6773a128ae8d09e5544bdd81198"
export HUBOT_WOLFRAM_APPID="2TPVX8-E3QHJHWXHX"
export HUBOT_FORECAST_API_KEY="fd0a1bdc2a4e9a3332e407db7b8b212b"
export HUBOT_WEATHER_CELSIUS=1

bin/hubot --adapter hipchat
