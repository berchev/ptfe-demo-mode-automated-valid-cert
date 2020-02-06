#!/usr/bin/env bash

# Debug mode - uncomment in order to turn it on
# set -x

########################
# Variables definition #
########################

# Snapshots path
path="/var/lib/replicated/snapshots"

# PTFE online stable bundle
ptfe_url="https://install.terraform.io/ptfe/stable"

#######################
# Function definition #
#######################

# The function is measuring the time needed to complete the task PTFE Installation/Restore
Time_Measure_Func () {
    STARTED_AT=${SECONDS}
        until curl -f -s --connect-timeout 1 http://localhost/_health_check; do
            sleep 1
            echo "Initializing... please wait!"
        done
    FINISHED_AT=$((${SECONDS} - ${STARTED_AT}))
    echo "$((${FINISHED_AT} / 60)) minutes and $((${FINISHED_AT} % 60)) seconds"
}

#####################
# Main script start #
#####################

# Check whether we have any snapshots, if "true" => perform restore from snapshot, "else" => perform brand new PTFE instalation
if [ -d ${path} ]
then 
    # Configure replicated
    curl ${ptfe_url} | bash -s fast-timeouts private-address=${ip_address} no-proxy public-address=${ip_address}

    # This retrieves a list of all the snapshots currently available.
    replicatedctl snapshot ls --store local --path ${path} -o json > /tmp/snapshots.json

    # Pull just the snapshot id out of the list of snapshots
    id=$(jq -r 'sort_by(.finished) | .[-1].id // ""' /tmp/snapshots.json)

    # Perform restore from latest snapshot
    replicatedctl snapshot restore $access --dismiss-preflight-checks "$id"
    sleep 5
    # Without restarting replicated and then starting the app, PTFE instance didn't start
    service replicated restart
    service replicated-ui restart
    service replicated-operator restart
    sleep 60
    replicated app $(replicated apps list | grep "Terraform Enterprise" | awk {'print $1'}) start

    # Just a timer, I want to measure the amount of time needed for the snapshot restore
    Time_Measure_Func 
    echo "were required to complete the PTFE Restore from snapshot"
else
    # Perform brand new instalation of PTFE
    cp /vagrant/conf/replicated.conf /etc/replicated.conf
    curl -sSL ${ptfe_url} | sudo bash -s fast-timeouts private-address=${ip_address} no-proxy public-address=${ip_address}

    # Just a timer, I want to measure the amount of time needed for the instalation
    Time_Measure_Func 
    echo "were required to complete the PTFE Installation"
fi