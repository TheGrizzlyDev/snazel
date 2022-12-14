def get_pid(repo_ctx):
    # A bit wonky since it assumes only a single running bazel instance
    return repo_ctx.execute(["/bin/bash", "-c", "pidof -s bazel"]).stdout

def get_tty(repo_ctx, pid):
    return "/dev/%s" % repo_ctx.execute([
        "/bin/bash", "-c", "ps -o tty= -q %s" % (pid),
    ]).stdout

def newlib(repo_ctx, settings):
    pixels = []
    ctx = {}
    pid = get_pid(repo_ctx)
    tty = get_tty(repo_ctx, pid)
    repo_ctx.file(
        "input_reader.sh",
        executable = True,
        content = """
#!/bin/bash

read -sn 1 -t .1 in < {tty}
printf $in
        """.strip().format(
            tty = tty,
        )
    )
    def set_px(x, y, c):
        pixels.append((x, y, c))
    def read():
        exec_res = repo_ctx.execute(["/bin/bash", "-c", repo_ctx.path("input_reader.sh")])
        input = exec_res.stdout.strip()
        if input != None and len(input) > 0:
            return input
        return None
    def get(key):
        return ctx[key]
    def set(key, val):
        ctx[key] = val
    def print(msg):
        repo_ctx.report_progress(msg)
    def flush():
        chars = {(x, y): c for x, y, c in pixels}
        out = ""
        for y in range(settings.h):
            for x in range(settings.w):
                cell = chars.setdefault((x, y), " ")
                out = out + cell
            out = out + "\n"
        print("\n\n%s\n\n%s\n\n" % (
            "Press w/a/s/d to move...",
            out,
        ))
        pixels.clear()
    def random(min, max):
        return int(repo_ctx.execute(["/bin/bash", "-c", "echo $RANDOM %% %s + %s | bc" % (max, min)]).stdout.strip())
    
    return struct(
        print=print,
        set_px=set_px,
        flush=flush,
        read=read,
        get=get,
        set=set,
        random=random,
    )