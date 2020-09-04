## Setup Kubernetes Cluster with Ansible

### Requirements:
* Ansible version 2.9


### Responsibilities of this setup

* Install Kubernetes, Docker and Helm.
* Create Kubernetes Cluster

### How to use?

1. To fill the information on nodes in the "hosts" file. (If you use hetzner_terraform from this project you don't need to fill this file.)  

2. To fill the needed environment variable in the "all" file from the "group_vars" directory.  

3. Run this command. 
``` 
ansible-playbook  -i hosts playbook.yaml
```
