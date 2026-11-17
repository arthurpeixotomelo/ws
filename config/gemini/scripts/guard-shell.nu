#!/usr/bin/env nu

# def main [] {
#     let ctx = ($in | from json)
#     let cmd = ($ctx.toolCall?.args?.CommandLine? | default "" | str trim)

#     # 1. Reject any command that is not explicitly nu / nu.exe
#     if not (($cmd | str starts-with "nu ") or ($cmd | str starts-with "nu.exe ")) {
#         print ({
#             decision: "deny",
#             reason: "Direct execution of bash, cmd, or PowerShell commands is disabled. You must delegate all shell, file search, and build operations to the 'shell' subagent using `invoke_subagent`."
#         } | to json)
#         return
#     }

#     # 2. Extract the code inside 'nu -c "..."' if present, and validate its syntax with nu --ide-check
#     if ($cmd | str contains " -c ") {
#         # Run nu syntax check on the command to prevent bashisms like && or invalid pipelines
#         let check_result = (do { ^nu --ide-check 10 --commands ($cmd | str replace --regex '^nu(\.exe)?\s+(-c|--commands)\s+' '') } | complete)

#         if ($check_result.exit_code != 0 or ($check_result.stdout | str trim | is-not-empty)) {
#             print ({
#                 decision: "deny",
#                 reason: $"Invalid Nushell syntax or disallowed construct detected: ($check_result.stdout). Correct the Nushell syntax before running."
#             } | to json)
#             return
#         }
#     }

#     # 3. Validated clean Nushell command -> Allow
#     print ({ decision: "allow" } | to json)
# }

let payload = (try { $in | from json } catch { {} })

    # 1. Detect if the calling agent is a subagent:
    # Antigravity subagent sessions start with an inter-agent message (containing 'sender=...')
    # rather than a direct USER_INPUT step.
    let transcript = ($payload.transcriptPath? | default "")
    let is_subagent = if ($transcript | is-not-empty) and ($transcript | path exists) {
        let first_line = (open --raw $transcript | lines | where ($it | str trim | is-not-empty) | first 1 | get 0? | default "")
        ($first_line | str contains "sender=")
    } else {
        # Fallback heuristic: subagent sessions have no direct user prompt
        ($payload.lastUserInput? | default "" | str trim | is-empty)
    }

    if $is_subagent {
        # 2. Inside the 'shell' subagent:
        # - Allow execution unconditionally (avoids self-blocking)
        # - Inject BypassSandbox: true so Nushell configs, XDG environment,
        #   plugin registries, and package managers (pnpm) run without permission errors.
        {
            decision: "allow",
            overwrite: {
                BypassSandbox: true
            }
        } | to json -r
    } else {
        # 3. Main agent session:
        # Block direct command execution and route to the shell subagent.
        {
            decision: "deny",
            reason: "Direct execution of bash, cmd, or PowerShell commands is disabled. You must delegate all shell, file search, and build operations to the 'shell' subagent using `invoke_subagent` with TypeName: 'shell'."
        } | to json -r
    }