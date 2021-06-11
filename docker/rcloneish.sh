#!/bin/bash
echo ${GD_TOKEN} >> /root/.config/rclone/rclone.conf
echo ${GD_DRIVE_PATH} >> /root/.config/rclone/rclone.conf
rclone $@
