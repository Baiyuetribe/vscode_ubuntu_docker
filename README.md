# vscode-server for wsl

## RUN

```
docker run -itd -p 8443:8443 baiyuetribe/vscode-ubuntu-server
```

然后通过浏览器访问8443端口即可体验`vs-code` 。

## 特点：

- 以Ubuntu为基础镜像，支持自定义安装任意工具

- 支持安装vs-code插件

- 默认集成php开发环境

## 扩展

如何将vs-code-server扩展到已有的docker程序？

步骤：

构建一个镜像，Dockerfile内容如下：

```
FROM codercom/code-server as builder
#用于获取vs-code-server服务。

#从已有镜像构建
FROM 现成的docker镜像

# Copy code-server from builder image
COPY --from=builder /usr/local/bin/code-server /usr/local/bin/code-server

EXPOSE 8443 80

ENTRYPOINT ["dumb-init", "code-server"]

```
然后build后重新运行即可，对于多容器，请修改docker-compose.yml中的原始镜像后再次up即可。
