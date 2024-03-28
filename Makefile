HTTP:
	cd server/http && go run main.go
HTTPS:
	cd server/https go run main.go
RUN:
	zig build && ./zig-out/bin/ja3-spoof
C:
	gcc src/*.c src/c/*.c -lcurl && ./a.out