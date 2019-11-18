#!/bin/bash
mvn install -Denforcer.skip=true

FILE=./mavenassets
if test -f "$FILE"; then
    echo "$FILE exist"
else echo "$FILE no exist"
fi
