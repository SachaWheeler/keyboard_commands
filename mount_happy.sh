#!/bin/sh

#sshfs happy@happy.local:/Users/happy happy_share
sshfs -o allow_other happy@happy.local:/Volumes/moshpit /moshpit
# sshfs -o allow_other,default_permissions  happy@happy.local:/Volumes/moshpit/youtube /media/sacha/youtube

