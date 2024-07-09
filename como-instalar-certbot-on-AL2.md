# Instrucoes de como instalar CertBot no Amazon Linux 2 #


## Instalando o Snap ##
Primeiro precisamos habilitar o repositorio epel no Amazon Linux 2:  
```
sudo amazon-linux-extras install epel
```
Adicionar o repo da customizacao do Snap:  
```
cd /etc/yum.repos.d && wget https://people.canonical.com/~mvo/snapd/amazon-linux2/snapd-amzn2.repo
```

Instalar o Snap:
```
sudo yum install snapd
```
Habilitar para iniciar automaticamente apos restart do SO:
```
sudo systemctl enable --now snapd.socket
```
## Instalando o CertBot ##
Fazer logout na no servidor antes de rodar o comando abaixo:  
```
sudo snap install core; sudo snap refresh core
```
Apos atualizar o snapd, instalar o CertBot com o comando abaixo:  
```
sudo snap install --classic certbot
```

Testar certbot:
```
certbot --help
```

Comando exemplo para gerar um certificado para uma url:  
```
sudo certbot --authenticator standalone --installer apache -d example.com --pre-hook “service httpd stop” --post-hook “service httpd start”
```
Observacoes:  
Tem que ser possivel chegar no endpoint para criar o certificado, por exemplo, porta 443 deve estar liberada.  
E o httpd.conf precisar estar configurado para a porta 443, e o wp-config.php para o hostname https://  
Necessario ter um arquivo .conf no /etc/httpd/conf.d/financeone.conf com o conteudo:  
```
<VirtualHost *:80>
    ServerName prod.financeone.com.br
    DocumentRoot /var/www/html
    ServerAlias prod.financeone.com.br
    ErrorLog /var/www/error.log
    CustomLog /var/www/requests.log combined
RewriteEngine on
RewriteCond %{SERVER_NAME} =prod.financeone.com.br
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
```


Referencias:  
https://forum.snapcraft.io/t/unofficial-snapd-repository-for-amazon-linux-2/24269

https://snapcraft.io/docs/installing-snap-on-centos 

https://certbot.eff.org/instructions?ws=apache&os=centosrhel7
