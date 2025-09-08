#!/usr/bin/env python3
import sys
from apps.queue_automation.http_utils import heartbeat


def main():
    # Hello world
    print("Hello world!")
    # Heartbeat
    result = heartbeat()
    if result["ok"]:
        print(f"Heartbeat OK. Server replied with url={result['url']} origin={result['origin']}")
    else:
        print("Heartbeat failed:", result["error"])
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())