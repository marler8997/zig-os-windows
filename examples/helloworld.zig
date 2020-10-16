usingnamespace @import("windows").everything;

pub export fn WinMainCRTStartup() callconv(.Stdcall) u8 {
    // TODO: call getstdhandle and writefile
    const hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
    if (hStdOut == INVALID_HANDLE_VALUE) {
        //std.debug.warn("Error: GetStdHandle failed with {}\n", .{GetLastError()});
        return 0xff; // fail
    }
    writeAll(hStdOut, "Hello, World!") catch return 0xff; // fail
    return 0; // success
}

fn writeAll(hFile: HANDLE, buffer: []const u8) !void {
    var written : usize = 0;
    while (written < buffer.len) {
        const next_write = @intCast(DWORD, 0xFFFFFFFF & (buffer.len - written));
        var last_written : DWORD = undefined;
        if (1 != WriteFile(hFile, @intToPtr([*]u8, @ptrToInt(buffer.ptr + written)), next_write, &last_written, null)) {
            // TODO: return from GetLastError
            return error.WriteFileFailed;
        }
        written += last_written;
    }
}
