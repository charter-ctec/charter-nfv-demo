#!/usr/bin/env bash

## Push custom code into the Horizon container
## TODO - add bootstrap abilities to Horizon Chart

## assumes this runs at a location that can access to kubectl

export HORIZON=$(kubectl get pods --selector application=horizon -n openstack -o name | sed 's/pods\///')

for item in ${HORIZON//\\n/ }
do
   echo "Item: $item"
   kubectl exec $item -n openstack -- curl -o /var/lib/kolla/venv/local/lib/python2.7/site-packages/horizon/templates/auth/_splash.html https://raw.githubusercontent.com/charter-ctec/horizon/stable/newton/horizon/templates/auth/_splash.html
   kubectl exec $item -n openstack -- curl -o /var/www/html/horizon/dashboard/img/charter_logo.jpeg https://raw.githubusercontent.com/charter-ctec/horizon/stable/newton/openstack_dashboard/static/dashboard/img/charter_logo.jpeg
done