# Captured comparison

Captured on 2026-10-10 using the commands in README.md. Both versions ran in separate Linux containers. The UDP4 baseline was 1 in each container; it stayed unchanged. Only 1.1.3 grew UDP6 from 0 to 30. The printed JAR path verifies the driver selection.

| Closed connections | 1.1.2 UDP6 | 1.1.3 UDP6 |
|---:|---:|---:|
| 0 | 0 | 0 |
| 5 | 0 | 5 |
| 10 | 0 | 10 |
| 15 | 0 | 15 |
| 20 | 0 | 20 |
| 25 | 0 | 25 |
| 30 | 0 | 30 |
| After GC request | 0 | 30 |

The dependency trees record fixed Reactor Netty, Reactor Core and Netty versions. Tests exercise the driver network layer only, without authentication or SQL.
