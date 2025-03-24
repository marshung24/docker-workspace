# 本地開發範本 Docker Compose ＋ DevContainer
使用 Docker Compose 與 Dev Container 建立本地開發範本，供需要的人參考引用。

## 安裝容器開發插件 Dev Container
- `Visual Studio Code`安裝插件`Dev Containers`
- 按左下角 or 快速鍵：
  - 在容器中重新開啟： `control` + `command` + `c`
  - 在區域重新開啟資料夾： `control` + `command` + `l`
  - 在容器中重建而不使用快取，然後重新開啟: `需自定快速鍵`


## 手動啟動 docker compose
```sh
# 啟動 Docker Compose - 使用 docker-compose-mac.yaml 
$ docker-compose -f docker-compose-mac.yaml up -d --build
```
> `-d`: 背景服務模式
> `--build`: 強制重建容器(如果需要build)


## 手動關閉 docker compose
```sh
$ docker-compose -f docker-compose-mac.yaml down
```


## 參考資料
- [Docker-LNMP-Mars](https://github.com/marshung24/Docker-LNMP-Mars)
- [VSCode-DevContainer](https://code.visualstudio.com/docs/devcontainers/containers)


