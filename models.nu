# uvx hf models ls --json --limit 100000000 | save -fp models.json

# open models.json | where ($it.downloads != 0) | where ($it.library_name? != mlx) | where ($it.pipeline_tag? in [text-generation, feature-extraction, text-ranking]) | update created_at {|r| $r.created_at | into datetime } | sort-by trending,? downloads,? likes,? | explore 

# Fetch model list once
let models = (
    uvx hf models ls --format json
    | from json
)

$models
| each {|entry|

    let info = (
        uvx hf models info --json $entry.id
        | from json
    )

    let total_params = (
        if ($info.safetensors.total? | is-not-empty) {
            (
                $info.safetensors.total
                / 1_000_000_000
                | math round --precision 2
            )
        } else {
            null
        }
    )

    let active_params = (
        if (
            ($info.config.num_experts? | is-not-empty)
            and ($info.config.num_experts_per_tok? | is-not-empty)
            and ($total_params != null)
        ) {
            (
                $total_params
                * $info.config.num_experts_per_tok
                / $info.config.num_experts
                | math round --precision 2
            )
        } else {
            null
        }
    )

    let tool_support = (
        ($info.config.chat_template_jinja? | default "")
        | str contains "tools"
    )

    let other_tags = (
        $info.card_data.tags?
        | default []
    )

    let other_tags = (
        if $tool_support {
            if ("tools" not-in $other_tags) {
                $other_tags | append "tools"
            } else {
                $other_tags
            }
        } else {
            $other_tags
        }
    )

    {
        id: $info.id

        provider: (
            $info.id
            | split row "/"
            | first
        )

        created_at: $info.created_at

        modified_at: (
            $info.last_modified?
            | default null
        )

        library: (
            $info.card_data.library_name?
            | default $info.library_name
        )

        license: {
            id: (
                $info.card_data.license?
                | default null
            )

            name: (
                $info.card_data.license_name?
                | default null
            )
        }

        params: {
            total: $total_params
            active: $active_params
        }

        score: {
            likes: (
                $info.likes?
                | default 0
            )

            downloads: (
                $info.downloads?
                | default 0
            )

            trending: (
                $entry.trending_score?
                | default 0
            )
        }

        tags: {
            pipeline: (
                $info.card_data.pipeline_tag?
                | default $info.pipeline_tag
            )

            languages: (
                $info.card_data.language?
                | default []
            )

            others: $other_tags
        }
    }
}
| save hf_models.json