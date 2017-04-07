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

Although, the overlay network on a Docker Swarm cluster has an odd behavior that we need to work around.  For most of the components in the cluster the `-h` and `--network-alias` options were enough.  But for HBase, the reverse dns lookup would append the 'network' name on to the short hostname.  For example: Hostname -f is dk01agent01.hdp.local with the network we attached to is 'core'.  A simple ping of another host: `ping -c 1 dk01agent03.hdp.local` would show a hostname of `dk01agent03.core`.  This lead to some odd behavior in HBase.  At the time of this writing, it's still a work in progress.

I think the best solution is to align the hostnames with the projected dns entry in Docker.  So if the network is `core` and the host shortname is `dk01agent02`, then I would make the fqdn of the host `dk01agent02.core` using the `-h` and `--network-alias` options.

### Docker Swarm and Docker Compose for Cluster Provisioning

Let me mention this right away, this process looked hopeful but eventually didn't work for my needs.

At one point I used Docker Node Labels `docker node update --label-add constraint=repo d1.docker.local` on the Swarm cluster to try and control the placement of each _service_.  But I discovered through experience that I wasn't interested in a _service_, instead I need a _host_ that was unique, persisted and restartable.  _Services_ are not that.


#### Issues
* Each container deployed to the swarm cluster by `stack` through a 'compose' file was treated like a micro-service.
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
There are several pre-configured hostnames in this configuration that are required to line up all services. We'll used Docker Swarm for it's shared network characteristics.  But we will deploy components individually to ensure persisted states across restarts.

- A Docker Swarm
    - A 7 Node cluster for this configuration
    - A 'core' network that all hosts attach to. This network is created in [`./up.sh`](./up.sh) and [`./infra-up.sh`](./infra-up.sh)
- Using the [Infra Script](./infra-up.sh) to deploy:
    - MySql Instance (db.hdp.local)
    - HTTP Instance for the Repo (repo.hdp.local)
- Environment variables specified in [`./init.sh`](./init.sh)
    - Each cluster is assigned a unique _prefix_ and _number_ that identify and set:
        - hostnames
        - databases
        - local persisted directories (/data/...)
    - Override the [init.sh](./init.sh) settings for new cluster.

