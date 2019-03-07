# BaGet_Docker

### Build

```shell
git clone https://github.com/liyuqihxc/DockerLab.git
cd DockerLab/baget/dotnetcore
docker build baget:latest .
```

### Run

```shell
docker run --rm --name baget -d -p 8000:80/tcp -e ApiKey=APIKEY -v "${PWD}:/var/baget" baget:latest
```

Dockerfile中已设置环境变量:

```
Storage__Type="FileSystem"
Storage__Path="${BAGET_DIR}/packages"
Database__Type="Sqlite"
Database__ConnectionString="Data Source=${BAGET_DIR}/baget.db"
Search__Type="Database"
Mirror__Enabled="true"
```

BaGet文档：[https://loic-sharma.github.io/BaGet/](https://loic-sharma.github.io/BaGet/)
