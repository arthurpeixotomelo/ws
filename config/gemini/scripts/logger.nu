# logger.nu
# Reusable structured hook logger for Antigravity lifecycle hooks

# Main function to record a structured log entry into global ~/.gemini/logs/{conversation_id}/hooks.jsonl
export def log-hook [
  --hook-name: string              # Name of the hook (e.g. 'local-linter', 'lint-fix')
  --event-type: string             # Hook event ('PreToolUse', 'PostToolUse', 'Stop', etc.)
  --context: record                # The raw JSON object received from stdin by the hook
  --result: record                 # Execution result: { exit_code: int, stdout: string, stderr: string, duration_ms: int }
  --custom: record = {}            # Any additional custom metadata
] {
  let start_time = (date now)

  # 1. Resolve conversation ID
  let conv_id = ($context | get -o conversationId | default "global_or_unknown")

  # 2. Resolve workspace root & project name
  let ws_path = ($context | get -o workspacePaths | default [] | get -o 0 | default ".")
  let project_name = ($ws_path | path basename)

  # 3. Resolve user's home directory across OS environments
  let home_dir = (
     if ($env | get -o HOMEDRIVE | is-not-empty) and ($env | get -o HOMEPATH | is-not-empty) {
      $"($env.HOMEDRIVE)($env.HOMEPATH)"
    } else if ($env | get -o HOME | is-not-empty) {
      $env.HOME
    } else {
      "~" | path expand
    }
  )

  # Target log directory: ~/.gemini/logs/<conversation_id>/
  let log_dir = ([$home_dir, ".gemini", "logs", $conv_id] | path join)
  if not ($log_dir | path exists) {
    mkdir $log_dir
  }
  let log_file = ([$log_dir, "hooks.jsonl"] | path join)

  # 4. Extract trigger tool details (if PreToolUse or PostToolUse)
  let tool_call = ($context | get -o toolCall)
  let trigger_info = if ($tool_call != null) {
    let tool_name = ($tool_call | get -o name)
    let tool_args = ($tool_call | get -o args | default {})
    let target_file = ($tool_args | get -o Path | default ($tool_args | get -o TargetFile | default ""))
    {
      name: $tool_name
      target_file: $target_file
      args: $tool_args
    }
  } else {
    null
  }

  # 5. Check git status diff/summary if available
  let git_diff_summary = try {
    cd $ws_path
    let porcelain = (git status --porcelain | str trim)
    if ($porcelain | is-empty) { "clean" } else { $porcelain }
  } catch {
    "git_unavailable"
  }

  # 6. Build structured log record
  let log_entry = {
    timestamp: ($start_time | format date "%Y-%m-%dT%H:%M:%S%.3fZ")
    hook_name: $hook_name
    event_type: $event_type
    project_name: $project_name
    conversation_id: $conv_id
    step_idx: ($context | get -o stepIdx | default null)
    model_name: ($context | get -o modelName | default "")
    last_user_input: ($context | get -o lastUserInput | default "")
    trigger_tool: $trigger_info
    execution: {
      exit_code: ($result | get -o exit_code | default 0)
      duration_ms: ($result | get -o duration_ms | default 0)
      stdout: ($result | get -o stdout | default "")
      stderr: ($result | get -o stderr | default "")
    }
    git_status: $git_diff_summary
    custom: $custom
  }

  # 7. Append single line JSON
  ($log_entry | to json -r) + "\n" | save --append $log_file
}
