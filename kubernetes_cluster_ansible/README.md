## Setup Kubernetes Cluster with Ansible

### Requirements:
* Ansible version 2.9


### Responsibilities of this setup

* Install Kubernetes and Docker Packeges.
* Create Kubernetes Cluster

### How to use?

1. To fill the information on nodes in the "hosts" file.  

2. To fill the needed environment variable in the "all" file from the "group_vars" directory.  

3. Run this command. 
``` 
ansible-playbook  -i hosts playbook.yaml
```
