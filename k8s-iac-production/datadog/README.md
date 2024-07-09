# Guia do que foi feito para subir o datadog operator no cluster #

## Pré-requisitos ##

* Cliente Helm configurado
* Cliente kubectl configurado

## Acesso ##

* Necessário gerar um api-key na interface do datadog:  
    `https://app.datadoghq.com/organization-settings/api-keys`
* Necessário gerar um app-key na interface do datadog. Nesse caso com o nome de eks-homolog:  
    `https://app.datadoghq.com/organization-settings/application-keys`

## Deploy ##

* Adicionar o repositorio helm do datadog:
    ```
    helm repo add datadog https://helm.datadoghq.com
    ```
* Instalar o datadog operator em um novo namespace, datadog:
    ```
    helm install datadog-operator datadog/datadog-operator --namespace datadog --create-namespace
    ```
* Criar um secret no cluster k8s com as info de api e app do datadog:
    ```
    kubectl create secret generic datadog-secret --from-literal api-key=<DATADOG_API_KEY> --from-literal app-key=<DATADOG_APP_KEY> -n datadog
    ```
* Criar um manifest para o datadog agent ( datadog-agent.yaml):
    ```
    kubectl apply -f datadog-agent.yaml
    ```

## Customizações ##

* Para checar os atuais valores do release datadog-operator deployed no cluster:  
    ```
    helm get values -n datadog datadog-operator
    ```

* Para modificar os valores do datadog-operator:
    ```
    helm upgrade -f values.yaml datadog-operator datadog/datadog-operator -n datadog
    ```
    Os valores atuais estão no arquivo values.yaml. Sempre usá-lo para mudar o deployment do datadog.

* Para modificar os valores dos Agentes ( arquivo datadog-agent.yaml):
    ```
    kubectl apply -f datadog-agent.yaml
    ```

    ### Habilitar APM nos Pods e enviar traces ###
    * Modificar no arquivo datadog-agent.yaml os blocos, APM e Admission Controler:
        ```
        agent:
        <...>
          apm:
            enabled: true
            hostPort: 8126
        <...>
        clusterAgent:
            config:
            admissionController:
                enabled: true
                mutateUnlabelled: true
        ```

    * Adicionar o seguinte nos componentes de pods(deployment, daemonset, statefulset) dos serviços:
        ```
        admission.datadoghq.com/enabled: "true"
        ```

    * Adicionar labels e annotations nos Pods:  
        Exemplos no arquivo templates/conversor-php-example.yaml


    ### Colocar agente APM nas imagens(ECR) dos serviços ###
    * Para instalar em PHP:  
        ```
        curl -LO https://github.com/DataDog/dd-trace-php/releases/latest/download/datadog-setup.php;  
        php datadog-setup.php --php-bin=all  
        ```
    * Em Go, precisa instalar o tracing client do Datadog, e fazer a instrumentacao dentro do codigo, com a library do datadog:
        ```
        go get gopkg.in/DataDog/dd-trace-go.v1/ddtrace
        ```
        Quick Start para a Instrumentacao(Passo 4 e 5):  
        ```
        https://app.datadoghq.com/apm/docs?architecture=container-based&collection=Helm%20Chart%20%28Recommended%29&environment=kubernetes&framework=gin&language=go
        ```
    * Para NodeJS:  

        ```  
        npm install dd-trace --save
        ```

    * Python:
        ```
        pip install ddtrace
        ```
    Obs.:  
        * Para todos os agentes, o yaml do Deployment tambem precisa ter as modificacoes no annotattion;  
        * Para ingestar log files é necessário adicionar o Volume, e VolumeMount, nos datadog agentes do cluster através do DaemonSet.


    ## Coleta de logs ##
    * Para coletar logs é necessário colocar no annotation de cada pod o seguinte:

        ```
        ad.datadoghq.com/financeiro.logs: | 
          [
            {
               "type":"file",
               "path":"/var/www/html/storage/logs/laravel.log",
               "source":"laravel",
               "service":"financeiro"
            },
            {
              "source":"container",
              "service":"financeiro"
            }
          ]
          ```




#### Referências: ####
    https://docs.datadoghq.com/containers/kubernetes/installation/?tab=operator
    https://docs.datadoghq.com/agent/guide/operator-advanced
    https://docs.datadoghq.com/containers/kubernetes/apm/?tab=helm
    https://docs.datadoghq.com/agent/guide/agent-configuration-files/?tab=agentv6v7#agent-main-configuration-file






