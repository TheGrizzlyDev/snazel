load("loop.bzl", "loop")
load("lib.bzl", "newlib")

WIDTH = 20
HEIGHT = 20

def core_loop(lib):
    for x in range(WIDTH):
        for y in range(HEIGHT):
            lib.set_px(x, y, "🟢")

    if lib.read() == 'a':
        for x in range(WIDTH):
            for y in range(HEIGHT):
                lib.set_px(x, y, "A")
    lib.flush()

def _main(repo_ctx):
    loop(core_loop, newlib(repo_ctx, struct(
        w = 20,
        h = 20,
    )))

main = repository_rule(
    _main
)