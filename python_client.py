import ssl
import socket

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    ssl_socket = ssl.wrap_socket(
            s,
            keyfile="server.key",
            certfile="server.crt",
            server_side=False,
            cert_reqs=ssl.CERT_NONE,
            )

    ssl_socket.connect(("127.0.0.1", 9900))
    ssl_socket.send("CONNECT OK")
    print ssl_socket.recv(64)
    ssl_socket.close()
    print "finish"


main()

