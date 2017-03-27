# Building an HDP Cluster on Docker

## Requirements:
* Support Multiple hosts
    * I want to be able to build an HDP cluster that spans multiple host OSes.
* Be able to "Stop" and "Start" or "Restart" the Docker Containers used to build the cluster, without destroying the cluster.
* Support an external Metastore as a Repo for Ambari, Hive, Oozie, etc.
* Build Multiple HDP Clusters on the same hardware.
    * The cluster "could" be run together or "individually", depending on the resources available from the hardware.

## Challenges:

Docker networking was the biggest hurdle.  Because I needed to span multiple Docker hosts environments, I needed a networking solution that would provide visibility across these separate Host OSes.  Default Docker behavior assigns a random Hostname to containers when they start.  This Hostname isn't always maintained across restarts in the Docker cluster. Since I want to use Ambari to provision the cluster and it maintains a reference to the hostname, dynamic/changing hostnames on restart presented a problem.

I used [Docker Swarm](https://docs.docker.com/engine/swarm/) to build a cross host Docker cluster that shared configurations and networks.  The typical deployment process for Swarm is to build a [Docker Compose Definition](https://docs.docker.com/compose/) to provision my nodes.

### Docker Swarm and Docker Compose for Cluster Provisioning

Let me mention this right away, this process looked hopeful but eventually didn't work for my needs.  I've kept the [compose file](./docker-compose.yml) in the project as a reference.

At one point I used Docker Node Labels `docker node update --label-add constraint=repo d1.docker.local` on the Swarm cluster to try and control the placement of each _service_.  But I discovered through experience the I wasn't interested in a _service_, instead I need a _host_ that unique, persisted and restartable.  _Services_ are not that.


#### Issues
* Each container in this setup is treated like a micro-service.
* State between restarts was impossible.  This included hostname information, physical location of the container
* Managing containers own view of it's hostname was NOT possible.  So, through experimentation, I actually used an "ambari-agent" host script to project a consistent name to Ambari-Server.  This worked fine UNTIL I tried to start HDFS.  Reverse DNS lookup of a host to itself isn't supported.


## My Cluster(s) Configuration

With my hardware, I'm able to setup a 7 node cluster at a time.  I follow a 3 Master, 4 Workers, 1 Nifi deployment configuration.  Depending on extra services I deploy, that arrangement could change.  And I'm not restricted to this number of host in my clusters.  That can also be adjusted with scripts the differ from the [default up script](./up.sh).

### Physical Hardware
| Host | CPU | Memory | Drive(s) |
|---|---|---|---|
| d1.docker.local | i5 Dual Core | 16Gb | 500Gb eSata |
| d2.docker.local | i5 Dual Core | 16Gb | 500Gb eSata |
| d3.docker.local | i5 Dual Core | 16Gb | 500Gb eSata |
| d4.docker.local | i5 Dual Core | 16Gb | 500Gb eSata |
| d5.docker.local | i5 Dual Core | 16Gb | 500Gb eSata |
| d6.docker.local | i5 Dual Core | 16Gb | 125Gb eSata |
| d7.docker.local | i5 Dual Core | 16Gb | 125Gb eSata |

### Host Organization Pattern
| Role | Docker Host | Container Hostname | Infrastructure |
|---|---|---|---|
| MySql (MariaDb) | d1.docker.local | db.hdp.local | Yes |
| Local Yum Repo | d1.docker.local | repo.hdp.local | Yes |
| Master Server | d6-7,3.docker.local | <cluster_prefix><cluster_number>agent<agent_number>.hdp.local<br/>IE: dk01agent01.hdp.local | No |
| Worker Nodes | d4-6,1.docker.local | <cluster_prefix><cluster_number>agent<agent_number>.hdp.local<br/>IE: dk01agent01.hdp.local | No |
| Nifi Server | d2.docker.local | <cluster_prefix><cluster_number>agent<agent_number>.hdp.local<br/>IE: dk01agent07.hdp.local | No |

### Host Name Pattern
| Agent | Role | Hostname(Example) | Docker Host |
|---|---|---|---|
| 01 | Master | dk01agent01 | d6.docker.local |
| 02 | Master | dk01agent02 | d7.docker.local |
| 03 | Master | dk01agent03 | d3.docker.local |
| 04 | Worker | dk01agent04 | d4.docker.local |
| 05 | Worker | dk01agent05 | d5.docker.local |
| 06 | Worker | dk01agent06 | d1.docker.local |
| 07 | Nifi | dk01agent07 | d2.docker.local |


# Requirements and PreRequisites
There are several pre-configured hostnames in this configuration that are required to line all services up. We'll used Docker Swarm for it's shared network characteristics.  But we will deploy components individually to ensure persisted states across restarts.

- A Docker Swarm
    - A 7 Node cluster for this configuration
    - A 'core' network that all hosts attach to. This network is created in [`./up.sh`](./up.sh) and [`./infra-up.sh`](./infra-up.sh)
- Using the [Infra Structure Compose File](./infra-docker-compose.yml) deploy:
    - MySql Instance (db.hdp.local)
    - HTTP Instance for the Repo (repo.hdp.local)
- Environment variables specified in [`./init.sh`](./init.sh)


   ---

HDP Cluster Deployment via Docker

With this dep

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
