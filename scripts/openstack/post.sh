#!/bin/bash

set -x

echo "required admin actions post upgrade"

POSTACTION_POD=$(kubectl get -n openstack pods -l application=keystone,component=api --no-headers -o name | awk -F '/' '{ print $NF; exit }')
KS_USER="charter_admin"
KS_PROJECT="ctec"
KS_PASSWORD="password"
KS_USER_DOMAIN="default"
KS_PROJECT_DOMAIN="default"
KS_URL="http://keystone.openstack/v3"

KEYSTONE_CREDS="--os-username ${KS_USER} \
  --os-project-name ${KS_PROJECT} \
  --os-auth-url ${KS_URL} \
  --os-project-domain-name ${KS_PROJECT_DOMAIN} \
  --os-user-domain-name ${KS_USER_DOMAIN} \
  --os-password ${KS_PASSWORD}"

kubectl exec -n openstack ${POSTACTION_POD} -- keystone-manage pki_setup --keystone-user keystone --keystone-group ""

POSTACTION_POD=$(kubectl get -n openstack pods -l application=nova,component=os-api --no-headers -o name | awk -F '/' '{ print $NF; exit }')

kubectl exec -n openstack ${POSTACTION_POD} -- nova-manage cell_v2 discover_hosts

sudo chown -R 42436:42436 /var/lib/nova/
for node in $(cat $HOME/charter-nfv-demo/bootkube-ci/deploy-node/nodes); do
  ssh -tq ${node} "sudo chown -R 42436:42436 /var/lib/nova";
done
