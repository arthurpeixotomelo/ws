#!/usr/bin/env nu

let payload = (input | from json)
let files = ($payload.tool_input?.files? | default $payload.tool_args?.files? | default [])

let has_ts = ($files | where ($it | str ends-with [".ts", ".tsx", ".js", ".jsx"]))
let has_py = ($files | where ($it | str ends-with ".py"))

if ($has_ts | is-not-empty) { ^deno lint ...($has_ts | each {$in}) }
if ($has_py | is-not-empty) { ^uvx ruff check ...($has_py | each {$in}) }

exit 0