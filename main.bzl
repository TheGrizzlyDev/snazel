load("loop.bzl", "loop")
load("lib.bzl", "newlib")

WIDTH = 20
HEIGHT = 20
UPDATE_EVERY_N_LOOPS = 4

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
    lib.set("old_direction", dir)

def core_loop(lib):
    c = lib.read()
    old_dir = lib.get("old_direction")

    if c == "w" and old_dir != "s":
        lib.set("direction", c)
    if c == "s" and old_dir != "w":
        lib.set("direction", c)
    if c == "a" and old_dir != "d":
        lib.set("direction", c)
    if c == "d" and old_dir != "a":
        lib.set("direction", c)

    iteration = lib.get("iteration")
    if iteration % UPDATE_EVERY_N_LOOPS == 0:
        update(lib)
    lib.set("iteration", iteration + 1)

    for x in range(WIDTH):
        for y in range(HEIGHT):
            lib.set_px(x, y, "⬛")

    player_x, player_y = lib.get("position")
    lib.set_px(player_x, player_y, "🟩")

    lib.flush()

def _main(repo_ctx):
    lib = newlib(repo_ctx, struct(
        w = WIDTH,
        h = HEIGHT,
    ))
    lib.set("position", (5, 0))
    lib.set("direction", "s")
    lib.set("old_direction", "s")
    lib.set("iteration", 0)
    loop(core_loop, lib)

main = repository_rule(
    _main
)