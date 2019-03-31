#!/bin/bash

TO=$(kubectl describe secret kubernetes-admin-root -n default | awk '$1=="token:"{print $2}')

echo -e "\ntoken: ${TO}"

kubectl config set-credentials kubernetes-admin --token="${TO}"
