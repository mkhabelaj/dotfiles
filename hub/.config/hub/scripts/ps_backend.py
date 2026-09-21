#!/usr/bin/env python3
"""hub `ps` backend plugin: herdr.

Usage: ps_backend.py {metaData|goto}

Contract with hub (see internal/plugin):

  metaData  print ONE JSON object to stdout: everything `goto` will need to find
            this instance again. hub stores it and hands it back to `goto`.
  goto      switch to the instance described by $HUB_META.

Rules:
  * stdout is reserved for metaData's JSON. Diagnostics go to stderr; hub shows
    stderr when a command fails.
  * `goto` runs from a *different* hub process (`hub ps`, in its own pane), so it
    may rely on $HUB_META only. Its own environment (HERDR_PANE_ID, ...) describes
    ps's pane, not the target's.
  * $HUB_META was written by a plugin and read back off disk: treat it as data.
    Pass it to programs as argv; never interpolate it into a shell string.

Env from hub: HUB_ID, HUB_PID, HUB_CWD, HUB_PATH (the instance), and HUB_META once
known. hub kills a plugin after ~2s, so keep under it.
"""

import json
import os
import subprocess
import sys

TIMEOUT = 1.5


def in_herdr() -> bool:
    return os.environ.get("HERDR_ENV") == "1" and bool(os.environ.get("HERDR_PANE_ID"))


def herdr(*args: str) -> None:
    subprocess.run(["herdr", *args], check=True, capture_output=True, text=True, timeout=TIMEOUT)


def metadata() -> int:
    data = dict()
    if in_herdr():
        data["h_pane"] = os.environ["HERDR_PANE_ID"]

    out = subprocess.run(["hyprctl", "activewindow ", "-j"], capture_output=True, text=True)
    dta = json.loads(out.stdout)
    data["hypr_pid"] = dta["pid"]

    json.dump(data, sys.stdout)
    return 0


def goto() -> int:
    try:
        pane = json.loads(os.environ.get("HUB_META", "")).get("pane")
    except (json.JSONDecodeError, AttributeError):
        pane = None
    if not pane:
        print("HUB_META missing or has no 'pane'", file=sys.stderr)
        return 1
    try:
        # Same call as the old built-in Herdr.Switch.
        herdr("pane", "zoom", "--pane", pane, "--off")
    except subprocess.CalledProcessError as e:
        print(f"herdr: {(e.stderr or '').strip()}", file=sys.stderr)
        return 1
    except subprocess.TimeoutExpired:
        print(f"herdr: timed out after {TIMEOUT}s", file=sys.stderr)
        return 1
    except FileNotFoundError:
        print("herdr binary not on PATH", file=sys.stderr)
        return 1
    return 0


COMMANDS = {"metaData": metadata, "goto": goto}

if __name__ == "__main__":
    fn = COMMANDS.get(sys.argv[1]) if len(sys.argv) == 2 else None
    if fn is None:
        print(__doc__, file=sys.stderr)
        sys.exit(2)
    sys.exit(fn())
