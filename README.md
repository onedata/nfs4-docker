# nfs4-docker
NFSv4 Server in Docker with support for ACLs

# Run Server VM
~~~
docker run -d  --name nfs --privileged --net=host -v /exports:/exports -v /e1:/exports/e1 -v /e2:/exports/e2 -v /e3:/exports/e3 -v /e4:/exports/e4 -v /e5:/exports/e5 onedata/nfs4-server-acl:v1.0.3
~~~

# Mount on Client VM
~~~
# Mount e1 share
mount -v -t nfs4 -o vers=4,loud 10.87.23.13:/e1 exports/

# Mount e2 share
mount -v -t nfs4 -o vers=4,loud 10.87.23.13:/e2 exports/
~~~