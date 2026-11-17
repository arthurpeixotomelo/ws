#!/usr/bin/env nu
use logger.nu *

def main [] {
    # 1. Parse metadata from stdin
    let ctx = ($in | from json)
    let workspace = ($ctx.workspacePaths? | default [] | first)
    let file_path = ($ctx.toolCall?.args?.Path? | default "")

    mut result_record = {
        exit_code: 0
        duration_ms: 0
        stdout: ""
        stderr: ""
    }

    if ($workspace != null and ($workspace | path exists)) {
        cd $workspace

        # Check if project has a package.json
        if ("package.json" | path exists) {
            let start = (date now)
            let res = try {
                # If target file exists, run lint:fix specifically on that file
                if ($file_path != "" and ($file_path | path exists)) {
                    ^pnpm lint:fix $file_path | complete
                } else {
                    ^pnpm lint:fix | complete
                }
            } catch { |err|
                { exit_code: 1, stdout: "", stderr: ($err | to text) }
            }
            let duration = (((date now) - $start) | into int) / 1_000_000

            $result_record = {
                exit_code: $res.exit_code
                duration_ms: ($duration | into int)
                stdout: $res.stdout
                stderr: $res.stderr
            }
        }
    }

    # Log structured hook telemetry
    try {
        log-hook --hook-name "lint-fix" --event-type "PostToolUse" --context $ctx --result $result_record
    } catch {
        # Never break hook on logging failure
    }

    # CRITICAL: PostToolUse stdout must be strictly an empty JSON object
    print "{}"
}
