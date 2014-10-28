import sys
import ssl
import socket

PORT = 9900

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    ssl_socket = ssl.wrap_socket(
            s,
            keyfile="server.key",
            certfile="server.crt",
            server_side=True,
            cert_reqs=ssl.CERT_REQUIRED,
            ca_certs="ca.crt",
            )

    ssl_socket.bind(("127.0.0.1", 9900))
    ssl_socket.listen(5)

    print "start accept"

    try:
        client, addr = ssl_socket.accept()
    except ssl.SSLError as e:
        print "ERROR:", e
        sys.exit(1)


    print "accept done..."
    client.send("OK")

    data = client.recv(100)
    print "recv data: "
    print data

    ssl_socket.close()

    print "finish"

main()

