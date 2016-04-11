# Backup script

This is a simple scripts list that can be usefull to make some backups.

# Usage

Create a "conf.sh" file in the same directory than "init.sh" and set some vars:

```bash
#!/bin/bash

# where to store backups
DEST=/root/backuptest
# list of directories to save
SOURCES="/opt/searx/ /opt/metal3d.org"
# incremental number of days
FREQ=1
# how many incremetal file to store
KEEP=8

# (optional)
# exclude file list
EXCLUDE=ignorelist.txt

# (optional)
# Only for the "full" backup
# note: GZ will be done only if TAR == true
TAR=true|false
GZ=true|false

# ACTIONS (optional)
BEFORE_FULL="string command to launch before FULL backup"
AFTER_FULL="string command to launch after FULL backup"
BEFORE_INCREMENTAL="string command to launch before INCREMENTAL backup"
AFTER_INCREMENTAL="string command to launch after INCREMENTAL backup"
```

Then, you may use:

- `bash inc.sh` to save files newer than `FREQ` days
- `bash full.sh` to save the entire directories

Note that "inc.sh" and "full.sh" include "init.sh" which removes old backups (older than `KEEP` days).

# Ignore file

Ingore file shoud be formatted for rsync. A function is "init.sh" will use it to build a "tar" complient ingorelist if you want to use "TAR" backup.

Example, to ignore ".git" and "dir1" directory, and "file.txt" file:

```
.git/
dir1/
file.txt
```

# Cron

You may use that crontab:

```cron
*  4 * * 0 bash /dir/to/full.sh
30 4 * * * bash /dir/to/inc.sh
```

It will create full backup each sunday at 4:00am and incremental backup everyday at 4:30am.

We voluntarily leave half an hour to let the beat full backup end. This is an **example** that may not be your choice.
