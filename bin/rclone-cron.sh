#!/usr/bin/env bash
# Create the lock file
lockfile -r0 ${0}.lock && {
    # The actual backup part
    rclone sync -v /mnt/backup encrypted_b2:/backup/ 
}
# Release the lock file manually
rm -f ${0}.lock
