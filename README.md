# Atividade-DevSecOps-Docker
Trabalho para fixar conhecimentos de DOCKER 
![Screenshot 2024-12-11 151340](https://github.com/user-attachments/assets/bda981fa-f762-48c8-90b5-9a5660410cb4)

<h1 align="center"> Requisitos </h1>

* Conta AWS

* Docker ou Containerd

* Script de Start Instance (user_data.sh)

* Wordpress

* RDS MySQL

* EFS AWS

* Load Balancer AWS (Classic)

* Git


  <h2>1º PASSO</h2>
  Criar VPC e suas Sub-Redes (2 Publicas e 2 Privadas)
  
  Instalar as sub-redes em Gateways

  Criar tabelas de rotas e associar as sub-redes certas
  
  ![image](https://github.com/user-attachments/assets/bf67d6bc-4f6c-474c-a717-cfd2168b2d71)

  <h2>2º PASSO</h2>
  Criar 4 grupos de seguranças (EC2/RDS/LB/EFS)

  ### Para o EC2:
- Entrada 
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  |     HTTP     |    TCP   |    80      |    G.S do Load Balancer     |
  |     SSH      |    TCP   |    22      |            IP               |
- Saída
  | Tipo          | Protocolo|  Porta     |      Tipo de Origem         |
  |---------------|----------|------------|-----------------------------|
  | Todo tráfego  |   Todos  |   Tudo     |        0.0.0.0/0            |
  | MySQL/Aurora  |   TCP    |   2206     |  Grupo de Segurança da RDS  |
  |    NFS        |   TCP    |   2049     |  Grupo de Segurança da EFS  |

  ### Para o RDS MySql:
- Entrada 
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  | MySql/Aurora |    TCP   |   3306     | Grupo de Segurança da EC2   |

  ### Para o EFS:
- Entrada
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  |    NFS       |    TCP   |   2049     |  Grupo de Segurança da EC2  |

  ### Para o LoadBalancer:
- Entrada
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  |     HTTP     |    TCP   |    80      |         0.0.0.0/0           |
- Saída
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  | Todo tráfego |   TCP    |   Tudo     |         0.0.0.0/0           |
  |    HTTP      |   TCP    |     80     | Grupo de Segurança da EC2   |

  <h2>3º PASSO</h2>
  criar RDS (Banco de Dados), EFS (Elastic File System), LB (Load Balancer), Duas EC2 (Instancia)
  
  <h4>Configurações na criação da RDS</h4>

  * Opções do mecanismo = MySQL
  
  * Disponibilidade e durabilidade = instancia de banco de dados unica
  
  * Gerenciamento de credenciais = autogerenciada
  
  * Configuração da instância = db.t3.micro
  
  * Grupo de segurança de VPC = apenas o grupo RDS criado anteriormente
  
  * Gerenciamento de credenciais = Autogerenciada
  
  * Configuração adicional: nome do banco de dados inicial = wordpress
  
  * Anotar a senha, usuario, endpoint
 
  <h4>Configurações na criação da EFS</h4>
  
  * colocar vpc criada anteriorente
  
  * Pontos de acesso = /wordpress
  
  * Rede = sub-redes privadas criadas antes, grupo de segurança EFS criado antes
  
  * Copiar nome do DNS
 
  <h4>Configurações na criação da LOAD BALANCER</h4>

  1- Criar um grupo de destino:
  
     * Tipo: instancias
     
     *  HTTP 80
     
     *  IPv4
     
     *  VPC criado antes
     
     *  Caminho: /wp-login.php ou /wp-admin/index.php ou /wp-admin/install.php

  2 - criar LB
  
    * Tipo: Classic Load Balancer
  
    * Voltado para a Internet
  
    * IPv4
  
    * VPC criado antes, sub-redes publicas
    
    * grupo de segurança: load balancer criado antes
  
    * Listeners: HTTP 80 grupo criado antes
 
  <h4>Configurações na criação da EC2</h4>

  * Imagem = Amazon Linux 2
  
  * Tipo = t2.micro
  
  * VPC = criada anteriormente
  
  * Sub-Rede = Privada criada anteriormente
  
  * Atribuir IP público automaticamente = Sim
  
  * grupo de segurança = grupo EC2 criado anteriormente
  
  User-Data Script:
  
   ![code](https://github.com/user-attachments/assets/03783522-48be-486a-9de9-c8f8590b7130)

  <h2>4º PASSO</h2>
  Acessar a EC2 via SSH (puTTY), usando Bastion Host
  
  Usuario = ec2-user
  
  Senha = Par de chaves escolhidas na criação da ec2

  <h2>Referências</h2>

  https://www.youtube.com/watch?v=9vI108Tnpzg #Bastion Host



  
  
