#!/bin/bash

HEADERS=`curl -Is --connect-timeout $1 $2`
CURLSTATUS=$?

# Check for timeout
if [ $CURLSTATUS -eq 28 ]; then
    exit 1
fi
# Check HTTP status code
HTTPSTATUS=`echo $HEADERS | grep HTTP | cut -d' ' -f2`
if [ $HTTPSTATUS -eq 200 ]; then
    exit 0
else
    exit 1
fi
