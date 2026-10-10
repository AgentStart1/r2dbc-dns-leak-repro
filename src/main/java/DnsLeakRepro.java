import io.r2dbc.postgresql.client.ReactorNettyClient;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;

public class DnsLeakRepro {
    private static long sockets(String file) throws Exception {
        try (var lines = Files.lines(Path.of(file))) {
            return lines.skip(1).filter(line -> !line.isBlank()).count();
        }
    }

    private static void print(String phase) throws Exception {
        System.out.printf("%s udp4=%d udp6=%d%n", phase,
                sockets("/proc/net/udp"), sockets("/proc/net/udp6"));
    }

    public static void main(String[] args) throws Exception {
        System.out.println("driver=" + ReactorNettyClient.class.getProtectionDomain()
                .getCodeSource().getLocation());
        print("baseline");
        for (int i = 1; i <= 30; i++) {
            var client = ReactorNettyClient.connect("endpoint", 3333)
                    .block(Duration.ofSeconds(5));
            if (client == null) throw new IllegalStateException("No client returned");
            client.close().block(Duration.ofSeconds(5));
            if (i % 5 == 0) print("connections_closed=" + i);
        }
        System.gc();
        print("after_gc");
    }
}
