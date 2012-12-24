# TransmissionRemote

---

TransmissionRemote - Cocoa OS X (10.8) RPC клиент для управления удаленным сервером [Transmission][transmission].

Назначение приложения - это управление сервером [Transmission][transmission] с минималистичным интерфейсом и приоритетом на минимальное количество траффика между приложением и сервером по протоколу [RPC][rpcwiki].

## Актуальные проблемы
### Просмотр списка торрентов
#### Информация

1. Информации сервера:

  * Состояние подключения
  * Версия торрент сервера
  * Количество торрентов
  * Количество активных торрентов
  * Скорость скачивания и раздачи всех торрентов
  * Статус режима альтернативной скорости

2. Информации о торренте:

  * Название
  * Статус
    1. Включен/Активный (загружается или раздается)
    2. Включен/Не активный (не загружается и не раздается)
    3. Остановлен
    4. Ошибка
  * Рейтинг(коэффициент загрузка/раздача)
  * Скорость скачивания и раздачи
  * Размер
  * Процент выполнения операции
  * Приоритет
  * Приблизительное время окончания загрузки
  * Позиция в очереди
  * Перечень файлов торрента
  * Приоритет файла торрента
  * Размер файла торрента
  * Процент загрузки файла торрента

#### Поиск

Поиск по следующим критериям:

* Название
* Статус

### Подключение к серверу

Для подключения к серверу необходима следующая информация:

* Адрес сервера
* Порт сервера
* SSL соединение
* Учетные данные (логин, пароль)

### Управление сервером

* Изменение режима альтернативной скорости

### Управление торрентами

Ниже приведен перечень требований к операциям:

#### Добавление

* Добавление торрента с помощью открытия .torrent файла
  * Удаление добавленного .torrent файла
* Добавление торрента с помощью указания url ссылки на .torrent файл
* Автоматический старт торрента
* Выбор приоритета при добавлении торрента
* Выбор перечня загружаемых файлов для торрента
* Выбор приоритета для загружаемых файлов торрента
* Выбор каталога для загружаемых файлов торрента

#### Изменение

* Изменение приоритета торрента
* Изменение каталога для загружаемых данных торрента с их перемещением
* Изменение перечня загружаемых файлов для торрента
* Изменение приоритета для загружаемых файлов торрента

#### Удаление

* Удаление торрента без удаления файлов торрента
* Удаление загруженых файлов торрента


## Интерфейс

Основное окно:

![Основное окно программы][mainwindow]

Настройки программы (`⌘ + ,`):

![Окно настроек подключения][options]

Управление торрент файлами:

![Меню управления][menu]

## Альтернативные продукты

* [transmisson-remote-gui](http://code.google.com/p/transmisson-remote-gui)
* [transmission-remote-java](http://sourceforge.net/projects/transmission-rj)

Основная причина создания нового клиента это не нативность интерфейса существующих клиентов, и их перегруженость в плане информации.

## Материалы

* [Спецификация протокола RPC][rpcspec]
* Были использованы некоторые ресурсы из официального приложения [Transmission][transmission] (доступны по лицензии MIT).

[transmission]: http://transmissionbt.com
[rpcwiki]: http://ru.wikipedia.org/wiki/Remote_Procedure_Call
[mainwindow]: https://raw.github.com/TurchenkoAlex/osx-project-2/master/screenshots/mainwindow.png
[menu]: https://raw.github.com/TurchenkoAlex/osx-project-2/master/screenshots/menu.png
[options]: https://raw.github.com/TurchenkoAlex/osx-project-2/master/screenshots/options.png
[rpcspec]: https://raw.github.com/TurchenkoAlex/osx-project-3/master/rpc-spec.txt
