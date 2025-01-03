#!/bin/bash
#JUST FOR NOW I AM SETTING IT TO 5%
threshold=80
mapfile -t ULIST < <(df -Th | awk 'NR>1 {print $6+0}')
mapfile -t DLIST < <(df -Th | awk 'NR>1 {print $7}')

for i in "${!ULIST[@]}"; do
    if [[ ${ULIST[$i]} -gt $threshold ]]; then
        echo "${DLIST[$i]} utilizaton is more than ${threshold}%. Current Usage stands ${ULIST[$i]}%!!"
    fi
done
