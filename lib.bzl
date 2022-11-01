def get_pid(repo_ctx):
    # A bit wonky since it assumes only a single running bazel instance
    return repo_ctx.execute(["/bin/bash", "-c", "pidof -s bazel"]).stdout

def get_tty(repo_ctx, pid):
    return "/dev/%s" % repo_ctx.execute([
        "/bin/bash", "-c", "ps -o tty= -q %s" % (pid),
    ]).stdout

def newlib(repo_ctx, settings):
    pixels = []
    pid = get_pid(repo_ctx)
    tty = get_tty(repo_ctx, pid)
    def set_px(x, y, c):
        pixels.append((x, y, c))
    def read():
        exec_result = repo_ctx.execute(["/bin/bash", "-c", "read -i 'nope' -n 1 -t 10 in < %s && echo $in" % (tty)])
        repo_ctx.report_progress("Test %s %s" % (tty, exec_result.stdout))
    def flush():
        chars = {(x, y): c for x, y, c in pixels}
        out = ""
        for x in range(settings.w):
            for y in range(settings.h):
                cell = chars.setdefault((x, y), " ")
                out = out + cell
            out = out + "\n"
        repo_ctx.report_progress("\n\n%s\n\n" % out)
        pixels.clear()
    return struct(
        print=print,
        set_px=set_px,
        flush=flush,
        read=read,
    )