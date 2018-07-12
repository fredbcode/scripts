 docker build –no-cache -t paquetsubuntu . && docker run -it –rm –name e2guardianubuntu -d -p 8080:8080 -v /tmp:/tmp paquetsubuntu

docker exec -it e2guardianubuntu bash 

INSIDE:

cp e2guardian-5.X/scripts/debian_package/e2guardian_ubuntu_version_package.deb /tmp/


