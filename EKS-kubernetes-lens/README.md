# Instruções para acessar os clusters Kubernetes via Lens #

## Pré-requisitos ##

* Cliente aws cli instalado e configurado (Necessário AWS Access key e Secret key)
* Cliente kubectl  
* Aplicativo Lens (Necessário criar uma conta, free, no site do Lens)

## Instalação ##

* Instalar o AWS CLI para o sistema operacional desejado:  
    https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html

* Configuração rápida com 'aws configure':  
    https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-configure-quickstart.html  

* Instalação do Cliente kubectl:  
    https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

* Instalação do Lens (Necessário também criar uma conta, free, no site do Lens):  
    https://docs.k8slens.dev/main/getting-started/install-lens/#install-lens-desktop-on-linux

## Conectando ao cluster EKS homolog ##

Para conectar nos clusters é necessário se autenticar ao menos uma vez ao serviço EKS para gerar o seu token.  
Antes disso, verificar se a versão do aws cli é a 2.x:  

1. Primeiro, verificar a versão:
    ```
    aws --version
    ``` 

2. Depois disso, gerar o arquivo kubeconfig com as informações de autenticação com o seguinte comando:  
    ```
    aws eks --region us-east-1 update-kubeconfig --name homolog-afilio-v3
    ```
3. Teste a conexão:
    ```
    kubectl get pods -n v3
    ```
    * A saída do comando acima deve ser algo parecido com o abaixo:  
        ```
        NAME                                                    READY   STATUS      RESTARTS        AGE
        advertise-cron-laravel-27757461-tttgs                   0/1     Completed   0               47s
        advertiser-58498594cc-rfx7q                             1/1     Running     0               11d
        affiliate-648cbb66bc-bcqbl                              1/1     Running     0               11d
        conversor-go-78bd5d88b7-h647d                           1/1     Running     0               11d
        conversor-php-5d8bb49fb9-rwr2j                          1/1     Running     0               11d
        creatives-79db66c74d-dbjwh                              1/1     Running     0               11d
        creatives-cron-laravel-27757461-c2b8s                   0/1     Completed   0               47s
        ```

    Para conectar no cluster de produção basta repetir os passos acima substituindo o passo 2 por:  
    ```
    aws eks --region us-east-1 update-kubeconfig --name afilio-v3
    ```    

    Ao abrir o Lens ele virá automaticamente com os cluster já configurados, basta clicar neles que ele conectará automaticamente.

    Lembrar de retirar o filtro de namespace de "default"

Um overview sobre a interface do Lens:  
    [![Overview Lens](http://img.youtube.com/vi/eeDwdVXattc/hqdefault.jpg)](https://www.youtube.com/watch?v=eeDwdVXattc)

## Comandos uteis para administração do cluster ##

1. Antes de rodar qualquer comando kubectl, verificar em qual contexto está.  O contexto indicará com qual cluster o kubectl estará interagindo:    
    ```
    kubectl config view --minify
    ```
    * A saída terá a config:  
        ```
        ...
        - context:
            cluster: arn:aws:eks:us-east-1:684661340622:cluster/homolog-afilio-v3
            user: arn:aws:eks:us-east-1:684661340622:cluster/homolog-afilio-v3
          name: arn:aws:eks:us-east-1:684661340622:cluster/homolog-afilio-v3
        ...
        ```  
        ou
        ```
        - context:
            cluster: arn:aws:eks:us-east-1:684661340622:cluster/afilio-v3
            user: arn:aws:eks:us-east-1:684661340622:cluster/afilio-v3
          name: arn:aws:eks:us-east-1:684661340622:cluster/afilio-v3
        ...
        ```
2. Para verificar consumo CPU e Memória dos pods:  
    ```
    kubectl top pods -A
    ```

3. Para verificar consumo dos nodes:   
    ```
    kubectl top nodes
    ```

4. Para acessar um container de um pod no terminal local:
    * Sintaxe:
        ```
        kubectl exec -i -t -n <namespace> <pod-name> -c <container-name> -- sh -c "clear; (bash || ash || sh)"
        ```
    * Por exemplo:
        ```
        kubectl exec -i -t -n v3 conversor-php-7c5966db66-vpv2l -c conversor-php -- sh -c "clear; (bash || ash || sh)"
        ```

5. Comando igual ao de cima, mais automático. Coleta o nome do pod e conecta no container do serviço:  
    * Sintaxe:  
    ```
    kubectl exec -i -t -n <namespace> $(kubectl get pods -n <namespace> | grep <nome-do-serviço> | awk 'NR==1 {print $1}') -c <container-name> -- sh -c "clear; (bash || ash || sh)"
    ```
    * Por exemplo:  
    ```
    kubectl exec -i -t -n v3 $(kubectl get pods -n v3 | grep conversor-php | awk 'NR==1 {print $1}') -c conversor-php -- sh -c "clear; (bash || ash || sh)"
    ```  
    Caso o deployment tenha mais de um pod rodando, o comando acima acessará o primeiro pod, para acessar o segundo tem que mudar o NR==1 para NR==2 e assim sucessivamente.

6. Listar numero maximo de pods dos nodes do cluster:  
    * Sintaxe:  
    ```
    kubectl describe nodes $(kubectl get nodes -A | awk 'NR!=1 {print $1}') | grep -i pods
    ```

Referências:  
https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/  
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands