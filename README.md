[![Docker Pulls](https://badgen.net/docker/pulls/d3fk/mysql-s3-backup?icon=docker&label=pulls&cache=600)](https://hub.docker.com/r/d3fk/mysql-s3-backup/tags) [![Docker Image Size](https://badgen.net/docker/size/d3fk/mysql-s3-backup/latest?icon=docker&label=image%20size&cache=600)](https://hub.docker.com/r/d3fk/mysql-s3-backup/tags) [![Docker build](https://img.shields.io/badge/automated-automated?style=flat&logo=docker&logoColor=blue&label=build&color=green&cacheSeconds=600)](https://hub.docker.com/r/d3fk/mysql-s3-backup/tags) [![Docker Stars](https://badgen.net/docker/stars/d3fk/mysql-s3-backup?icon=docker&label=stars&color=green&cache=600)](https://hub.docker.com/r/d3fk/mysql-s3-backup) [![Github Stars](https://img.shields.io/github/stars/Angatar/mysql-s3-backup?label=stars&logo=github&color=green&style=flat&cacheSeconds=600)](https://github.com/Angatar/mysql-s3-backup) [![Github forks](https://img.shields.io/github/forks/Angatar/mysql-s3-backup?logo=github&style=flat&cacheSeconds=600)](https://github.com/Angatar/mysql-s3-backup/fork) [![Github open issues](https://img.shields.io/github/issues-raw/Angatar/mysql-s3-backup?logo=github&color=yellow&cacheSeconds=600)](https://github.com/Angatar/mysql-s3-backup/issues) [![Github closed issues](https://img.shields.io/github/issues-closed-raw/Angatar/mysql-s3-backup?logo=github&color=green&cacheSeconds=600)](https://github.com/Angatar/mysql-s3-backup/issues?q=is%3Aissue+is%3Aclosed) [![GitHub license](https://img.shields.io/github/license/Angatar/mysql-s3-backup)](https://github.com/Angatar/mysql-s3-backup/blob/master/LICENSE)


# mysql-s3-backup (Angatar> d3fk/mysql-s3-backup)
This is a Docker multi-arch image with a tiny MySQL client (~4kB installed) to create databases dumps, and s3cmd S3 client to interact with your S3 buckets, purely installed on the latest Alpine container.

Useful with **any S3 compatible** object storage system to store your databases dumps.

The MySQL client works with **any Mysql-compatible database** i.e. MySQL, MariaDB or Amazon Aurora MySQL...

This container has a shell for entry point so that it can be **used to combine mysqldump and s3cmd commands** easily.

## Docker image
[![Docker Image Size](https://badgen.net/docker/size/d3fk/mysql-s3-backup/latest?icon=docker&label=compressed%20size)](https://hub.docker.com/r/d3fk/mysql-s3-backup/tags)

Pre-build as multi-arch image from Docker hub with "automated build" option.

- image name: **d3fk/mysql-s3-backup**

`docker pull d3fk/mysql-s3-backup`

Docker hub repository: https://hub.docker.com/r/d3fk/mysql-s3-backup/

[![DockerHub Badge](https://dockeri.co/image/d3fk/mysql-s3-backup)](https://hub.docker.com/r/d3fk/mysql-s3-backup)

### Image TAGS
***"d3fk/mysql-s3-backup:latest" , "d3fk/mysql-s3-backup:stable" and "d3fk/mysql-s3-backup:stable-gpg" are all provided as multi-arch images.***

*These multi-arch images will fit most of architectures:*

- *linux/amd64*
- *linux/386*
- *linux/arm/v6*
- *linux/arm/v7*
- *linux/arm64/v8*
- *linux/ppc64le*
- *linux/s390x*


#### --- Latest ---

- **d3fk/mysql-s3-backup:latest** is available as multi-arch image build from Docker Hub nodes dedicated to automated builds. Automated builds are triggered on each change of this [image code repository](https://github.com/Angatar/mysql-s3-backup) + once per week so that using the d3fk/mysql-s3-backup:latest image ensures you to have the **latest updated (including security fixes) and functional version** available of s3cmd and mysql client in a lightweight alpine image.

#### --- Stable ---

- **d3fk/mysql-s3-backup:stable-gpg** is a multi-arch image that won't be rebuild so that it is providing you with fixed versions of the 2 clients & GPG in the Alpine linux distribution. It will probably be your choice in case you have to ensure to **avoid any possible change** in its behaviour and need client side encryption with GPG. It contains the s3cmd S3 client version 2.4.0, GPG version 2.4.7 and mysql-client package 11.4.5 in an Alpine Linux v3.21. This image had a stable behaviour observed in production, so that it was freezed in a release of the code repo and built from the Docker hub by automated build. It won't be changed or rebuilt in the future (the code is available from the "releases" section of this [image code repository on GitHub](https://github.com/Angatar/mysql-s3-backup)).

```sh
$ docker pull d3fk/mysql-s3-backup:stable
```

- **d3fk/mysql-s3-backup:stable** is a multi-arch image that won't be rebuild so that it is providing you with fixed versions of the 2 clients & the Alpine linux distribution. It will probably be your choice in case you have to ensure to **avoid any possible change** in its behaviour. It contains the s3cmd S3 client version 2.3.0 and mysql-client package 10.6.11 in an Alpine Linux v3.17. This image had a stable behaviour observed in production, so that it was freezed in a release of the code repo and built from the Docker hub by automated build. It won't be changed or rebuilt in the future (the code is available from the "releases" section of this [image code repository on GitHub](https://github.com/Angatar/mysql-s3-backup)).

```sh
$ docker pull d3fk/mysql-s3-backup:stable
```

## Basic usage

```sh
docker run --rm -v $(pwd):/s3 -v $HOME/.s3:/root d3fk/mysql-s3-backup sh -c 'mysqldump -h ${MYSQL_HOST:localhost} -u ${MYSQL_USER:root} --password=${MYSQL_PASSWORD:your_password} --databases ${DATABASES_NAMES:mysql}> "$(date +%F_%H)_mysqldump.sql" && s3cmd put --ssl  . s3://${BUCKET_NAME}'
```
The first volume is using your current directory as workdir(permit to keep a version of your dump locally or to backup a local file as well) and the second volume is used for the configuration of your S3 connection.

## s3cmd settings

It basically uses the .s3cfg configuration file. If you are already using s3cmd locally the previous docker command will use the .s3cfg file you already have at ``$HOME/.s3/.s3cfg``. In case you are not using s3cmd locally or don't want to use your local .s3cfg settings, you can use the s3cmd client to help you to generate your .s3cfg config file by using the following command.

```sh
mkdir .s3
docker run --rm -ti -v $(pwd):/s3 -v $(pwd)/.s3:/root d3fk/mysql-s3-backup s3cmd --configure
```
A blank .s3cfg file is also provided as a template in the [.s3 directory of the source repository](https://github.com/Angatar/mysql-s3-backup/tree/master/.s3), if you wish to configure it by yourself from scratch.

### s3cmd and encryption
s3cmd enables you with encryption during transfert with SSL if defined in the config file or if the option in metionned in the command line.
s3cmd also enables you with encryption at REST with server-side encryption by using the flag --server-side-encryption (e.g: you can specify the KMS key to use on the server), or client side encryption by using the flag -e or --encrypt. These options can also be defined in the .s3cfg config file.

### s3cmd complete documentation

See [here](http://s3tools.org/usage) for the documentation.


## Automatic Periodic Backups with Kubernetes

This container was created to be used within a K8s CRONJOB.
You can use the provided YAML file named s3-dump-cronjob.yaml as a template for your CRONJOB.
A configmap can easily be created from the .s3cfg config file with the following kubectl command:
```sh
kubectl create configmap s3config --from-file $HOME/.s3
```
It is suggested to store your database credential into a K8s secret as a good practice.
Then, once configured with your data volume/path and your bucket (by completing the file or defining the ENV variables: YOUR_KMS_KEY_ID, YOUR_BUCKET_NAME, MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD/secret, DATABASE_NAMES), the k8s CRONJOB can be created from the file:
```sh
kubectl create -f s3-dump-cronjob.yaml
```
*Nb: Enabling the versioning option of your S3 Bucket will provide you with an efficient versioned database backuping system*

### s3cmd & s3 data backups

In case you are interested in storing other data into a S3 compatible object storage you'd probably prefer to use [d3fk/s3cmd](https://hub.docker.com/r/d3fk/s3cmd) wich is also based on Alpine distrib but only contains the s3cmd tool and has s3cmd for entrypoint.


## License

The content of this [GitHub code repository](https://github.com/Angatar/mysql-s3-backup) is provided under **MIT** licence
[![GitHub license](https://img.shields.io/github/license/Angatar/mysql-s3-backup)](https://github.com/Angatar/s3cmd/blob/master/LICENSE). For **s3cmd** license, please see https://github.com/s3tools/s3cmd . For the MySQL client package license, please see https://pkgs.alpinelinux.org/packages?name=mysql-client .
