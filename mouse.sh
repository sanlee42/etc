#!/bin/bash
TRACKPATH=$(find /sys -print0 | grep -FzZ "/serio5/speed" | sed s/speed//)
[ -f $TRACKPATH/speed ] && echo -n 250 > $TRACKPATH/speed  
[ -f $TRACKPATH/sensitivity ] && echo -n 250 > $TRACKPATH/sensitivity 
exit 0
