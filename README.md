# Vagrant-Topology-Deployer

A few terminologies that will be used across the document:
 - host: The control machine on which ansible will be executed
 - guest: The VM's on which ansible will be applying changes/installing etc..

The help document contains instructions of how to operate and customize the provided functionalities. The scripts that you can access in the ansible project provide the following flows:
  - Preparing a temporary directory on the host machine
  - Unpacking and preparing the following scripts in the temporary directory
  -- Vagrant scripts
  -- Dyamic Inventory generation/extraction scripts
  -- Deployable application package
  - Deploys Vagrant boxes as per provided execution arguments
  - Deploys application into the VBox vm's that were spawned in the earlier step
  - Health-check to see if the application deployment was successful

# How to Execute - Pre-requisites!

Ansible provides customization of the following parameters:
  - Navigate to ansible-directory/env-local/group-vars/all.yml
  -- This file contains various parameters which can be adjusted to suit the host machine
  -- eg: APPLICATION_PORT, APPLICATION_ARCHIVE_LOCATION, VAGRANT_PACKAGE_LOCATION
  - Archive location properties would be the ones which would need custom locations if required.
  - Default archive location: '~/archives'

You can also:
  - Change the archive extension if need be, by modifying APPLICATION_GZ_ARCHIVE_NAME and VAGRANT_ARCHIVE_NAME
  - Change the default topology that is defined by modifying TOPOLOGY

> This modification of properties in the all.yml
> file is a one time operation per environment

### Ways to execute
The ansible project can be executed in two distinct ways:
  - Raw Execution (Using ansible-playbook commands)
  - Helper scripts (Using the provided shell scripts)

### Raw way of executing
Raw way of executing can be beneficial when the functionalities provided with the helper scripts are inadequate. Raw mode will also be useful for having additional control over the execution life-cycle.

##### Topology specific execution
When properties within ansible are already set:
``` sh
ansible-playbook -i env-local vagrant-deploy.yml --extra-vars "TOPOLOGY=w1h1 APPLICATION_PACKAGE_NAME=sample-1.1-SNAPSHOT"
```
When you want to override properties provided in the ansible aa.yml file during execution:
``` sh
ansible-playbook -i env-local vagrant-deploy.yml --extra-vars "TOPOLOGY=w1h1 APPLICATION_ARCHIVE_LOCATION=~/my-archives VAGRANT_PACKAGE_LOCATION=/my-archives APPLICATION_PACKAGE_NAME=sample-1.1-SNAPSHOT" -v
```

### Helper scripts for executing

The package comes with two helper scripts.
  - master-installer.sh
  - all-topologies-install-test.sh

##### master-installer
This script triggers the above raw ansible command but executes it over only one topology.
The script expects two arguments:
``` sh
./script.sh -a <application_name> -t <topology>
```
``` sh
./master-installer.sh -a sample-1.1-SNAPSHOT -t w1h1
```
The script can of-course be executed multiple times with different topology arguments
> Make the script executable on linux environment by applying
> chmod +x master-installer.sh

##### all-topologies-install-test
This triggers the ansible commands over both topologies one after the other. Hence avoiding multiple steps if both environments need to be tested out.
``` sh
./all-topologies-install-test.sh -a sample-1.1-SNAPSHOT
```
Notice that this shell executable does not take -t topology parameter anymore.

> Make the script executable on linux environment by applying
> chmod +x master-installer.sh


### Technical details (TBD)
VagrantToInventory.py is a python script which will extract the guest vm's information and will create a dynamic inventory file in a format supported by ansible.
This script can also be used in future when topologies can be infinite and not restricted.

License
----
None as provided. Owning house['Craig'] to declare.
