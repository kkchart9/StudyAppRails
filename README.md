# README
## migrationファイルをいじったときの対処法

### migrationファイルを追加した場合
```azure
heroku run rails db:migrate
```
### migrationファイルを書き換えた場合
```azure
heroku pg:reset -a mighty-tor-40228
heroku run rails db:migrate
heroku run rails db:seed
```