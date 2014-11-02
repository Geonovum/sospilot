#!/bin/bash

WEEWX_HOME=/opt/weewx/weewxinst
WEEWX_DB="$WEEWX_HOME/archive/weewx.sdb"
BCK_DIR="$WEEWX_HOME/backup/"
REMOTE_DIR=sadmin@sensors:weewx-backup/

# daily backup
WEEK_DAY=`date +%w`
MONTH_DAY=`date +%d`
MONTH=`date +%m`

BCK_DAY="$BCK_DIR/weewx-${WEEK_DAY}.sdb"
BCK_MONTH="$BCK_DIR/weewx-month${MONTH}.sdb"
BCK_LOG="$WEEWX_HOME/backup/backup-day-${WEEK_DAY}.log"

# each day to dayfile
cp $WEEWX_DB  $BCK_DAY

# archive once a month
if [ ${MONTH_DAY} = 06 ]
then
   echo "Copy to archive" >> $BCK_LOG
   cp $WEEWX_DB  $BCK_MONTH
else
  echo "Skip monthly backup" >> $BCK_LOG
fi

# Always rsync
echo "RSYNC data to ${REMOTE_DIR}" >> ${BCK_LOG}
rsync -e ssh -alzvx ${BCK_DIR} ${REMOTE_DIR}  > $WEEWX_HOME/last-backup.log 2>&1
cat $WEEWX_HOME/last-backup.log >> ${BCK_LOG}
echo "RSYNC data to ${REMOTE_DIR} DONE" >> ${BCK_LOG}

exit 0;
