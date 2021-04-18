#  Данный проект предполагает развертывание компонентов , а также окружения систем Компоненты системы размещаются в K8S среде.

В настоящий момент архитектураа представляет собой программный комплекс состоящий из 1 сервера (WSO2EI, PG11, Kafka), 1 сервера IDM (WSO2IS), 3-х серверов BigData (Hadoop, Hive, Hbase, Phoenix, Zookeeper), 1-ого балансировщика соединений Nginx, а так же развернутый кластер Kubernetes. Цель данной системы обеспечить комбинированное масштабируемое решение АИС Охотбилета в контейнерной среде и частей Платформы необходимых для интеграции,  для взаимодействия подсистем продукта между собой и другими информационными системами. Цель данной инструкции - иметь возможность универсально развертывать всю систему целиком для разных видов сред (Prod, UAT, Dev) или отдельные ее элементы в частности, управляя таким образом жизненными циклами данного продукта.

### Список устанавливаемого и задействованного ПО.
RHEL 7.6, Ansible 2.9.6, Python 2.7.5, PostgreSQL 11.7, Kafka 2.11-2.3.0, Nginx 1.17.9, Hadoop 3.2.0, Hive 3.1.1, Hbase 2.2.4, Phoenix 5.0.0, Apache Zookeeper 3.5.7, Kubernetes 1.18.6, Wso2ei 6.5.0, WSO2IS 5.10.0
Apache Zookeeper 3.5.7, Spark 2.4.3, Apache Ignite 2.8.1 . 
WSO2 Enterprise Integrator 6.5.0 + BPS, WSO2 Api Manager 2.6.0., VerneMQ 1.10.4.1

### Требования:
1. базовый Linux 7.6.
2. наличие подключенных репозиториев RHEL ко всем серверам (base, extras, updates, tools, optional, rhscl).
3. доступ в интернет к вендорским сайтам для загрузки пакетов.
4. настроеный доступ по ключам для root пользователей со стороны Ansible-master.
5. пакет `python-netaddr` на Ansible-master
6. установка коллекций на Ansible-master (для версий 2.9+) командой: ```ansible-galaxy collection install community.docker``` и ```ansible-galaxy collection install community.general```
### Установка:
1. Установить ansible требуемой версии на одном из серверов имеющих непосредственный доступ по 22 порту: ```yum install ansible```
2. Получить код плейбуков из репозитория: ```git clone https://``
3. Сгенерировать пару (публичный и приватный) ключей на ansible-master сервере для root пользователя (при наличии, пропустить этот шаг): ```ssh-keygen -t rsa```
4. Скопировать публичный ключ root пользователя на Ansible-master на все таргеты (root->root): ```ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.19.72.205```
5. Задать переменные в ./role/default/main.yml, ./role/var/main.yml и ./group_vars/all
6. Выполнить развертывание системы посредством запуска плейбука со следующими опциями:
Запуск плейбука осуществляется на Ansible-master сервере следующим образом:

```
ansible-playbook -v -i hosts master.yml --extra-vars "env_state=present"

```

При развертывании используются дефолтные значения учетных записей базового ПО.

### Описание ролей:

1. **common**   Предварительная подготовка resolv.conf,update hosts, packages installed, add repository.Тег  `-t common`
2. **kafka**   Установка и конфигурирование брокера.Тег   `-t kafka`
3. **zookeeper**   Установка и конфигурирование распределенной системы Zookeeper.Тег   `-t zoo
4. **nginx**    Установка и конфигурация балансировщика.   Тег  `-t bal` 
5. **pg**   Установка и конфигурирование базы данных. Тег  `-t pg`
6. **hive**    Установка и конфигурирование  базами данных на основе платформы Hadoop.    Тег   `-t hive`
7. **hbase**    Установка и конфигурирование  базами данных на основе платформы Hadoop.    Тег   `-t hbase`
8. **hadoop**   Установка и конфигурирование hadoop кластера.  Тег   `-t hadoop`
10. **spark**   Установка и конфигурирование  платформы распределённия обработки данных.  Тег   `-t spark`
9. **phoenix**   Установка и конфигурирование phoenix и cоединение с кластером HBase.  Тег   `-t phoenix`
10. **wso2ei**   Установка и конфигурирование  интеграционной шины.  Тег   `-t wso2ei`
11. **wso2is**   Установка и конфигурирование сервиса индентификации пользователей.  Тег   `-t wso2is`
11. **wso2mi**   Установка и конфигурирование  платформы запуска интеграционных маршрутов в микросервисной архитектуре.  Тег   `-t wsomi`
4. **verne**    Установка и конфигурирование MQTT-брокера.    Тег   `-t verne`
5. **wso2am**   Установка и конфигурирование  WSO2 Api Manager.  Тег   `-t wsoam`
7. **wso2bps**  Установка и конфигурирование WSO2 BPS. Тег `-t wsobps`
12. **kubernetes**   Установка и конфигурирование автоматизации развёртывания, масштабирования контейнеризированных приложений и управления ими.  Тег   `-t kubernetes`
12. **aig**   Установка и конфигурирование распределённой системы in-memory.  Тег   `-t aig`

