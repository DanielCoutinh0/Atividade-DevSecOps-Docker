# Atividade-DevSecOps-Docker
Trabalho para fixar conhecimentos de DOCKER 
![Screenshot 2024-12-11 151340](https://github.com/user-attachments/assets/bda981fa-f762-48c8-90b5-9a5660410cb4)

<h1 align="center"> Requisitos </h1>

<img src="https://img.icons8.com/?size=100&id=wU62u24brJ44&format=png&color=000000" alt="AWS" title="AWS" width="20" height="20"/> Conta AWS

<img src="https://img.icons8.com/?size=100&id=22813&format=png&color=000000" alt="DOCKER" title="DOCKER" width="20" height="20"/> Docker ou Containerd

<img src="https://img.icons8.com/?size=100&id=19679&format=png&color=000000" alt="SCRIPT" title="SCRIPT" width="20" height="20"/> Script de Start Instance (user_data.sh)

<img src="https://img.icons8.com/?size=100&id=13664&format=png&color=000000" alt="WORDPRESS" title="WORDPRESS" width="20" height="20"/> Wordpress

<img src="https://img.icons8.com/?size=100&id=59927&format=png&color=000000" alt="MYSQL" title="MYSQL" width="20" height="20"/> RDS MySQL

<img src="https://img.icons8.com/?size=100&id=Xnh9f6O879pb&format=png&color=000000" alt="EFS" title="EFS" width="20" height="20"/> EFS AWS

<img src="https://img.icons8.com/?size=100&id=59368&format=png&color=000000" alt="LOADBALANCER" title="LOADBALANCER" width="20" height="20"/> Load Balancer AWS (Classic)

<img src="https://img.icons8.com/?size=100&id=63777&format=png&color=000000" alt="GITHUB" title="GITHUB" width="20" height="20"/> Github

<h1> Sobre o Projeto </h1>

<h3>Proposta:</h3>

Criar uma infraestrutura escalável, resiliente e de alta disponibilidade para hospedar o WordPress utilizando os serviços da AWS. 

<h3>Objetivos</h3>

Alta Disponibilidade

Escalabilidade Automática

Desempenho e Experiência do Usuário

Resiliência e Recuperação de Falhas

Redução de Custos

<br>

  <h2>1º PASSO - VPC</h2>
  Criar VPC e suas Sub-Redes (2 Publicas e 2 Privadas)
  
  Instalar as sub-redes em Gateways

  Criar tabelas de rotas e associar as sub-redes certas
  
  ![image](https://github.com/user-attachments/assets/bf67d6bc-4f6c-474c-a717-cfd2168b2d71)

  <br>

  <h2>2º PASSO - Grupos de Segurança</h2>
  Criar 4 grupos de seguranças (EC2/RDS/LB/EFS)

  ![Screenshot 2024-12-20 225942](https://github.com/user-attachments/assets/fd6459d1-11e7-4c6a-9a80-8b5cff8c62d7)


  ### Para o EC2:
- Entrada 
  | Tipo         | Protocolo|  Porta     |      Tipo de Origem         |
  |--------------|----------|------------|-----------------------------|
  |     HTTP     |    TCP   |    80      |    Grupo de Segurança do Load Balancer     |
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

  <br>
  
  <h2>3º PASSO - RDS</h2>
  Criar RDS (Banco de Dados)
  
  <h4>Configurações na criação da RDS</h4>

  * Opções do mecanismo = MySQL
  
  * Disponibilidade e durabilidade = instancia de banco de dados unica
  
  * Gerenciamento de credenciais = autogerenciada
  
  * Configuração da instância = db.t3.micro
  
  * Grupo de segurança de VPC = apenas o grupo RDS criado anteriormente
  
  * Configuração adicional = nome do banco de dados inicial = wordpress
  
  * Anotar a senha, usuario, endpoint
 
  ![Screenshot 2024-12-23 235035](https://github.com/user-attachments/assets/ccb27ddf-5b7f-4271-af5e-6f5b9f1c8a74)

  <br>
 
  <h2>4º PASSO - EFS</h2>
  Criar EFS (Elastic File System)
 
  <h4>Configurações na criação da EFS</h4>
  
  * colocar vpc criada anteriorente
  
  * Pontos de acesso = /wordpress
  
  * Rede = sub-redes privadas criadas antes, grupo de segurança EFS criado antes
  
  * Copiar nome do DNS
 
  ![Screenshot 2024-12-20 203225](https://github.com/user-attachments/assets/7ec1a583-da1f-46e2-a0b1-da504a4e50a2)

  <br>
  
  <h2>5º PASSO - LOAD BALANCER</h2>
  Criar LB (Load Balancer)

  <h4>Configurações na criação da LOAD BALANCER</h4>
  
   2 - criar LB
  
    * Tipo = Classic Load Balancer
  
    * Voltado para a Internet
  
    * IPv4
  
    * VPC criado antes, sub-redes publicas
    
    * grupo de segurança = load balancer criado antes
  
    * Listeners = HTTP 80
 
    * Verificações de integridade = /wp-admin/install.php ou /wp-login.php ou /wp-admin/index.php
 
    * Instâncias = não precisa
 
    ![OIP](https://github.com/user-attachments/assets/4dda7aa7-7045-46be-81d6-f2c1be15d036)

  <br>
 
    <h2>6º PASSO - EC2</h2>
    
    Criar Duas EC2 (Instancia)
 
  <h4>Configurações na criação do modelo de execução (ec2)</h4>

  * Imagem = Amazon Linux 2
  
  * Tipo = t2.micro
  
  * VPC = criada anteriormente
  
  * Sub-Rede = Privadas criada anteriormente
  
  * grupo de segurança = grupo EC2 criado anteriormente
  
  User-Data Script:
  
   ![code](https://github.com/user-attachments/assets/27be2b5d-e9dc-4542-a631-9703085e656b)

    <br>

  <h2>7º PASSO - Auto Scaling</h2>
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
 
  ![OIP](https://github.com/user-attachments/assets/a3ca46ef-d229-4949-af1f-fece3a861df8)

    <br>

  <h2>8º PASSO (OPCIONAL)</h2>
  
  Acessar a EC2 via SSH (puTTY), usando Bastion Host
  
  Usuario = ec2-user
  
  Senha = Par de chaves escolhidas na criação da ec2

  ![NM-diagram-061316-a](https://github.com/user-attachments/assets/5f23bd73-322c-48bf-a89d-5cf8d2e56cc4)


  <br>

  <h2>Pontos Importante</h2>

  <h4>1 - Como Acessar a pagina wordpress</h4>

  * Pegue o DNS do LOAD BALANCER

  * Na Web Use " http://(DNS do LB) "
  <br>
  
  <h4>2 - Ao reiniciar as maquinas EC2 o Wordpress vai parar ? Não! Motivo:</h4>

  o docker está configurado para iniciar automaticamente com o sistema através do comando :
  
    ```

      sudo systemctl enable docker

    ```

    O comando restart garante que o container do Wordpress seja reiniciado automaticamente quando o Docker iniciar

  ````
  restart: always
  ````
  <br>

  <h4>3 - Aumento repentino no tráfego do WordPress</h4>

  Algumas implementações feitas ajudam a manter o sistema funcionando mesmo com o aumento de tráfego, Ex:

  Auto Scaling Group (ASG), o Auto Scaling adiciona ou remove instâncias automaticamente com base na carga do sistema

  Load Balancer, evita que uma única instância fique sobrecarregada.

  CloudWatch, monitorar métricas como uso de CPU, memória e tráfego de rede nas instâncias EC2 e no Load Balancer.

  <br>

  <h4>4 - Quais medidas para garantir que o WordPress está seguro contra ataques?</h4>

  Security Groups, Regras de firewall com Security Groups na AWS para permitir apenas conexões necessárias.

  Backup Automático do RDS, recuperação em caso de incidentes.

  CloudWatch, logs detalhados para monitorar a atividade do sistema e detectar acessos suspeitos.

  <br>

  <h4>5 - Como proceder se o banco de dados RDS for removido acidentalmente?</h4>

  Backup Automático, restaurar o banco de dados para um estado anterior.

  Snapshots Manuais, restaurá-lo a partir de um snapshot.

  
  <br>
  <br>
 
  <h2>Referências</h2>

  https://docs.aws.amazon.com/?nc2=h_ql_doc_do #Documentação Oficial AWS

  https://www.youtube.com/watch?v=9vI108Tnpzg #Bastion Host

  https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/create-vpc.html #Criar VPC

<br>
<br>


  <img src="https://upload.wikimedia.org/wikipedia/commons/4/45/Logo_CompassoUOL_Positivo.png" alt="COMPASS-LOGO" title="COMPASS-LOGO"/>



  
  
