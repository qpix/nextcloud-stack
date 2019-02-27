#!/bin/bash

PROJECT=$(basename $(pwd))
BACKUP_DIRECTORY=bckvol

# SETTING VOLUME NAMES
db=$PROJECT'_db'
letsencrypt=$PROJECT'_letsencrypt'
nextcloud=$PROJECT'_nextcloud'
nginx=$PROJECT'_nginx'

if [ $1 = 'perform' ]; then
	mkdir --parents $BACKUP_DIRECTORY
	COMMAND="tar -czf /backup/backup.tar.gz --directory /volumes/ $db $letsencrypt $nextcloud $nginx"
elif [ $1 = 'restore' ]; then
	docker volume create $db
	docker volume create $letsencrypt
	docker volume create $nextcloud
	docker volume create $nginx
	COMMAND="tar --directory /volumes/ -xf /backup/backup.tar.gz"
else
	echo "Not a valid command."
	exit 1
fi

# PERFORMING BACKUP
docker run \
	--mount source=$db,target=/volumes/$db \
	--mount source=$letsencrypt,target=/volumes/$letsencrypt \
	--mount source=$nextcloud,target=/volumes/$nextcloud \
	--mount source=$nginx,target=/volumes/$nginx \
	-v $(pwd)/$BACKUP_DIRECTORY:/backup \
	--rm ubuntu \
	$COMMAND
