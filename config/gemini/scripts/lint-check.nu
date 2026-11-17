#!/usr/bin/env nu
use logger.nu *

def main [] {
    # 1. Parse metadata from stdin
    let ctx = ($in | from json)
    let workspace = ($ctx.workspacePaths? | default [] | first)

    if ($workspace == null or not ($workspace | path exists) or not ("package.json" | path exists)) {
        # Not a project workspace with package.json; allow normal termination
        print ({ injectSteps: [], terminationBehavior: "" } | to json -r)
        return
    }

    cd $workspace

    # 2. Run lint check and capture output
    let start = (date now)
    let result = (do -i { ^pnpm lint } | complete)
    let duration = (((date now) - $start) | into int) / 1_000_000

    let result_record = {
        exit_code: $result.exit_code
        duration_ms: ($duration | into int)
        stdout: $result.stdout
        stderr: $result.stderr
    }

    # Log structured hook telemetry
    try {
        log-hook --hook-name "lint-check" --event-type "PostInvocation" --context $ctx --result $result_record
    } catch {
        # Never break hook on logging failure
    }

    if ($result.exit_code == 0) {
        # Lint passed cleanly -> allow agent to finish
        print ({
            injectSteps: [],
            terminationBehavior: ""
        } | to json -r)
    } else {
        # Lint failed -> inject errors and force the agent to fix them
        let lint_output = ($result.stdout + "\n" + $result.stderr | str trim)

        print ({
            injectSteps: [
                {
                    systemMessage: {
                        systemMessage: $"Linter found issues that must be fixed before finishing:\n\n($lint_output)"
                    }
                }
            ],
            terminationBehavior: "force_continue"
        } | to json -r)
    }
}
