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

  ![Screenshot 2024-12-20 225942](https://github.com/user-attachments/assets/fd6459d1-11e7-4c6a-9a80-8b5cff8c62d7)


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
  
  * Configuração adicional = nome do banco de dados inicial = wordpress
  
  * Anotar a senha, usuario, endpoint
 
  <h4>Configurações na criação da EFS</h4>
  
  * colocar vpc criada anteriorente
  
  * Pontos de acesso = /wordpress
  
  * Rede = sub-redes privadas criadas antes, grupo de segurança EFS criado antes
  
  * Copiar nome do DNS
 
  ![Screenshot 2024-12-20 203225](https://github.com/user-attachments/assets/7ec1a583-da1f-46e2-a0b1-da504a4e50a2)

  ![Screenshot 2024-12-20 225754](https://github.com/user-attachments/assets/4007b80d-927d-4ab6-975f-f44a9abfdc42)


  <h4>Configurações na criação da LOAD BALANCER</h4>
  
   2 - criar LB
  
    * Tipo = Classic Load Balancer
  
    * Voltado para a Internet
  
    * IPv4
  
    * VPC criado antes, sub-redes publicas
    
    * grupo de segurança = load balancer criado antes
  
    * Listeners = HTTP 80 grupo criado antes
 
    * Verificações de integridade = /wp-admin/install.php ou /wp-login.php ou /wp-admin/index.php
 
    * Instâncias = ec2 criadas
 
  <h4>Configurações na criação do modelo de execução (ec2)</h4>

  * Imagem = Amazon Linux 2
  
  * Tipo = t2.micro
  
  * VPC = criada anteriormente
  
  * Sub-Rede = Privadas criada anteriormente
  
  * grupo de segurança = grupo EC2 criado anteriormente
  
  User-Data Script:
  
   ![code](https://github.com/user-attachments/assets/d7bfd7ef-45aa-4f50-aac6-11d4a48093b4)


  <h2>4º PASSO</h2>
  Criar grupo de Auto Scaling
  
  * Modelo de execução = criado antes
  
  * Versão = latest
  
  * Rede = vpc
  
  * Zonas = apenas privadas
  
  * Balanceamento de carga = load balancer classic criado antes
  
  * Verificações de integridade = verificações de integridade do Elastic Load Balancing
  
  * Capacidade desejada = 2
  
  * Capacidade mínima desejada = 2
  
  * Capacidade máxima desejada = 2


  <h2>5º PASSO (OPCIONAL)</h2>
  
  Acessar a EC2 via SSH (puTTY), usando Bastion Host
  
  Usuario = ec2-user
  
  Senha = Par de chaves escolhidas na criação da ec2

  <h2>Dicas</h2>

  1 - Como Acessar a pagina wordpress

  * Pegue o DNS do LOAD BALANCER

  * Na Web Use " http://(DNS do LB) "
 
  <h2>Referências</h2>

  https://docs.aws.amazon.com/?nc2=h_ql_doc_do #Documentação Oficial AWS

  https://www.youtube.com/watch?v=9vI108Tnpzg #Bastion Host

  https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/create-vpc.html #Criar VPC

  



  
  
