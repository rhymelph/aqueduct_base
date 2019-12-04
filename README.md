# aqueduct_base

## 项目配置
- `config.yaml` 设置文件配置数据库及端口号相关信息，
- `database.yaml` 数据库升级使用的配置

## 开始

- 1.使用命令`aqueduct db generate`生成数据库版本文件

- 2.使用命令`aqueduct db upgrade`将你的版本文件同步到数据库

- 3.使用命令`aqueduct auth add-client --id com.rhyme.web --secret 123456`生成授权客户端，（--id 你的客户端id --secret 你的密钥）

- 4.请求`登录`，`注册`和`刷新token`时，必须在请求头添加`authorization: Basic base64(id:secret)`进行请求，否则出现无效客户端

- 5.使用命令`dart --observe bin/main.dart`运行项目
## 目前已实现
- [o]用户登录
- [o]用户注册
- [o]忘记密码
- [o]刷新token
- [o]授权访问

## 后续开发

- 微信订阅号：`Dart客栈`

- 请关注我的：[简书](https://www.jianshu.com/u/0c89c7e04e7a)


## ChANGE_LOG

- 2019.12.04：添加不同颜色的log输出
- 2019.12.04：统一错误码
