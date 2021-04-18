#  Данный проект предполагает развертывание компонентов Мониторинга, как составной части Платформы КГХ.

В настоящий момент архитектура системы МОН представляет собой программный комплекс состоящий из 3-х нодового кластера системы сбора логов ELK. Данный кластер предоставляет возможности горизонтального масштабирования с помощью данных плейбуков. Компонентами кластера являются: ElasticSearch, Logstash, Kibana. Filebeat, Metricbeat должны устанавливаться на агентских серверах. Цель данной системы обеспечить проактивный мониторинг платформы КГХ. Цель данной инструкции - иметь возможность универсально развертывать всю систему целиком для разных видов сред (Prod, UAT, Dev) или отдельные ее элементы в частности, управляя таким образом жизненными циклами данного продукта.


### Список устанавливаемого и задействованного ПО.
RHEL 7.6, Ansible 2.9.15, Python 2.7.5, Nginx 1.18.0, Elasticsearch 7.10.0, Kibana 7.10.0 , Logstash 7.10.0 , Filebeat 7.10.0 , Metricbeat 7.10.0

### Требования:
1. базовый Linux 7.6.
2. наличие подключенных репозиториев RHEL ко всем серверам (base, extras, updates, tools, optional, rhscl).
3. доступ в интернет к вендорским сайтам для загрузки пакетов.
4. настроеный доступ по ключам для root пользователей со стороны Ansible-master.
5. пакет `python-netaddr` на Ansible-master
### Установка:
1. Установить ansible требуемой версии на одном из серверов имеющих непосредственный доступ по 22 порту: ```yum install ansible```
2. Получить код плейбуков из репозитория: ```git clone https://git.mos.ru/kgh/kgh-platform/miscs/elk_deploy```
3. Сгенерировать пару (публичный и приватный) ключей на ansible-master сервере для root пользователя (при наличии, пропустить этот шаг): ```ssh-keygen -t rsa```
4. Скопировать публичный ключ root пользователя на Ansible-master на все таргеты (root->root): ```ssh-copy-id -i ~/.ssh/id_rsa.pub root@x.x.x.x```
5. Задать переменные в ./role/default/main.yml, ./role/var/main.yml и ./group_vars/all
6. Выполнить развертывание системы посредством запуска плейбука со следующими опциями:
Запуск плейбука осуществляется на Ansible-master сервере следующим образом:

```
ansible-playbook -v -i hosts master.yml --extra-vars "env_state=present"

```

При развертывании используются дефолтные значения учетных записей базового ПО.

### Описание ролей:

1. **common**   Предварительная подготовка resolv.conf,update hosts, packages installed, add repository.Тег  `-t common`
2. **nginx**    Установка и конфигурация балансировщика.   Тег  `-t bal` 
3. **elastic**   Установка и конфигурирование Elasticsearch. Тег  `-t elastic`
4. **kibana**   Установка и конфигурирование Kibana.  Тег   `-t kibana`
5. **logstash**   Установка и конфигурирование Logstash.  Тег   `-t logstash`
6. **сurator** Установка и конфигурирование Curator. Тег -t curator
7. **agents**   Установка и конфигурирование агентов Filebeat и Metricbeat.  Тег   `-t agents`

Критерием успешной работы плейбуков являются:
1. Отсутствие ошибок представленное в output вышеприведенной команды
2. Работающая конфигурация на целевых машинах.
3. Доступ по ссылкам:
http://kibana.mon-test.kgh.mos.ru/

### Список использованных материалов.


| **Компонент**     |                        **Документация и инструкция по установке**             | 
| ------------- |:---------------------------------------------------|
| ELK Stack  | [Install ELK Stack ](https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html)      | 
| Nginx  | [Install NGINX Web Server](https://tecadmin.net/install-nginx-on-centos/)  , [Install Nginx SSL Certificate](https://tecadmin.net/install-nginx-ssl-certificate/) , [Redirect a URL in NGINX](https://tecadmin.net/how-to-redirect-a-url-in-nginx/)      |


