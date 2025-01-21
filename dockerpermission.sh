#!/bin/bash

sudo chown -R root:docker /mnt/storage/docker

sudo chmod -R 770 /mnt/storage/docker

sudo chmod g+s /mnt/storage/docker

#ls -ld /mnt/storage/docker


sudo chown -R root:docker /srv/

sudo chmod -R 770 /srv/

sudo chmod g+s /srv/

#ls -ld /docker

sudo chown -R root:docker /mnt/storage/bitcoin

sudo chmod -R 770 /mnt/storage/bitcoin

sudo chmod g+s /mnt/storage/bitcoin
