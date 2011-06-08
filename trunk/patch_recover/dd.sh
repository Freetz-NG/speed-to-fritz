#!/bin/bash
#read kernel.image fram aice damp
dd bs=1k if=mtdblock5 of=kernel.image  skip=256 count=7808
sleep 10