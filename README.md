## TTL/SSL JA3 Spoof

<img src="https://raw.githubusercontent.com/ziglang/logo/9d06c090ca39ef66019a639241ea2d7e448b9fe1/ziggy.svg" width="300">

**A curl-based zig http client that can spoof [tls/ssl ja3](https://github.com/salesforce/ja3)**

### 📦 Installing

#### 1. Install ja3_spoof
```
zig fetch --save https://github.com/blockkwork/ja3-spoof/archive/refs/tags/[LATEST TAG].tar.gz
```
Example
```
zig fetch --save https://github.com/blockkwork/ja3-spoof/archive/refs/tags/0.0.1.tar.gz
```

#### 2. Add ja3_spoof to build.zig
Add to build.zig
```zig
const ja3_spoof = b.dependency("ja3_spoof", .{}).module("ja3_spoof");
exe.root_module.addImport("ja3_spoof", ja3_spoof);
```


### 🚀 Examples
Example in ./examples folder 

 Run with command: 
```
make EXAMPLE
```

```zig
const client = ja3_spoof.init(.{
        .allocator = allocator,
        .custom_cookies = "Cookie",
        .custom_user_agent = "ja3 spoof",
        .custom_ciphers = "AES256-SHA",
}) catch |err| {
        std.debug.print("error: {}\n", .{err});
        return;
};

const response = client.send("https://tools.scrapfly.io/api/tls") catch |err| {
        std.debug.print("error: {}\n", .{err});
        return;
};

std.debug.print("status_code: {}\nresponse: {s}\n", .{ response.status_code, response.response });
```



### 🛡️ Spoofing
To spoof ja3 you need to change .custom_ciphers to any other in Client Options
