#  Данные роли  предполагает развертывание компонентов Airflow

Apache Airflow это open-source инструмент, который позволяет разрабатывать, планировать и осуществлять мониторинг сложных рабочих процессов. Главной особенностью является то, что для описания процессов используется язык программирования Python. Airflow используется как планировщик ETL/ELT-процессов.

### Список устанавливаемого и задействованного ПО.
Linux 7.6, Ansible 2.9.6, Python 2.7.5, Python 3.6.8 , Python 3.8, RabbitMQ 3.8.17, Erlang 23.3.4.3, PostgreSQL 11.7

### Требования:
1. базовый Linux 7.6.
2. настроеный доступ по ключам для root пользователей со стороны Ansible-master.
3. пакет `python-netaddr` на Ansible-master
4. установка коллекций на Ansible-master (для версий 2.9+) командой: ```ansible-galaxy collection install community.docker``` и ```ansible-galaxy collection install community.general```
### Установка:
1. Установить ansible требуемой версии на одном из серверов имеющих непосредственный доступ по 22 порту: ```yum install ansible```
2. Получить код плейбуков из репозитория: ```git clone http://git.moscow.alfaintra.net/scm/dlplatform/airflow.git``
3. Сгенерировать пару (публичный и приватный) ключей на ansible-master сервере для root пользователя (при наличии, пропустить этот шаг): ```ssh-keygen -t rsa```
4. Скопировать публичный ключ root пользователя на Ansible-master на все таргеты (root->root): ```ssh-copy-id -i ~/.ssh/id_rsa.pub root@server```
5. Задать переменные в ./role/default/main.yml, ./role/var/main.yml и ./group_vars/all
6. Выполнить развертывание системы посредством запуска плейбука со следующими опциями:
Запуск плейбука осуществляется на Ansible-master сервере следующим образом:

```
ansible-playbook -v -i airlfow master.yml --extra-vars "env_state=present" -t <тег роли>

```

При развертывании используются дефолтные значения учетных записей базового ПО.

### Описание ролей:

1. **common**   Предварительная подготовка update hosts, update Anaconda3 Python38 .Тег  `-t common`
2. **airflow**   Установка и конфигурирование airflow. Тег   `-t air`
3. **pg**  Добавление базы данных, создание пользователя и создание таблиц для airflow. Тег   `-t pg`
4. **rabbitmq**  Установка и конфигурирование брокера RabbitMQ. Тег   `-t mq`


Критерием успешной работы плейбуков являются:
1. Отсутствие ошибок представленное в output вышеприведенной команды
2. Работающая конфигурация на целевых машинах.
3. Доступ по ссылкам.


### Список использованных материалов.


| **Компонент**     |                        **Документация и инструкция по установке**             | 
| ------------- |:---------------------------------------------------|
| Apache Airflow    | [Install Apache Airflow      ](https://airflow.apache.org/docs/apache-airflow/stable/installation.html#prerequisites) | 
| PostgreSQL        | [Add airflow_db Postgresql   ](https://airflow.apache.org/docs/apache-airflow/stable/howto/set-up-database.html#setting-up-a-postgresql-database),[Install Postgresql   ](https://itdraft.ru/2020/11/12/ustanovka-postgresql-iz-ishodnikov-i-zapusk-dvuh-versij-na-odnom-servere-v-centos-8/) |
| RabbitMQ          | [Install RabbitMQ            ](https://www.rabbitmq.com/download.html) |

 
