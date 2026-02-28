#!/usr/bin/env python3

import json
import subprocess
import sys
from datetime import datetime, timedelta


def fetch_data(days):
    since = (datetime.now() - timedelta(days=days)).strftime("%Y%m%d")
    result = subprocess.run(
        ["bunx", "ccusage", "--json", "--breakdown", "--since", since],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"ccusage failed: {result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return json.loads(result.stdout)


def main():
    days = int(sys.argv[1]) if len(sys.argv) > 1 else 14
    data = fetch_data(days)

    entries = data.get("daily", [])
    if not entries:
        print(f"No usage data in the last {days} days.")
        return

    first = datetime.strptime(entries[0]["date"], "%Y-%m-%d")
    last = datetime.strptime(entries[-1]["date"], "%Y-%m-%d")
    by_date = {e["date"]: e for e in entries}

    all_days = []
    current = first
    while current <= last:
        all_days.append(current.strftime("%Y-%m-%d"))
        current += timedelta(days=1)

    max_cost = max((e["totalCost"] for e in entries), default=1)
    bar_width = 40
    total = 0
    model_costs = {}

    print(f"\n  Claude Code costs — last {days} days")
    print(f"  {'─' * 72}")

    for day in all_days:
        entry = by_date.get(day)
        cost = entry["totalCost"] if entry else 0
        total += cost
        tok = entry["totalTokens"] if entry else 0

        if entry:
            for mb in entry.get("modelBreakdowns", []):
                name = mb["modelName"]
                model_costs[name] = model_costs.get(name, 0) + mb["cost"]

        filled = int((cost / max_cost) * bar_width) if max_cost > 0 else 0
        bar = "█" * filled + "░" * (bar_width - filled)

        dt = datetime.strptime(day, "%Y-%m-%d")
        dow = dt.strftime("%a")
        tok_str = f"{tok / 1000:.0f}k tok" if tok > 0 else ""

        print(f"  {day} {dow}  {bar} ${cost:7.2f}  {tok_str}")

    print(f"  {'─' * 72}")
    print(f"  {'Total':>56s}  ${total:7.2f}")

    avg = total / len(all_days) if all_days else 0
    print(f"  {'Daily avg':>56s}  ${avg:7.2f}")

    if model_costs:
        print(f"\n  By model:")
        for model, cost in sorted(model_costs.items(), key=lambda x: -x[1]):
            pct = (cost / total) * 100 if total > 0 else 0
            print(f"    {model:<40s} ${cost:7.2f}  ({pct:.0f}%)")

    print()


if __name__ == "__main__":
    main()
