import argparse
import os
import re
from collections import defaultdict

# Match code fence lines that may be prefixed with '+' characters from diff
BLOCK_RE = re.compile(r"^\+*```(.*)")
FILE_HINT_RE = re.compile(r"^[+]*\+\+\+\s+(.*)")


def parse_args():
    p = argparse.ArgumentParser(description="Extract code blocks from log file")
    p.add_argument("logfile", help="Path to terminal log")
    p.add_argument("--start", type=int, required=True, help="Start line number (1-indexed)")
    p.add_argument("--end", type=int, required=True, help="End line number (inclusive)")
    p.add_argument("--job", type=int, required=True, help="Job index")
    return p.parse_args()


def load_lines(path):
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        return f.readlines()


def extract_blocks(lines, start, end):
    results = defaultdict(list)
    in_block = False
    block_lines = []
    file_hint = None
    block_file = None
    block_start = start

    for idx in range(start - 1, end):
        line = lines[idx]
        line_no = idx + 1
        file_hint_match = FILE_HINT_RE.match(line)
        if file_hint_match:
            file_hint = file_hint_match.group(1).strip()

        m = BLOCK_RE.match(line.strip())
        if m:
            header = m.group(1).strip()
            if not in_block:
                in_block = True
                block_lines = [line.rstrip("\n")]
                block_start = line_no
                parts = header.split()
                if len(parts) > 1:
                    block_file = " ".join(parts[1:])
                elif parts and ("/" in parts[0] or "\\" in parts[0]):
                    block_file = parts[0]
                else:
                    block_file = file_hint
            else:
                block_lines.append(line.rstrip("\n"))
                key = block_file or f"[UNASSIGNED L{block_start}-{line_no}]"
                results[key].append("\n".join(block_lines))
                in_block = False
                block_lines = []
                block_file = None
        else:
            if in_block:
                block_lines.append(line.rstrip("\n"))

    if in_block:
        key = block_file or f"[UNASSIGNED L{block_start}-{end}]"
        results[key].append("\n".join(block_lines))

    return results


def main():
    args = parse_args()
    lines = load_lines(args.logfile)
    total_lines = len(lines)
    end = min(args.end, total_lines)
    blocks = extract_blocks(lines, args.start, end)

    for fname, blist in blocks.items():
        print(f"# {fname}")
        for b in blist:
            print(b)
            print()

    print(f"Job {args.job}")
    print(f"Lines processed: {end - args.start + 1}")
    next_start = end + 1
    next_end = next_start + (args.end - args.start)
    if next_start > total_lines:
        print("Job COMPLETE")
    else:
        print(f"Next start: {next_start}")
        print(f"Next end: {next_end if next_end <= total_lines else total_lines}")


if __name__ == "__main__":
    main()