Критерием успешной работы плейбуков являются:
1. Отсутствие ошибок представленное в output вышеприведенной команды
2. Работающая конфигурация на целевых машинах.
3. Доступ по ссылкам:

### Список использованных материалов.


| **Компонент**     |                        **Документация и инструкция по установке**             | 
| ------------- |:---------------------------------------------------|
| Hadoop     | [Install Hadoop Multi-Node Cluster ](https://tecadmin.net/set-up-hadoop-multi-node-cluster-on-centos-redhat/) |  
| Apache Hive          | [Install and configure Apache Hive](http://www.mtitek.com/tutorials/bigdata/hive/install.php#sec_id_3)    | 
| Apache Hbase        | [Install and configure Apache Hbase](https://hbase.apache.org/book.html#faq)    | 
| Apache Phoenix          | [Install and configure Apache Phoenix](https://phoenix.apache.org/Phoenix-in-15-minutes-or-less.html)    |
| Spark  | [ Install and configure Apache Spark](http://www.mtitek.com/tutorials/bigdata/spark/install.php)        | n-15-minutes-or-less.html)    | 
| PostgreSQL  | [Install PostgreSQL 11 ](https://tecadmin.net/install-postgresql-11-on-centos/)      | 
| WSO2 Enterprise Integrator  | [ Install and configure WSO2EI](https://docs.wso2.com/display/EI660/Installation+Guide+)  |  
| WSO2 Identity Server | [ Install and configure WSO2IS ](https://is.docs.wso2.com/en/latest/)    |
| WSO2 Api Manager| [WSO2 API Install](https://apim.docs.wso2.com/en/latest/install-and-setup/installation-guide/installation-prerequisites/)       | 
| WSO2 BPS     | [Clustering the ESB Profile](https://docs.wso2.com/display/EI650/Clustering+the+Business+Process+Profile),[Clustering the Business Process Profile](https://docs.wso2.com/display/EI650/Clustering+the+ESB+Profile)
| Kafka,Zookeeper  | [Install and configure Apache Kafka](https://tecadmin.net/install-apache-kafka-centos-8/)        | 
| Apache Zookeeper  | [Install and configure Apache Zookeper](https://zookeeper.apache.org/doc/current/index.html)        | 
| Nginx  | [Install NGINX Web Server](https://tecadmin.net/install-nginx-on-centos/)  , [Install Nginx SSL Certificate](https://tecadmin.net/install-nginx-ssl-certificate/) , [Redirect a URL in NGINX](https://tecadmin.net/how-to-redirect-a-url-in-nginx/)      | 
| Apache Ignite  | [Install Apache Ignite](https://apacheignite.readme.io/docs/deployment) | 
| Wso2MicroIntegrator  | [Install Wso2mi](https://docs.wso2.com/display/EI650/Installing+WSO2+Micro+Integrator) | 
| VerneMQ   | [Installing VerneMQ](https://docs.vernemq.com/installation/centos_and_redhat)         | 
| Kubernetes  | [Install Kubernetes](http://itisgood.ru/2020/01/29/ustanovka-proizvodstvennogo-klastera-kubernetes-s-rancher-rke/) | 
