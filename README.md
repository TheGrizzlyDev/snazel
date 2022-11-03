# 🐍 Snazel

Snazel is an implementation of snake in a bazel workspace. Yup, nothing more, nothing less and might crash your terminal. In fact, it is very likely to and I don't have the mental energy necessary to figure out why.

## Prerequisites

- Bazel, duh
- Some linux distro, I've only tested this on whatever ubuntu version I am running on. If you want to add support for other platforms, start by reconsidering your life choices and what led you down this path and if you still feel like doing it, then send a PR.

## How to run

Run with `bazel run @snake//...` in a terminal and then use w/a/s/d to move

## Leaderboard

If you get a high score, share it on https://github.com/TheGrizzlyDev/snazel/issues/1

## Why?

Well, I was having a beer with a friend and as one does, we started talking about bazel and we were asking ourselves if it'd be possible to run Doom on it. Not only was I convinced it was possible, but I also thought you could write it directly in starlark. I did though not have the time, nor the patience, nor the skills needed to rewrite Doom (but if you do, please contact me) so I settled for the next best thing: writing snake in bazel.

Driven by beer and sleep deprevation Snazel came to life and here we are :)

## Contributing

Why would you? Seriously! But if you really want to, just send a PR, no guidelines, no strings attached and I'll probably merge without reviewing, you literally can't make this any worse.
