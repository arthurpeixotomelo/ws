#!/usr/bin/env nu

let payload = (input | from json)
if ($payload.stop_hook_active? | default false) { exit 0 }

let r = (^dx fallow --format json | complete)
if ($r.exit_code != 0) {
  { decision: "block", reason: $"Validation failed:\n($r.stdout)\n($r.stderr)\nResolve and continue." } | to json | print
  exit 0
}

exit 0