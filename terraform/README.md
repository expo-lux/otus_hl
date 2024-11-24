Манифесты создают в Yandex Cloud:
- облачную сеть `otus-hl-vpc-1` с подсетью `otus-hl-subnet-1`
- загрузочный диск `otus-hl-disk-1` с использованием образа из переменной `image_id`
- на основе созданных ранее ресурсов создается ВМ `otus-hl-vm-1` с внутренним и внешним IP
- в ВМ создается пользователь `ansible-user` с правами sudo, параметры пользователя лежат в meta.txt (механизм создания пользователей описан в https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#users)
- с помощью рецепта описанного в https://otus.ru/nest/post/118/ к ВМ подключается ansible, который выполняет playbook provision.yml и накатывает роль `nginx`
- после установки `nginx` накатывается роль `smoke_test` для проверки развертывания

PS

`personal.auto.tfvars` - файл с секретными данными Yandex Cloud (token, folder_id, cloud_id), добавлен в gitignore
`meta.txt/users/ssh_authorized_keys` - публичный(ые) ssh-ключ, добавляется в authorized_keys пользователя ansible-user
`variables.tf/ssh_key_private` - путь к приватному ssh-ключу

Информация по провайдеру Yandex Cloud для terraform https://terraform-provider.yandexcloud.net/