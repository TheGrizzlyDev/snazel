def newlib(repo_ctx, settings):
    pixels = []
    def set_px(x, y, c):
        pixels.append((x, y, c))
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
    )