load("loop.bzl", "loop")
load("lib.bzl", "newlib")

WIDTH = 20
HEIGHT = 20

def update(lib):
    dir = lib.get("direction")
    x, y = lib.get("position")
    if dir == "a":
        x = x-1
        if x < 0:
            x = WIDTH - 1
    if dir == "d":
        x = x + 1
        if x >= WIDTH:
            x = 0
    if dir == "w":
        y = y - 1
        if y < 0:
            y = HEIGHT - 1
    if dir == "s":
        y = y + 1
        if y >= HEIGHT:
            y = 0
    lib.set("position", (x, y))

def core_loop(lib):
    c = lib.read()
    if c in ["w", "a", "s", "d"]:
        lib.set("direction", c)

    update(lib)

    for x in range(WIDTH):
        for y in range(HEIGHT):
            lib.set_px(x, y, "🔳")

    player_x, player_y = lib.get("position")
    lib.set_px(player_x, player_y, "🟩")

    lib.flush()

def _main(repo_ctx):
    lib = newlib(repo_ctx, struct(
        w = 20,
        h = 20,
    ))
    lib.set("position", (0, 0))
    lib.set("direction", "s")
    loop(core_loop, lib)

main = repository_rule(
    _main
)