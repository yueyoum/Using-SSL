#!/bin/bash

DAYS=3650
GEN_CLIENT=1

# reference: http://svn.red-bean.com/repos/main/3bits/servercert_3bits.txt
# reference: http://seanlook.com/2015/01/18/openssl-self-sign-ca/

# CA 证书
echo "==== GEN CA ===="
openssl genrsa -out ca.key 1024

# 使用上面的密钥创建一个自签署的CA根证书
# 所有的问题都可以留空
openssl req -new -x509 -days $DAYS -key ca.key -out ca.crt

# 服务器 证书
echo "==== GEN SERVER ===="
openssl genrsa -out server.key 1024

# 生成证书签署请求CSR （这个是用于发送到CA中心等待签发的）
openssl req -new -key server.key -out server.csr

# 但我们用上面的CA证书 (ca.crt) 对 server.csr 进行签发
# Common Name 这个要填写 完整域名
openssl x509 -req -days $DAYS -in server.csr -CA ca.crt \
    -CAkey ca.key -CAcreateserial -out server.crt


# 上面生成的 server.crt 是公钥，server.key 是密钥


# 如果要验证客户端，那么还要生成客户端文件

if [[ $GEN_CLIENT == 1 ]]
then
	echo "==== GEN CLIENT ===="
	openssl genrsa -out client.key 1024
	openssl req -new -key client.key -out client.csr
	openssl x509 -req -days $DAYS -in client.csr -CA ca.crt \
    		-CAkey ca.key -CAcreateserial -out client.crt
	openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12
fi

# 上面生成的 p12 文件是给 浏览器用的

# 清理
rm -f ca.key
rm -f ca.srl
rm -f *.csr


# Nginx 配置
#server {
#  listen 443 ssl;
#
#  ssl_certificate /PATH/server.crt;
#  ssl_certificate_key /PATH/server.key;
#  # 下面两个只有验证客户端的时候才需要
#  ssl_client_certificate /PATH/ca.crt;
#  ssl_verify_client on;
#
#  ssl_session_cache shared:SSL:10m;
#
#  location / {
#    return 404;
#  }
#}
#
#
# 对于需要验证客户端的请求， python requests 要这么做
# NOTE: client.crt 要放到前面
# requests.get(URL, verify=False, cert=("client.crt", "client.key"))
#
#
#
# # Erlang, Server
# #
# # Create a SSL socket, and verify client
# application:ensure_all_started(ssl).
# {ok, LSock} = ssl:listen(Port, [{certfile, "server.crt"},
#                                 {keyfile, "server.key"},
#                                 {cacertfile, "ca.crt"},
#                                 {verify, verify_peer},
#                                 {fail_if_no_peer_cert, true}],
# # Transport accept
# {ok, Socket} = ssl:transport_accept(LSock),
#
# # Do hand shake. This may return {error, Reason}
# ok = ssl:ssl_accept(Socket)
#
#
# # Erlang, Client
# application:ensure_all_started(ssl).
# {ok, Socket} = ssl:connect(Host, Port, [{certfile, "client.crt"},
#                                         {keyfile, "client.key"}]).


