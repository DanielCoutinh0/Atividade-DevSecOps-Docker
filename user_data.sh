#!/bin/bash

EFS_DNS="<DNS do EFS>"          # Substitua pelo DNS do EFS
DB_HOST="<Endereço do RDS>"     # Substitua pelo EndPoint do RDS
DB_USER="<Usuário do banco>"    # Substitua pelo usuário do banco
DB_PASSWORD="<Senha do banco>"  # Substitua pela senha do banco
DB_NAME="<Nome do banco>"       # Substitua pelo nome do banco

sudo yum update -y

echo "Iniciando atualização do sistema..." >> /var/log/user-data.log

sudo yum install docker -y

echo "Instalando Docker..." >> /var/log/user-data.log

sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -L https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

sudo systemctl start docker

sudo systemctl enable docker

echo "Iniciando e habilitando o serviço Docker..." >> /var/log/user-data.log

sudo mkdir -p /efs

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <"DNS do EFS">:/ /efs # tirar os <> ao por dns do efs

echo "Montando o EFS em /efs..." >> /var/log/user-data.log

cat <<EOF > /home/ec2-user/docker-compose.yml

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: "${DB_HOST}"
      WORDPRESS_DB_USER: "${DB_USER}"
      WORDPRESS_DB_PASSWORD: "${DB_PASSWORD}"
      WORDPRESS_DB_NAME: "${DB_NAME}"
    volumes:
      - /efs/wordpress:/var/www/html

EOF

echo "Criando arquivo docker-compose.yml..." >> /var/log/user-data.log

cd /home/ec2-user

sudo docker compose up -d

echo "Iniciando contêiner WordPress com Docker Compose..." >> /var/log/user-data.log

if mountpoint -q /efs; then
  echo "EFS montado com sucesso em /efs." >> /var/log/user-data.log
else
  echo "Erro ao montar o EFS. Verifique o DNS configurado." >> /var/log/user-data.log
  exit 1
fi

echo "Script concluído com sucesso!" >> /var/log/user-data.log
