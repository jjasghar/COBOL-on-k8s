# KOBOLD - Kubernetes cOBOL Demo

> Kobolds (pronounced "KOH-bawld")[4] are a race of diminutive, rat-like subterranean humanoids who dwell in and around caverns and mines throughout the Eastern Kingdoms, Kalimdor and the Broken Isles. They are not particularly intelligent and are notoriously cowardly, preferring to keep their distance from other, larger races. Kobolds are famous for being obsessively protective of the candles they wear upon their heads and which help them light their way through the dark tunnels they call home. - [https://wow.gamepedia.com/Kobold](https://wow.gamepedia.com/Kobold)

## Scope

This repository shows off a simple [ETL pipeline](https://databricks.com/glossary/etl-pipeline) using
COBOL and Kubernetes.

There are two main portions to this repository. The [docker-containers](./docker-containers) holds the
configuration and repeatable builds of the different containers of the ETL pipeline. The [k8s](./k8s)
directory has the `.yaml` files to deploy the said containers to a Kubernetes cluster on [IBM Cloud](https://cloud.ibm.com).

The demo COBOL applicaiton is located [here](./plus5numbers.cbl). It is a simple COBOL application
that takes in a file called `numbers.txt` (an [example](./numbers.txt.example) here) and outputs a
file called `newNumbers.txt` with every number rewritten 5 added to it. If you take a look at the
diagram below you see the pipeline illustrated.

![](./img/k8s-cobol.png)

## Demoing it Yourself

### Pre-Requisites

- An s3 bucket like Cloud Object Storage on IBM Cloud
- `s3fs` installed on the machine to upload a `numbers.txt`
- `docker` if you want to build the containers
- A Kubernetes cluster like the Kubernetes Service on IBM Cloud
- Edit the `local.env.example` and save it as `local.env` for the needed `exports`

### Object storage

Create a an object storage instance, for instance `asgharlabs-cobol`. Then created a bucket, for instance `asgharlabs-cobol-in` that you can put a file into it. Set it to `Public` access also, so you can download from it directly.

Steps make the bucket public: [example](https://s3.sjc04.cloud-object-storage.appdomain.cloud/asgharlabs-in/numbers.txt)

- Choose the bucket that you want to be publicly accessible. Keep in mind this policy makes all objects in a bucket available to download for anyone with the appropriate URL.
- Select Access policies from the navigation menu.
- Select the Public access tab.
- Click Create access policy. After you read the warning, choose Enable.
- Now all objects in this bucket are publicly accessible!

To create a Service account:
- Log in to the IBM Cloud console and navigate to your instance of Object Storage.
- In the side navigation, click Service Credentials.
- Click New credential and provide the necessary information. If you want to generate HMAC credentials, click 'Include HMAC Credential' check box
- Click Add to generate service credential.

Expanded the `View Credentials` and found the `access_key_id` and `secret_access_key` and put them
in a file with `access_key_id:secret_access_key` format.

Example of using `s3fs` to mount the local directory.

```bash
s3fs asgharlabs-in s3/ -o url=https://s3.sjc04.cloud-object-storage.appdomain.cloud -o passwd_file=key.key
```

### Steps to Run the Pre Bulit Demo

Assuming you have built and deployed the containers to something like Docker Hub, you can to the following steps to get just run the demo.

- Go into the `k8s/` directory on the local machine
- Run `kubectl apply -f deployment.yaml` to set up the kubernetes cluster, you should see something like the following:
- When that is done, you will have your pods on the Kubernetes cluster.
```console
$ > kubectl get pods
NAME                             READY   STATUS     RESTARTS   AGE
cobol-process-6f546948c8-pc99r   0/3     Init:0/1   0          8s
```
then
```console
NAME                             READY   STATUS        RESTARTS   AGE
cobol-process-7b57896fc7-qp7fb   3/3     Running       0          23s
```
- Copy a `numbers.txt` into the `s3/` directory, and in the `watcher-in` terminal you should see
the `wget` and file move.
- Look at the `cobol-process` container and you should see the output of the file and new file.
- Finally look at the `watcher-out` container and you should see the new file outputed. Something like the following:
```console
$ > kubectl logs cobol-process-7b57896fc7-qp7fb -c watcher-out
Waiting on newNumbers.txt to appear...
Waiting on newNumbers.txt to appear...
#
#
These are the new numbers, you can ship this wherever you need...
#
#
00028
00012
00049
00057
00017
01342
#
#
#
#
#
```

## Building the Docker image:

```bash
REPOSITORY=<your docker hub login>
TAG=latest
$ docker build -t $REPOSITORY/cobol-batch:$TAG .
```

## License & Authors

If you would like to see the detailed LICENCE click [here](./LICENCE).

- Author: JJ Asghar <awesome@ibm.com>
- Contributor: Paul Czarkowski <username.taken@gmail.com>

```text
Copyright:: 2019- IBM, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