# Dependency
This tutorial by example uses my custom built images for docker, source found [here](https://github.com/dstreev/docker-hortonworks).  Images are designed to build out a combination of an "Ambari-Server", "Ambari-Agent" and/or "Nifi Instance".

Controlling which one of these is build when the container is started is controlled by the _environment variables_:
- `AMBARI_SERVER`
- `AMBARI_AGENT`
- `NIFI_SERVER`

Version information is controlled by in the `init.sh` and can be overridden. This process has been setup to expect a _local repo_ at `http://repo.hdp.local`.  See the image source for this repo [here](https://github.com/dstreev/docker-hortonworks/tree/master/hdp-repo) and the instantiation of that repo in [infra-up.sh](./infra-up.sh)

With the correct flags and versions set, the supervisord process in the images will download, install and configure each of the desired services.

The Ambari Server should always be setup on the first host because all Ambari-Agent will be configured to manually register with that host on startup.

# Setting up the First Cluster

## Docker
- Stop and Disable `firewalld`
- Install Docker
    - My Version:
    ```
    Server:
     Version:      1.13.1
     API version:  1.26 (minimum version 1.12)
     Go version:   go1.7.5
     Git commit:   092cba3
     Built:        Wed Feb  8 06:38:28 2017
     OS/Arch:      linux/amd64
     Experimental: true
    ```
    - Configured Experimental Mode:
        - Create a File /etc/docker/daemon.json
        ```
        {
            "experimental": true
        }
        ```
    - Configure Docker Sockets.  I use this to be able to connect and issue commands to a Docker host from a remote location.
        - Create a File `/etc/systemd/system/docker.service.d/docker.conf` on each Docker Host with contents:
        ```
        [Service]
        ExecStart=
        ExecStart=/usr/bin/dockerd -D -H tcp://0.0.0.0:2375
        ```
        - The first `ExecStart=` command is necessary...
        - The second tells the docker engine started by `systemctl` to startup with sockets listening on all interfaces on port 2375
        - This requires communicating with docker requires the `-H <host:port>` option for all commands, even locally: IE: `docker -H localhost:2375 ps`

## Docker Swarm
- Initialize the [Docker Swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/) so the nodes are all participating
    - Pick a Swarm Manager and initialize the Swarm: `docker -H <manager_host:port> swarm init --advertise-addr <MANAGER-IP>`
    - Validate Swarm Mode: `docker -H <manager_host:port> info`
    ```
    ...
    Swarm: active
     NodeID: 1bh9a6mgjzv73tbim22cmfuny
     Is Manager: true
     ClusterID: ihr97kxhekk941xm1rpp2qob2
     Managers: 1
     Nodes: 7
    ...
    ```
    - Check the Nodes: `docker -H <manager_host:port> node ls`
    ```
    ID                           HOSTNAME         STATUS  AVAILABILITY  MANAGER STATUS
    1bh9a6mgjzv73tbim22cmfuny *  d7.docker.local  Ready   Active        Leader

    ```
- Add Nodes to the Swarm
    - Get the Join Command from the Swarm Manager
    ```
    > docker -H <manager_host:port> swarm join-token worker

    To add a worker to this swarm, run the following command:
    
        docker swarm join \
        --token SWMTKN-1-3nzgki6if3wyx7e1ptlhnj8bald6aqwq10pmk4is0n158yzp2c-0m8c0i7zo3w5luc8qp2pyznu8 \
        10.0.1.17:2377

    ```
    - Run the above command on each host (don't forget the `-H` option)
    - Validate Hosts have joined the Swarm `docker -H <manager_host:port> node ls`
    ```
    ID                           HOSTNAME         STATUS  AVAILABILITY  MANAGER STATUS
    1bh9a6mgjzv73tbim22cmfuny *  d7.docker.local  Ready   Active        Leader
    5tj4qajz3vj0ujnwja23qg49b    d6.docker.local  Ready   Active
    bzu7ej07w6tu2o6ny17kwyn59    d2.docker.local  Ready   Active
    cjsmqaj38r4pcvwac1jekm241    d5.docker.local  Ready   Active
    i31e1z7j8zwjzra2t53iayu1u    d1.docker.local  Ready   Active
    kc9w6cgr124p6fj1coy4apnaw    d3.docker.local  Ready   Active
    wwq0i59fjx1nxukhbmlofbcgz    d4.docker.local  Ready   Active
    ```

- Create the Cluster Network on the Swarm Cluster
    `docker -H <manager_host:port> network create --driver=overlay --subnet 10.0.10.0/24 --attachable core`
    - The `core` network is used by all the other scripts in this tutorial.

## Drive Mounts
The images used in this tutorial have a few mount points that will allow us to persist cluster data separately from the containers.  Which is important if you want to be able to reset you clusters without loosing a lot of your data.

Create a base directory on each docker host to store 'off container' data, `/var/local/hdp/`.  Settings in `init.sh` specific a cluster prefix `CLUSTER_PREFIX` and `AMBARI_INSTANCE`.  These values are translated down into the containers to establish unique drive locations so I can support multiple clusters.

## Cluster Databases
With the 'mysql' database running from the `infra-up.sh` the databases should have been created for:
- Ambari
- Hive
- Oozie
- Ranger
- KMS
- Druid

Open Issue: [Init DB Scripts Not Working](https://github.com/dstreev/docker-hortonworks/issues/1)

Base on the `AMBARI_INSTANCE` environment variable used, databases for each of these components are created.  Based on the scripts, I have defaulted all user passwords to `hortonworks`.

### Databases
Assumes `AMBARI_INSTANCE=01`

| Database | User |
|---| --- |
| ambari_01 | ambari |
| hive_01 | hive |
| oozie_01 | oozie |
| ranger_01 | ranger |
| ranger_kms_01 | ranger_kms |
| druid_01 | druid |
| superset_01 | superset |

## Initialize HDP Cluster
Run [up.sh](./up.sh) with default parameters.  Based on the tables above, with 7 docker hosts, it will initialize your base HDP cluster with the specified Ambari Version.

Run [ps.sh](./ps.sh) to understand all the dynamic port mappings.  Review the ssh port mapping for the Ambari-Server (on d6 in this example).  Create an SSH tunnel to support a dynamic SOCKS proxy to this host.  Configure your browser to use the SOCKS5 proxy and then launch your Ambari UI from `http://dk01agent01.hdp.local`, assuming you have used all the same settings I have ;).

Now you can build out you cluster with Ambari using the `local repo` you setup before.  The local repo will save you time and internet bandwidth when deploying all the HDP binaries.



