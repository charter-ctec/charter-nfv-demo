#!/usr/bin/env bash

## Push custom code into the Horizon container
## TODO - add bootstrap abilities to Horizon Chard

## assumes this runs at a location that can access to kubectl

export HORIZON=$(kubectl get pod -o name -n openstack | sed 's/pods\///' | grep horizon)

kubectl exec $HORIZON -n openstack -- curl -o /var/lib/kolla/venv/local/lib/python2.7/site-packages/horizon/templates/auth/_splash.html https://raw.githubusercontent.com/charter-ctec/horizon/stable/newton/horizon/templates/auth/_splash.html

kubectl exec $HORIZON -n openstack -- curl -o /var/www/html/horizon/dashboard/img/charter_logo.jpeg https://raw.githubusercontent.com/charter-ctec/horizon/stable/newton/openstack_dashboard/static/dashboard/img/charter_logo.jpeg