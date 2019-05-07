#!/bin/bash

while ! hamachi login >/dev/null; do
    echo "Waiting for hamachid..."
    sleep 5
done

hamachi attach $ACCOUNT
