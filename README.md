# mysql-s3-backup (d3fk/mysql-s3-backup)
A simple mysql client and s3cmd S3 client installed on the Alpine:latest container.

Useful with any S3 compatible object storage system to store your databases dumps.

This container has a shell for entry point so that it can be used to combine mysqldump and s3cmd commands easily.

## Docker image
pre-build from Docker hub with "automated build" option.

image name **d3fk/mysql-s3-backup**

`docker pull d3fk/https-redirect`

Docker hub repository: https://hub.docker.com/r/d3fk/mysql-s3-backup/

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
Kubectl create configmap s3config --from-file $HOME/.s3
```
It is suggested to store your database credential into a K8s secret as a good practice.
Then, once configured with your data volume/path and your bucket (by completing the file or defining the ENV variables: YOUR_KMS_KEY_ID, YOUR_BUCKET_NAME, MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD/secret, DATABASE_NAMES), the k8s CRONJOB can be created from the file:
```sh
kubectl create -f s3-dump-cronjob.yaml
```
*Nb: Enabling the versioning option of your S3 Bucket will provide you with an efficient versioned database backuping system*

### s3cmd & s3 data backups

In case you are interested in storing other data into a S3 compatible object storage you'd probably prefer to use [d3fk/s3cmd](https://hub.docker.com/r/d3fk/s3cmd) wich is also based on Alpine distrib but only contains the s3cmd tool and has s3cmd for entrypoint.

