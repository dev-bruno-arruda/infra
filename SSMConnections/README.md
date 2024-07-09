# Instruções para acessar os recursos AWS via cli #

## Pré-requisitos ##

* Cliente aws cli instalado e configurado (Necessário AWS Access key e Secret key)
* Plugin SSM instalado

## Instalação ##

* Instalar o AWS CLI para o sistema operacional desejado:  
    `https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html`
* Configuração rápida com 'aws configure':  
    `https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-configure-quickstart.html`  
* Instalação do Plugin SSM:  
    `https://docs.aws.amazon.com/pt_br/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html`


## Conectando em algum recurso AWS via SSH ##
Utilizaremos para isso o feature SSM do recurso AWS Systems Manager.

1. Para se conectar usamos a seguinte sintaxe:  
    ```
    aws ssm start-session \
    --target (string)
    ```

    Onde string é o instance id da EC2 que desejamos conectar via ssh, por exemplo: i-0918eb490b91fb69f

2. Para descobrirmos o instance id podemos entrar no console EC2 da AWS:  
    https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances  

    Na coluna Instance ID estará o ID que procuramos.

3. Com o instance ID podemos conectar na instância via ssh, seguindo a sintaxe acima, por exemplo:
    ```
    aws ssm start-session \
    --target i-0918eb490b91fb69f
    ```
    
    O output do comando deve ser algo assim:
    ```
    Starting session with SessionId: leandro.mota-06d3a5135c4d91092
    ```

## Conectando em algum recurso AWS (qualquer porta) ##

Para conectar nos recursos AWS vamos evitar liberar portas para IP externos, e públicos, a AWS.  
Para isso estamos usando as configurações de IAM roles e o recurso SSM.  

Com o recurso SSM conseguimos fazer um tunel redirecionando o tráfico de uma porta de uma instancia que está na AWS para uma máquina local.

1. Para se conectar usamos a seguinte sintaxe:
    ```
    aws ssm start-session \
    --target (string) \
    --document-name (string) \
    --parameters '{"string": ["string", ...]...}'
    ```
2. Porém há um arquivo para cada recurso no repositório já com os parametros:  
    * db-conversor-hmg.json
    * db-conversor-prod.json
    * db-encurtador-hmg.json
    * db-encurtador-prod.json
    * db-hmg.json
3. Basta rodar o comando:
    ```
    aws ssm start-session --cli-input-json file://(arquivo.json)
    ```

    * Por exemplo:
        ```
        aws ssm start-session --cli-input-json file://db-conversor-hmg.json
        ```
        Para rodar em background:  
        ```
        aws ssm start-session --cli-input-json file://db-conversor-hmg.json > /dev/null 2>&1 &
        ```  
        Ao rodar em background, o processo precisa ser terminado quando não for mais necessário:  
        ```
        kill -9 (numero do processo*) 
        
        *Indicado quando rodou o comando aws ssm em background
        ```      

    * Depois de rodar o comando, manter o terminal aberto realizando o port forward.  
    E se conectar no recurso no devido cliente(browser, NoSQL Booster, DBeaver, ...) usando o endereço:  
        ```
        http://localhost:(localPortNumber)
        ```

    * Por exemplo:
        * Para o zabbix:
            ```
            http://localhost:32768/zabbix
            ```
        * Para o MongoDB, convesor-go HMG:
            ```
            mongodb://localhost:27018/
            ```
        

Observações:  

1. Para evitar confusões, cada arquivo está com uma porta local diferente:  
    - db-conversor-hmg.json |    27018           
    - db-conversor-prod.json |   27020
    - db-encurtador-hmg.json |   27017
    - db-encurtador-prod.json |  27021
    - db-new-encurtador-prod.json |  27022
    - db-new-encurtador-hmg.json |  27023
    - db-encurtador-redirect-hmg.json | 27024
    - db-encurtador-redirect-prod.json | 27025
    - db-hmg.json | 27019
    - db-porteira-prod | 3307
    - db-affiliate-prod | 3308
    - db-reports-prod | 3309
    - zabbix.json | 32768

Referências:  
https://docs.aws.amazon.com/cli/latest/reference/ssm/start-session.html