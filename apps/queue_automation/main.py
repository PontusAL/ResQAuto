#!/usr/bin/env python3
import os
import sys

def main():
    name = "world"

    # very simple CLI parsing
    args = sys.argv[1:]
    if len(args) >= 2 and args[0] in ("--name", "-n"):
        name = args[1]
    elif len(args) == 1 and not args[0].startswith("-"):
        name = args[0]

    # env override (e.g., set by Docker/mac scripts)
    env_name = os.environ.get("QA_NAME")
    if env_name:
        name = env_name

    print(f"Hello, {name}!")
    return 0

if __name__ == "__main__":
    sys.exit(main())