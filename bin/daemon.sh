#!/bin/sh

NAME=hubot
USER=hubot
DESC="hubot"
USER_HOME="/opt/$USER"
HUBOT_ROOT="$USER_HOME/hubot"
HUBOT_HOME="$HUBOT_ROOT/node_modules/hubot"
DAEMON="$HUBOT_HOME/bin/hubot"
#DAEMONOPTS="--adapter hipchat"
DAEMONOPTS='"$@"'
PIDFILE=$HUBOT_ROOT/hubot.pid

case "$1" in
start)
        printf "%-50s" "Starting $DESC..."
        . $HUBOT_ROOT/bin/.hubotrc
        PID=`$DAEMON $DAEMONOPTS > /var/log/hubot 2>&1 & echo $!`
        if [ -z $PID ]; then
            printf "%s\n" "Fail"
        else
            echo $PID > $PIDFILE
            printf "%s\n" "Ok"
        fi
        ;;
status)
        printf "%-50s" "Checking $DESC..."
        if [ -f $PIDFILE ]; then
            PID=`cat $PIDFILE`
            if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
                printf "%s\n" "Process dead but pidfile exists"
            else
                echo "Running"
            fi
        else
            printf "%s\n" "Service not running"
        fi
        ;;
stop)
        printf "%-50s" "Stopping $DESC"
            PID=`cat $PIDFILE`
        if [ -f $PIDFILE ]; then
            kill $PID
            printf "%s\n" "Ok"
            rm -f $PIDFILE
        else
            printf "%s\n" "pidfile not found"
        fi
        ;;
restart)
        $0 stop
        $0 start
        ;;


    *)
        echo "Usage: $0 {status|start|stop|restart}" >&2
        exit 1
        ;;
    esac
    exit
