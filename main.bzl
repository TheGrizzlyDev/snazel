load("loop.bzl", "loop")
load("lib.bzl", "newlib")

WIDTH = 20
HEIGHT = 20

state = {}
state["pos"] = (0, 0)
state["direction"] = "s"

def update(lib):
    dir = state["direction"]
    x, y = state["pos"]
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
    state["pos"] = (x, y)

def core_loop(lib):
    c = lib.read()
    if c in ["w", "a", "s", "d"]:
        state["direction"] = c

    update(lib)

    for x in range(WIDTH):
        for y in range(HEIGHT):
            lib.set_px(x, y, "🔳")

    player_x, player_y = state["pos"]
    lib.set_px(player_x, player_y, "🟩")

    lib.flush()

def _main(repo_ctx):
    loop(core_loop, newlib(repo_ctx, struct(
        w = 20,
        h = 20,
    )))

main = repository_rule(
    _main
)