# docker-hdp
HDP Cluster Deployment via Docker


# Steps

1. Build Centos7:sshd
2. Build HDP Base
3. Set environment variable for DATA_GROUP and LAUNCH_DATE
```
export DATA_GROUP=dk_01
export LAUNCH_DATE=\`date +%Y-%m-%d_%H_%M\`

```
3. Run docker-compose build
```
docker-compose build
```
4. Run docker-compose up -d
```
docker-compose up -d
```

## Initializing Ambari Server

1. Create User on MySql DB for Ambari Server.
2. Run the Ambari Server Create Scripts.
3. Launch Ambari-Server Setup.

-----

Separate out the Repo and MySql from the stack launch.

Add Label to d1.docker.local to get repo onto that server.

## Issued from the Manager Node:
`docker node update --label-add constraint=repo d1.docker.local`

## Copy repo data to d1 /data/www

## Launch Repo Service
`docker service create --hostname repo.hdp.local --network core --name hdp-repo --mount source=/data/www,target=/www,type=bind --mode replicated --replicas 1 --constraint 'node.labels.constraint == repo' --publish 80 dstreev/hdp-repo`

## If Container doesn't start, look at the nodes daemon logs.
For Centos7
`journalctl -u docker`

## Create Label for MySql
`docker node update --label-add constraint=mysql d1.docker.local`

## Create /data/mysql/data directory on d1.
#            - "${ROOT_HDP_DATA_MOUNT}/${DATA_GROUP}/mysql/datadir:/var/lib/mysql"
#            - "${ROOT_HDP_DATA_MOUNT}/mysql/init_ambari_${AMBARI_VERSION}:/docker-entrypoint-initdb.d"
`docker service create --hostname db.hdp.local --network core --name hdp-mysql --mount source=/data/mysql/data,target=/var/lib/mysql,type=bind --mode replicated --replicas 1 --constraint 'node.labels.constraint == mysql' --env MYSQL_ROOT_PASSWORD=hortonworks --publish 3306 mysql:5.7`

## 
