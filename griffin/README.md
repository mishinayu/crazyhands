#  Данные роли  предполагает развертывание компонентов Apache Griffin

Apache Griffin - это настраиваемый, визуальный и контролируемый инструмент качества данных мониторинга качества данных решение с открытым исходным кодом.

### Список устанавливаемого и задействованного ПО.
Linux 7.6, Ansible 2.9.6, Python 2.7.5, Python 3.6.8 , Python 3.8.6, Java 1.8.0+, Apache Griffin, NodeJS 6.0.0+, Hadoop 2.6.0+, Hive 2.0, Spark 2.2.1, Livy 0.4.0, ElasticSearch 6.8, Scala 2+, PostgreSQL 11.7

### Требования:
1. базовый Linux 7.6.
2. настроеный доступ по ключам для root пользователей со стороны Ansible-master.
3. пакет `python-netaddr` на Ansible-master
4. установка коллекций на Ansible-master (для версий 2.9+) командой: ```ansible-galaxy collection install community.docker``` и ```ansible-galaxy collection install community.general```
### Установка:
1. Установить ansible требуемой версии на одном из серверов имеющих непосредственный доступ по 22 порту: ```yum install ansible```
2. Получить код плейбуков из репозитория: ```git clone http://git.moscow.alfaintra.net/scm/dlplatform/griffin.git``
3. Сгенерировать пару (публичный и приватный) ключей на ansible-master сервере для root пользователя (при наличии, пропустить этот шаг): ```ssh-keygen -t rsa```
4. Скопировать публичный ключ root пользователя на Ansible-master на все таргеты (root->root): ```ssh-copy-id -i ~/.ssh/id_rsa.pub root@server```
5. Задать переменные в ./role/default/main.yml, ./role/var/main.yml и ./group_vars/all
6. Выполнить развертывание системы посредством запуска плейбука со следующими опциями:
Запуск плейбука осуществляется на Ansible-master сервере следующим образом:

```
ansible-playbook -v -i griffin master.yml --extra-vars "env_state=present" -t <тег роли>

```

При развертывании используются дефолтные значения учетных записей базового ПО.

### Описание ролей:

1. **griffin**   Установка и конфигурирование griffin. Тег   `-t air`
2. **pg**  Добавление базы данных, создание пользователя и создание таблиц для quartz. Тег   `-t pg`
3. **elasticsearch**  Добавление Elasticseach. Тег   `-t elastic`
4. **livy**    Установка и конфигурирование Livy.    Тег   `-t livy`
5. **nodejs**    Установка и конфигурирование NodeJS.    Тег   `-t nj`


Критерием успешной работы плейбуков являются:
1. Отсутствие ошибок представленное в output вышеприведенной команды
2. Работающая конфигурация на целевых машинах.
3. Доступ по ссылкам.


### Список использованных материалов.


| **Компонент**     |                        **Документация и инструкция по установке**             | 
| ------------- |:---------------------------------------------------|
| Apache Griffin    | [Install Apache Griffin      ](https://griffin.apache.org/docs/quickstart.html) | 
| PostgreSQL        | [Install Postgresql          ](https://itdraft.ru/2020/11/12/ustanovka-postgresql-iz-ishodnikov-i-zapusk-dvuh-versij-na-odnom-servere-v-centos-8/) |
| Apache Livy          | [Install and configure Apache Livy](https://livy.incubator.apache.org/get-started/)    | 
| NodeJS       | [Install NodeJS          ](https://nodejs.org/docs/latest-v12.x/api/) |
| ElasticSearch        | [Install ElasticSearch          ](https://www.elastic.co/webinars/getting-started-elasticsearch?ultron=brand-sitelink&blade=adwords-s&Device=c&thor=elasticsearch%20install&gclid=EAIaIQobChMI6LLx25qT8wIVaU1yCh1jnAAiEAAYASABEgITKfD_BwE) |

 
