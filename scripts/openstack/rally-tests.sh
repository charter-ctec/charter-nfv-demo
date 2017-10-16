#!/bin/bash

# Init the log folder path
log_folder=${HOME}/.helm/test_logs

# Gather the list of releases
output=$(helm list)
# Create an array from the output
readarray -t split_output <<<"$output"
for line in "${split_output[@]}"
do
  :
  # Grab the name of the release out of the output array
  release=$(echo "$line" | awk '{print $1;}')
  # If the name is not the title of the column run a helm test on it
  if [ "$release" != "NAME" ]
  then
    echo "Rally testing $release...This may take a while..."
    result=$(helm test $release)
    # Check the return value to see if we need to copy the logs to the log directory
    if [ "$result" != "No Tests Found" ]
    then
      # Create the log directory if it doesn't exist
      if [ ! -d $log_folder ]; then
         echo "Creating log folder at $log_folder..."
         sudo mkdir -p $log_folder;
      fi
      # Handle the fact the barbican doesn't follow the typical naming convention
      if [ "$release" == "barbican" ]; then
        echo "Log created at ${log_folder}/${release}-rally-test_$(date "+%Y.%m.%d-%H.%M.%S").txt"
        kubectl logs "${release}"-test -n openstack | sudo tee "${log_folder}"/"${release}"-rally-test_"$(date "+%Y.%m.%d-%H.%M.%S")".txt
        # Delete the rally test pod after use
        echo "Deleting ${release}-test pod..."
        kubectl delete pod ${release}-test -n openstack
      else
        # Output the log to a txt file with a timestamp
        echo "Log created at ${log_folder}/${release}-rally-test_$(date "+%Y.%m.%d-%H.%M.%S").txt"
        kubectl logs "${release}"-rally-test -n openstack | sudo tee "${log_folder}"/"${release}"-rally-test_"$(date "+%Y.%m.%d-%H.%M.%S")".txt
        # Delete the rally test pod after use
        echo "Deleting ${release}-rally-test pod..."
        kubectl delete pod ${release}-rally-test -n openstack
      fi
    else
      echo "No rally tests found for $release"
    fi
  fi
done
