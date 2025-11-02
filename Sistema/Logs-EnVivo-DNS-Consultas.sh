#!/bin/sh

logread -f | grep -E 'query\[A\]|query\[AAAA\]|cached'

