# AGENTS Instructions

This repository stores a terminal log (`warp_terminal_log.txt`) that must be processed in discrete jobs. Each job extracts code blocks from a specific line range.

## Workflow

1. Run `scripts/extract_blocks.py` with `--start`, `--end`, and `--job` arguments.
   Example:
   ```bash
   python scripts/extract_blocks.py warp_terminal_log.txt --start 1 --end 200 --job 1
   ```
2. The script prints all code blocks found in the range, grouped by filename if one can be detected. Unnamed blocks are labeled `[UNASSIGNED L<start>-<end>]`.
3. After the blocks, the script outputs the job summary with the next start and end line numbers. Use these values for the subsequent run.
4. Continue launching the script with updated ranges until the log is fully processed. When the script reports `Job COMPLETE`, all lines have been handled.

## Development Guidelines

- Keep commits focused and descriptive.
- Maintain code formatting using your preferred tools.
ignore `bmad'
