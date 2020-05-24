#!/bin/sh
set -e

GITHUB_URL=https://github.com/kubecms/kubecms
GITHUB_VERSION=master

# --- helper functions for logs ---

info()
{
    echo "$@"
}

fatal()
{
    echo '[ERROR] ' "$@" >&2
}

# --- fatal if no kubectl ---
verify_system() 
{
    if [ -x "$(command -v kubectl)" ]; then
        HAS_KUBECTL=true
        return
    fi
    fatal 'Could not find kubectl to use as a provisioner of Kube CMS'
}

# --- verify existence of network downloader executable ---
verify_downloader() 
{
    # Return failure if it doesn't exist or is no executable
    [ -x "$(which $1)" ] || return 1

    # Set verified executable as our downloader program and return success
    DOWNLOADER=$1
    return 0
}

# --- if minikube present, enable ingress ---
verify_minikube() 
{
    if ! [ -x "$(command -v minikube)" ]; then
        return
    fi

    minikube addons enable ingress >/dev/null
    echo "minikube/ingress enabled"
}

# --- download zip from github url ---
download_zip() 
{
    ZIP_FILE=${GITHUB_VERSION}.zip
    ZIP_URL=${GITHUB_URL}/archive/${ZIP_FILE}

    case $DOWNLOADER in
        curl)
            curl -o ${ZIP_FILE} -sfL $ZIP_URL
            ;;
        wget)
            wget -qO ${ZIP_FILE} $ZIP_URL
            ;;
        *)
            fatal "Incorrect executable '$DOWNLOADER'"
            ;;
    esac

    # Abort if download command failed
    [ $? -eq 0 ] || fatal 'Download failed'
}

# --- extract zip ---
extract_zip() 
{
    unzip -o -qq ${ZIP_FILE}

    cleanup() 
    {
        rm ${ZIP_FILE}
        rm -rf "kubecms-${GITHUB_VERSION}"
        exit $code
    }

    trap cleanup INT EXIT
}

# --- apply namespace manifest ---
apply_namespace()
{
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/namespace.yml"
}

# --- apply persistent volume manifests ---
apply_persistentvolumes()
{
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/backoffice/persistent-volume.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/backoffice/persistent-volume-claim.yml"
}

# --- apply deployment manifests ---
apply_deployments()
{
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/backoffice/deployment.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/publisher/deployment.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/queue/deployment.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/registry/deployment.yml"
}

# --- apply service manifests ---
apply_services()
{
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/backoffice/service.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/publisher/service.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/queue/service.yml"
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/registry/service.yml"
}

# --- apply ingress manifests ---
apply_ingress()
{
    kubectl apply -f "kubecms-${GITHUB_VERSION}/deploy/backoffice/ingress.yml"
}

# --- get backoffice address ---
getting_backoffice_address()
{
    n=0
    until [ "$n" -ge 20 ]
    do
        BACKOFFICE_IP=$(kubectl get ingress kubecms-backoffice --namespace kubecms -o jsonpath='{.status.loadBalancer.ingress[*].ip}')

        if ! [ -z "$BACKOFFICE_IP" ]; then
            break
        fi

        n=$((n+1)) 
        sleep 5
    done
}

# --- verify backoffice ---
verify_backoffice()
{
    if [ -z "$BACKOFFICE_IP" ]; then
        return
    fi

    BACKOFFICE_URL="http://$BACKOFFICE_IP/"

    n=0
    until [ "$n" -ge 20 ]
    do
        BACKOFFICE_RESPONSE_CODE=$(curl --write-out %{http_code} --silent --output /dev/null $BACKOFFICE_URL)

        if [ "$BACKOFFICE_RESPONSE_CODE" = "200" ]; then
            echo "kubecms-backoffice started"
            break
        fi

        n=$((n+1)) 
        sleep 5
    done
}

# --- open backoffice url ---
open_backoffice()
{
    if [ -z "$BACKOFFICE_IP" ]; then
        return
    fi

    if [ -x "$(command -v start)" ]; then
        start $BACKOFFICE_URL
        return
    fi

    echo "kubecms-backoffice opening"
    open $BACKOFFICE_URL
}

{
    verify_system
    verify_downloader curl || verify_downloader wget || fatal 'Could not find curl or wget for downloading files'
    verify_minikube

    download_zip
    extract_zip

    apply_namespace
    apply_persistentvolumes
    apply_deployments
    apply_services
    apply_ingress

    getting_backoffice_address
    verify_backoffice
    open_backoffice
}