# Kube CMS

Kube CMS is a Content Management System that is designed to run within a multi-node Kubernetes cluster.

![](images/kube-cms-preview.png)

# Installation

The Kube CMS `install.sh` script is a quick way to install Kube CMS onto your Kuberneters cluster. Using your current context, the script will create a new namespace and all the resources type it requires:

```bash
curl -sfL http://get.kubecms.com | sh -
```

To verify what namespace, services, deployments, pods, replica sets and ingress the install script creates, run the following command:

```bash
kubectl get all,ingress --namespace kubecms
```

# Status

[![backoffice](https://github.com/kubecms/kubecms/workflows/backoffice/badge.svg)](https://github.com/kubecms/kubecms/actions?query=workflow%backoffice)
[![data](https://github.com/kubecms/kubecms/workflows/data/badge.svg)](https://github.com/kubecms/kubecms/actions?query=workflow%data)
[![publisher](https://github.com/kubecms/kubecms/workflows/publisher/badge.svg)](https://github.com/kubecms/kubecms/actions?query=workflow%publisher)
[![registry](https://github.com/kubecms/kubecms/workflows/registry/badge.svg)](https://github.com/kubecms/kubecms/actions?query=workflow%registry)