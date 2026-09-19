#!/usr/bin/env python3
"""Searchable, annotated Herdr keybinding menu (Learn > Herdr, SUPER+CTRL+K).

The actions and their default keys come from `herdr --default-config`, your
config.toml overrides them, and herdr-learn.toml (next to this script) only adds
descriptions, groups and tmux hints. Needs python >= 3.11 (tomllib).

  herdr-learn.py           open the picker (omarchy-menu-select)
  herdr-learn.py --print   print the rows (icon<TAB>label<TAB>subtext)
  herdr-learn.py --check   list actions missing a description; exit 1 if any
"""

import json
import os
import re
import subprocess
import sys
import tomllib
from pathlib import Path

HERE = Path(__file__).resolve().parent
LEARN_FILE = HERE / "herdr-learn.toml"
USER_CONFIG = Path(
    os.environ.get("HERDR_CONFIG_PATH")
    or Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config") / "herdr" / "config.toml"
)

QUOTED = r'"([^"]*)"'
VALUE = rf'(?:{QUOTED}|\[(?:\s*{QUOTED}\s*,?)*\s*\])'
ASSIGNMENT = re.compile(rf"^([a-z_]+)\s*=\s*({VALUE})\s*(?:#.*)?$")


def load_defaults():
    """Return {action: binding-string} in herdr's own order, from --default-config."""
    try:
        text = subprocess.run(
            ["herdr", "--default-config"], capture_output=True, text=True, check=True
        ).stdout
    except (OSError, subprocess.CalledProcessError) as err:
        sys.exit(f"herdr-learn: cannot read `herdr --default-config`: {err}")

    actions = {}
    in_keys = False
    for line in text.splitlines():
        # Every default line is commented out, section markers included.
        line = re.sub(r"^\s*#\s?", "", line).rstrip()
        if line.startswith("[["):
            in_keys = False
        elif line.startswith("["):
            in_keys = line.startswith("[keys]")
        elif in_keys:
            match = ASSIGNMENT.match(line)
            if match:
                actions[match.group(1)] = re.findall(QUOTED, match.group(2))
    return actions


def load_toml(path):
    try:
        with open(path, "rb") as handle:
            return tomllib.load(handle)
    except FileNotFoundError:
        return {}
    except tomllib.TOMLDecodeError as err:
        sys.exit(f"herdr-learn: {path}: {err}")


def key_text(key):
    return " + ".join(part.upper() for part in key.split("+"))


def combo_text(action, keys):
    combo = " / ".join(key_text(key) for key in keys if key)
    if combo and action.startswith("navigate_"):
        combo = f"NAVIGATE + {combo}"
    return combo


def humanize(action):
    text = re.sub(r"^navigate_", "", action).replace("_", " ")
    return text[:1].upper() + text[1:]


def effective_bindings(defaults, user_keys):
    """Defaults overridden by config.toml. An empty binding means unbound."""
    bindings = dict(defaults)
    for action, value in user_keys.items():
        if isinstance(value, str):
            bindings[action] = [value]
        elif isinstance(value, list) and all(isinstance(v, str) for v in value):
            bindings[action] = value
    return bindings


def build_rows(learn, bindings, custom_commands):
    groups = learn.get("groups", {})
    described = learn.get("actions", {})
    custom_meta = learn.get("custom", {})

    def group_of(name):
        return name if name in groups else "other"

    entries = []  # (group order, sequence, icon, label, subtext)
    for seq, (action, keys) in enumerate(bindings.items()):
        combo = combo_text(action, keys)
        if not combo:
            continue  # unbound
        meta = described.get(action, {})
        entries.append((group_of(meta.get("group", "other")), seq, combo, humanize(action), meta))

    base = len(entries)
    for offset, command in enumerate(custom_commands):
        key = command.get("key", "")
        meta = custom_meta.get(key, {})
        name = meta.get("name") or command.get("command", "custom command")
        entries.append((group_of(meta.get("group", "other")), base + offset, key_text(key), name, meta))

    def sort_key(entry):
        group = entry[0]
        return (groups.get(group, {}).get("order", 99), entry[1])

    rows = []
    for group, _, combo, name, meta in sorted(entries, key=sort_key):
        icon = groups.get(group, {}).get("icon", "")
        subtext = meta.get("desc", "")
        if meta.get("tmux"):
            subtext = f"{subtext}  ·  tmux: {meta['tmux']}" if subtext else f"tmux: {meta['tmux']}"
        label = f"{combo:<32} → {name}"
        rows.append("\t".join(part.replace("\t", " ") for part in (icon, label, subtext)))
    return rows


def check(learn, bindings, custom_commands):
    described = set(learn.get("actions", {}))
    known = set(bindings)
    missing = sorted(known - described)
    stale = sorted(described - known)
    custom = set(learn.get("custom", {}))
    missing_custom = sorted(c.get("key", "") for c in custom_commands if c.get("key", "") not in custom)

    for action in missing:
        print(f"missing description: [actions.{action}]")
    for key in missing_custom:
        print(f'missing description: [custom."{key}"]')
    for action in stale:
        print(f"stale (herdr no longer has it): [actions.{action}]")
    if not (missing or stale or missing_custom):
        print(f"ok: {len(known)} actions and {len(custom_commands)} custom keys described")
    return 1 if (missing or missing_custom) else 0


def focused_monitor_height():
    try:
        monitors = json.loads(
            subprocess.run(["hyprctl", "monitors", "-j"], capture_output=True, text=True, check=True).stdout
        )
        height = next(m["height"] for m in monitors if m.get("focused"))
        return height if height > 0 else 900
    except (OSError, subprocess.CalledProcessError, ValueError, StopIteration, KeyError):
        return 900


def main():
    args = sys.argv[1:]
    if any(arg not in ("--print", "-p", "--check") for arg in args):
        sys.exit(__doc__)

    learn = load_toml(LEARN_FILE)
    user = load_toml(USER_CONFIG)  # no config: herdr runs on its own defaults
    user_keys = user.get("keys", {})
    custom_commands = user_keys.get("command", [])
    bindings = effective_bindings(load_defaults(), user_keys)

    if "--check" in args:
        sys.exit(check(learn, bindings, custom_commands))

    rows = build_rows(learn, bindings, custom_commands)
    if "--print" in args or "-p" in args:
        print("\n".join(rows))
        return

    subprocess.run(
        ["omarchy-menu-select", "Herdr", "--", "--width", "800", "--height", str(focused_monitor_height() * 40 // 100)],
        input="\n".join(rows) + "\n",
        text=True,
        encoding="utf-8",
        stdout=subprocess.DEVNULL,
    )


if __name__ == "__main__":
    main()
