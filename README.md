# Infrastructure Solution

This a solution repository for the infrastructure code in HGOP-2020. It can be used as a base if there are any issues in student's solutions.

For this course student's infrastructure repositories should also include answers to questions and infrastructure or local development scripts. The folder structure should look like this (the infra code/config can also be in a folder, your choice):

```text
.
├── instances.tf
├── provider.tf
├── security_group.tf
├── .gitignore
├── ...
├── scripts
│   └── setup_local_dev_environment.sh
└── assignments
    └── day01
        └── answers.md
```

## How to setup environment
Make sure aws credentials are configured locally and the MicroK8s key pair exists.

~~~bash
terraform init
~~~

~~~bash
terraform apply
~~~

Now ssh into your instance using the MicroK8s keypair.

~~~bash
chmod 400 ~/.aws/keys/MicroK8s.pem
ssh -i "~/.aws/keys/MicroK8s.pem" ubuntu@your-ec2-instance.eu-west-1.compute.amazonaws.com
~~~

Now to setup MicroK8s in your AWS instance:

~~~bash
# Update
sudo apt update
sudo apt upgrade

# Install MicroK8s
sudo snap install microk8s --classic --channel=1.19

sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
~~~

Exit the ssh session and then ssh back in for the permission changes to take effect.

Wait for MicroK8s to be ready and then enable the ingress addon.

~~~bash
microk8s status --wait-ready

microk8s.enable ingress
~~~

Add DNS.6 to `/var/snap/microk8s/current/certs/csr.conf.template`:

~~~text
[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
DNS.6 = {{team-name}}.hgopteam.com
IP.1 = ...
IP.2 = ...
#MOREIPS
~~~

Get the kubeconfig file using:

~~~bash
microk8s config
~~~

Save the output on your local machine in `~/.kube/config` and change the
`clusters.microk8s-cluster.server` to `https://{{team-name}}.hgopteam.com:16443`, you
should share this file with other group members so they can access the cluster.

(**DO NOT** keep the kubeconfig file in your repository)

Check that you can connect to your kubernetes cluster from your local machine by doing:

It won't work until the CNAME record has been setup for you [here](https://github.com/hgop/syllabus-2020/issues/1).

~~~bash
kubectl get namespaces
~~~

You should see:

~~~
NAME              STATUS   AGE
kube-system       Active    5m
kube-public       Active    5m
kube-node-lease   Active    5m
default           Active    5m
ingress           Active    5m
~~~
