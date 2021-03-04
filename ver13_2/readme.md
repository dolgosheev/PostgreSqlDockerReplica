## postgres 13.2 (master-slave) in docker

Для теста поднято 2 debian сервера (со второй сетевкой в виде виртуального хоста)

*master* - 192.168.56.10
*slave* - 192.168.56.11

> root@srv~# nano /etc/network/interfaces
>
> auto enp0s8
> 
> iface enp0s8 inet static
> 
>       address 192.168.56.10
>       netmask 255.255.255.0

Действия на **master** (192.168.56.10)

Клонируем проект идем внутрь и если нужно меняем переменные
> nano .env

Далее идем внутрь
> cd ./ver13_2/master

И запускаем контейнер в режиме демона
> docker-compose up -d master

После успешного запуска нужно скопировать из контейнера данные для реплики
> sh get-backup.sh

Появится папка ./backup которую надо доставить на slave

Действия на **slave** (192.168.56.11)

Клонируем проект идем внутрь и если нужно меняем переменные
> nano .env

Далее идем внутрь
> cd ./ver13_2/slave

Создадим там папочку куда мы преешлем данные
> mkdir ./ver13_2/slave/data

Присвоим ей права юзера который умеет *давать по ssh*  * у меня alexander (у вас мб другой)
> chown alexander:alexander /usr/docker/ver13_2/slave/data

Действия на **master** (192.168.56.10)

Скопируем все для реплики с мастера
> scp -r ./backup alexander@192.168.56.11:/usr/docker/ver13_2/slave/data

Действия на **slave** (192.168.56.11)

Далее идем внутрь
> cd ./ver13_2/slave

И запускаем контейнер в режиме демона
> docker-compose up -d slave

#### Как проверить ?

Действия на **master** (192.168.56.10)

Идём в контейнер
> su postgres
> psql
> SELECT * FROM pg_replication_slots;

В графе active видим флажок t ( что означает true )

*наслаждаемся собой...*