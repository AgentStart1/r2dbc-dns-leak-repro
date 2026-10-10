import java.io.OutputStream;
import java.net.ServerSocket;

public class TcpEndpoint {
    public static void main(String[] args) throws Exception {
        // No PostgreSQL protocol, credentials or SQL: only the network layer is tested.
        try (var listener = new ServerSocket(3333)) {
            while (true) {
                try (var connection = listener.accept()) {
                    connection.getInputStream().transferTo(OutputStream.nullOutputStream());
                }
            }
        }
    }
}
