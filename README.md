# SvnReposForRedmine
Docker image for advanced integration with svn repository and redmine

使用Dockerfile构建Image。

```bash
docker build -t repository repository.Dockerfile
```

使用Image创建container。

```bash
docker-compose up -d
```

修改db的用户名、密码
- Apache2.conf.d/redmine.conf
- docker-compose.yml

生成并配置redmine webapi key
- cron.d/redmine