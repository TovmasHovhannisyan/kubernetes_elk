## Elastic stack deployment in Kubernetes

### Description
In this project, we will deploy the elastic stack in Kubernetes. We will use the Helm chart for the elastic stack. In our example, cluster will be in Hetzner Cloud. You can find the terraform files for creating necessary components in the [**hetzner-terraform**](https://github.com/TovmasHovhannisyan/kubernetes_elk/tree/master/hetzner_terrraform) directory, and project with Ansible for deploying the Kubernetes cluster in the [**kubernetes_cluster_asnible**](https://github.com/TovmasHovhannisyan/kubernetes_elk/tree/master/kubernetes_cluster_ansible) directory.

### Pre-requirements

* Kubernetes cluster(Minimum requirements - 3 worker nodes and 1 master node)
* Already installed Helm
* minimum 8 persistant volumes(Please nothe that for elasticksearch data nodes minimum storage requirepmant is 30Gi. Anyway you can change that value in `elastic-stack/charts/elasticksearch/values.yaml`)

### Steps for deploymant 
 1. Add necessary repo for the elastic stack helm chart. For that we need to execute the following commands:
 ```
  $ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
  $ helm repo update
  ```
 2. Get helm chart for elastic stack:
 ```
 $ helm fetch stable/elastic-stack
 $ tar -xzf elastic-*
 ```
 3. Change parameters in `elastic-stack/values.yaml` file as follow: 
  ```
  filebeat:
  enabled: true
  config:
    output.file.enabled: false
    output.logstash:
      hosts: ["elastic-stack-logstash:5044"]
  indexTemplateLoad:
    - elastic-stack-elasticsearch-client:9200  
  ```
 In `elastic-stack/charts/logstash/values.yaml`

   ```
  elasticsearch:
  host: elastic-stack-elasticsearch-client.default.svc.cluster.local
   ```
 4. Run the folloving command in `elastic-stack/` directory  

 ```
 $ helm install elastic-stack .
 ```
