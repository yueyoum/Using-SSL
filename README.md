# 如何使用SSL

### 运行 `./create.sh` 得到证书文件.

创建ca.crt 的时候所有提问都可以留空.
但第二部的 server.csr 的时候 Common Name 必须用完全的域名.

如果是用于自己的应用，并不是用作公共服务，这个域名可以胡乱填写.
client连接server的时候不去验证即可


### Example: SSL SOCKET

ssl socket 的例子都是 server 要验证 client 的，
也就是只有持有合法证书的client，server才接受连接

目前提供了erlang和python实现的 server/client 例子。

### Example: Nginx

见nginx.ssl.conf 配置文件，这样便使得nginx在 4430 端口接受 https 链接，
并且验证客户端

Python 客户端例子:

```python
import requests
requests.get("https://127.0.0.1:4430", verify=False, cert="client.pem")
```

浏览器 在设置中载入生成p12证书。

如何生成 p12 证书:

```bash
openssl pkcs12 -export -in server.crt -inkey server.key -out client.p12 -name "xxx"
```

