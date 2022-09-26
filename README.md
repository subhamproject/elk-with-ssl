# elk-with-ssl
This repo will have all the config to setup ELK cluster on docker with SSL/TLS/HTTPS


To start ELK cluster use script

```
bash start_elk_cluster.sh
```

This will start all the containers and would create all the certs

```
vagrant@elk:~/elk-with-ssl$ bash start_elk_cluster.sh
Deleting previous (if any)... OK!
Creating ELK CA... OK
Creating cert and key of elastic1... OK!
Creating cert and key of elastic2... OK!
Creating cert and key of elastic3... OK!
Creating cert and key of kibana... OK!
Creating cert and key of filebeat... OK!
Creating cert and key of logstash... OK!
Creating cert and key of client... OK!
SUCCEEDED
*** PLEASE WAIT THIS WILL TAKE SOMETIME TO START ALL CONTAINERS ***
Creating elastic1 ... done
Creating elastic3 ... done
Creating elastic2 ... done
Creating filebeat ... done
Creating kibana ... done
vagrant@elk:~/elk-with-ssl$
```


Once all containers are started you can access kibana on your ip

EG: -  https://10.10.100.201:5601/

![image](https://user-images.githubusercontent.com/26158459/192259513-88bfb168-a626-4c4d-b854-210504134d42.png)

To get KIBANA LOGIN - check kibana container logs and get elastic username and password

```
vagrant@elk:~/elk-with-ssl$ docker logs kibana
KIBANA CAN BE ACCESS WITH USERNAME:- elastic and PASSWORD:- 9B9ars47QuJxXdcLGzO9
vagrant@elk:~/elk-with-ssl$
```

LOGIN TO KIBANA USING ABOVE ELASTIC ID AND PASSWORD

![image](https://user-images.githubusercontent.com/26158459/192259961-3da83ae1-65d8-4634-870b-96b3a9262c26.png)

FINALLY create index

ONCE index is created you can see all the logs

![image](https://user-images.githubusercontent.com/26158459/192260215-bf9b2230-be66-4767-84f1-fb0616e2d614.png)


![image](https://user-images.githubusercontent.com/26158459/192260082-cb327525-24e9-4c3b-8dfd-2e94147d215c.png)



NOTE-   BY DEFAULT FILEBEAT HAS BEEN CONFIGRED TO PUSH CONTAINERS LOGS TO ELASTIC VIA SSL 
