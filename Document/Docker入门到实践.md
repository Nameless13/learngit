title: Docker入门到实践
categories: 
- document
date: 2017-07-08
---
#Docker--入门到实践
Virtuial Machines
each virtualized application includes not nonly the application - which may be only 10s of MB -and the necessary binaries,but also an entire guest operating system - which may weigh 10s of GB

---
Docker
The Docker Engine container comprises just the application and its dependencies. it runs aas an isolated process in userspace on the host operating system,sharing the kernel with other containers. Thus,it enjoys the resource and allocation benefits of VMs but is much more portable and efficient.

---
容器除了运行其中的应用外,基本不消耗额外的系统资源,使得应用性能很高,同事系统的开销尽量小,相比传统虚拟机方式运行10个不同的应用要起10个虚拟机,而Docker只需要启动10个隔离应用即可.

|特性|容器|虚拟机|
| :- | :- |:- |
|启动|秒级|分钟级|
|硬盘使用|一般为MB|一般为GB|
|性能|接近原生|弱于|
|系统支持量|单机支持上千个容器|一般几十个|

---
##基本概念
- 镜像(Image)

Docker镜像就是一个只读的模版,如可以包含一个完整的操作系统里面仅安装了Apache
镜像可以用来创建Docker容器
Docker提供了一个很简单的机制来创建镜像或者更新现有镜像,或者拿一个做好的镜像直接使用

---
- 容器(Container)

Docker利用容器俩运行运用
容器是从镜像创建的运行实例.可以被启动,开始停止,删除.每个容器容器都是相互隔离的,保证安全的平台
可以把容器看作是一个简易版的Linux环境 (包括root用户权限,进程空间,用户空间和网络空间等)和运行在其中的应用程序

// 镜像是只读的,容器在启动的时候创建一层`可写层`作为最上层


---
- 仓库(Repository)

仓库是几种存放镜像文件的场所.仓库注册服务器上往往存放多个仓库,每个仓库中又包含多个镜像,每个镜像有不同的标签(tag)

仓库分为公开仓库(Public)和私有仓库(Private)

最大的公开仓库是Docker Hub,国内公开仓库有Docker Pool

用户可以本地网络内创建一个私有仓库,当创建了自己的镜像后可使用`push`命令上传到仓库,命令`pull`从仓库下载

---
##CentOS 系列安装Docker

`docker pull hub.c.163.com/public/<centos:7 class="0"></centos:7>`

`docker run -t -i hub.c.163.com/public/centos:7.0 /bin/bash`
-t  选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上，  -i  则让容器的标准输入保持打开

`docker run -t -i training/sinatra /bin/bash`  //会下载一个新的...镜像

当利用`docker run` 创建容器时,Docker在后台运行的标准是:
- 检查本地是否存在指定的镜像,不存在就从公有仓库下载
- 利用镜像创建并启动一个容器
- 分配一个文件系统,并在只读的镜像层外面挂载一层可读写成
- 从宿主主机配置的网桥接口中桥接一个虚拟接口道容器中去
- 从地址池配置一个IP地址给容器
- 执行用户指定的应用程序


`docker commit -m "Added git" -a "Docker Newbee" 40c9fe0a35ef centos:v2`




---

`docker run -t -i hub.c.163.com/public/centos:7.0 /bin/bash`
`-t 让Docker分配一个伪终端(pseudo-tty)并绑定到容器的标准输入上,-i 让容器的标准输入保持打开`

当利用docker run 创建容器时,Docker在后台运行的标准操作包括:
- 检查本地是否存在指定的镜像,不存在就从公有仓库下载
- 利用镜像创建并启动一个容器
- 分配一个文件系统,并在只读的镜像层外面挂载一层可读写层
- 从宿主主机配置的网桥接口中桥接一个虚拟接口道容器中去
- 从地址池配置一个ip地址给容器
- 执行用户指定的应用程序
- 执行完毕后容器被终止

####启动已终止容器
利用 `docker start` ,直接将一个已经终止的容器启动运行
容器的核心为所执行的应用程序,所需要的资源都是应用程序运行必需的.

####后台background运行
需要让docker在后台运行

---
安装 `.bashrc_docker

```bash
wget -P ~ https://github.com/yeasy/docker_practice/raw/master/_local/.bashrc_docker
echo "[ -f ~/.bashrc_docker ] && . ~/.bashrc_docker" >> ~/.bashrc; source ~/.bashrc

echo $(docker-pid docker)
```




----
##redis-master
`docker run --name redis-master -v /home/testuser/docker/master-redis.conf:/usr/local/etc/master-redis.conf -d -p 16397:16379 redis redis-server /usr/local/etc/master-redis.conf`

##redis-slave
`docker run --link redis-master:redis-master -v /home/testuser/docker/slave-redis.conf:/usr/local/etc/slave-redis.conf --name redis-slave1 -d redis redis-server /usr/local/etc/slave-redis.conf`


####宿主机上如何获得 docker container 容器的 ip 地址？
```
docker inspect --format='{{.NetworkSettings.IPAddress}}' $CONTAINER_ID
```

###在Docker容器内外互相拷贝数据

####从容器内拷贝文件到主机上
`docker cp <containerId>:/file/path/within/container /host/path/target`

没试验过


####从主机上拷贝文件到容器内
1. 用-v挂载主机数据卷到容器内
`docker run -v /path/to/hostdir:/mnt $container`
在容器内拷贝  
`cp /mnt/sourcefile /path/to/destfile`

2. 直接在主机上拷贝到容器物理存储系统
    1. 获取容器名称或者id : `docker ps  `
    2. 获取整个容器的id: 
    ```bash
    docker inspect -f   '{{.Id}}'  [获取的名称或者id]  
    ```
    3. 在主机上拷贝文件: ` cp path-file-host /var/lib/docker/devicemapper/mnt/[获取的名称或者id]/rootfs/root `


```bash   

    1.
    [testuser@CentOS1 docker]$docker ps
    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                NAMES
    01a349ea86bd        redis               "docker-entrypoint.s   42 minutes ago      Up 42 minutes       6379/tcp                             redis-slave3        
    bd45650a61f6        redis               "docker-entrypoint.s   43 minutes ago      Up 43 minutes       6379/tcp                             redis-slave2        
    ce2321f0d4d5        redis               "docker-entrypoint.s   46 minutes ago      Up 46 minutes       6379/tcp                             redis-slave1        
    9408dd71f9e9        redis               "docker-entrypoint.s   54 minutes ago      Up 54 minutes       6379/tcp, 0.0.0.0:16397->16379/tcp   redis-master 
    

    2. 
    [testuser@CentOS1 docker]$ docker inspect -f '{{.Id}}' 9408dd71f9e9
    9408dd71f9e943b6ed08dd146e20700439eef280db7ce914852452340bfbfbbe
    

    3.
    [root@CentOS1 ~]#cp sentinel.conf /var/lib/docker/devicemapper/mnt/9408dd71f9e943b6ed08dd146e20700439eef280db7ce914852452340bfbfbbe/rootfs/root/
```

####退出容器而不停止容器
组合键：Ctrl+P+Q

