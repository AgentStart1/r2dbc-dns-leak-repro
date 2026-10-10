import socket

# No PostgreSQL protocol, credentials or SQL: only the driver's network layer is tested.
with socket.socket() as listener:
    listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    listener.bind(("0.0.0.0", 3333))
    listener.listen()
    while True:
        connection, _ = listener.accept()
        with connection:
            while connection.recv(4096):
                pass
