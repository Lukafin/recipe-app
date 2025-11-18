#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROMPT_DIR="${SCRIPT_DIR}/prompts"

BASE_PROMPT_FILE="${PROMPT_DIR}/competitive_base_prompt.txt"
OPENAI_QUERY_FILE="${PROMPT_DIR}/competitive_openai_query.txt"
PERPLEXITY_PROMPT_FILE="${PROMPT_DIR}/competitive_perplexity_prompt.txt"

if [[ ! -f "${BASE_PROMPT_FILE}" ]]; then
  echo "Competitive research base prompt file not found: ${BASE_PROMPT_FILE}" >&2
  exit 1
fi

: "${CURSOR_API_KEY:?CURSOR_API_KEY is required}"
: "${REPO:?REPO is required}"

to_lower() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

append_context() {
  local heading="$1"
  local body="$2"

  if [[ -n "${ADDITIONAL_CONTEXT}" ]]; then
    ADDITIONAL_CONTEXT+=$'\n\n'
  fi

  ADDITIONAL_CONTEXT+="$heading"$'\n'"$body"
}

ADDITIONAL_CONTEXT=""

if [[ "$(to_lower "${ENABLE_OPENAI_DEEP_RESEARCH:-false}")" == "true" ]]; then
  if [[ -n "${OPENAI_API_KEY:-}" ]]; then
    echo "Fetching personal health competitor insights from OpenAI Deep Research..."

    if [[ ! -f "${OPENAI_QUERY_FILE}" ]]; then
      echo "OpenAI competitive research query template not found: ${OPENAI_QUERY_FILE}" >&2
    else
      OPENAI_QUERY=$(<"${OPENAI_QUERY_FILE}")
      # Use the Responses API with the o4-mini-deep-research model and web_search_preview tool
      OPENAI_PAYLOAD=$(jq -n --arg input "$OPENAI_QUERY" '{model:"o4-mini-deep-research", input:$input, tools:[{"type":"web_search_preview"}], max_output_tokens:1200}')

      OPENAI_HEADERS=("Authorization: Bearer ${OPENAI_API_KEY}" "Content-Type: application/json")
      if [[ -n "${OPENAI_RESEARCH_PROJECT_ID:-}" ]]; then
        OPENAI_HEADERS+=("OpenAI-Project: ${OPENAI_RESEARCH_PROJECT_ID}")
      fi

      OPENAI_HEADER_ARGS=()
      for header in "${OPENAI_HEADERS[@]}"; do
        OPENAI_HEADER_ARGS+=(-H "$header")
      done

      OPENAI_RESPONSE=$(curl --fail-with-body -sS https://api.openai.com/v1/responses \
        "${OPENAI_HEADER_ARGS[@]}" \
        -d "$OPENAI_PAYLOAD" || true)

      if [[ -n "${OPENAI_RESPONSE}" ]]; then
        OPENAI_ANALYSIS=$(printf '%s' "$OPENAI_RESPONSE" | jq -r '
          if .output_text then .output_text
          elif (.output and (.output | type == "array")) then
            [ .output[]? | .content[]? | .text ] | map(select(. != null and . != "")) | unique | join("\n")
          elif .result then .result
          else empty end
        ' 2>/dev/null || true)
        if [[ -z "${OPENAI_ANALYSIS}" || "${OPENAI_ANALYSIS}" == "null" ]]; then
          OPENAI_ANALYSIS="$OPENAI_RESPONSE"
        fi
        append_context "OpenAI Deep Research personal health highlights:" "$OPENAI_ANALYSIS"
      else
        echo "OpenAI Deep Research request failed or returned no data." >&2
      fi
    fi
  else
    echo "OpenAI Deep Research was enabled but OPENAI_API_KEY is not configured; skipping." >&2
  fi
fi

if [[ "$(to_lower "${ENABLE_PERPLEXITY_SEARCH:-false}")" == "true" ]]; then
  if [[ -n "${PERPLEXITY_API_KEY:-}" ]]; then
    echo "Running Perplexity search for personal health competitor updates..."

    if [[ ! -f "${PERPLEXITY_PROMPT_FILE}" ]]; then
      echo "Perplexity competitive prompt template not found: ${PERPLEXITY_PROMPT_FILE}" >&2
    else
      PERPLEXITY_PROMPT=$(<"${PERPLEXITY_PROMPT_FILE}")
      PERPLEXITY_MODEL=${PERPLEXITY_MODEL:-sonar-pro}
      PERPLEXITY_FALLBACK_MODEL=${PERPLEXITY_FALLBACK_MODEL:-sonar}
      PERPLEXITY_LAST_ERROR=""

      call_perplexity() {
        local model="$1"
        local prompt="$2"
        local payload
        payload=$(jq -n --arg prompt "$prompt" --arg model "$model" '{model:$model, temperature:0.1, messages:[{role:"system",content:"You are an AI strategy analyst that tracks competitor activity."},{role:"user",content:$prompt}] }')

        local tmp_response
        tmp_response=$(mktemp)
        local http_status
        if ! http_status=$(curl --silent --show-error \
          https://api.perplexity.ai/chat/completions \
          -H "Authorization: Bearer ${PERPLEXITY_API_KEY}" \
          -H "Content-Type: application/json" \
          --output "$tmp_response" \
          --write-out '%{http_code}' \
          -d "$payload"); then
          echo "Perplexity search request failed for model ${model}." >&2
          if [[ -s "$tmp_response" ]]; then
            cat "$tmp_response" >&2
          fi
          rm -f "$tmp_response"
          return 1
        fi

        local body
        body=$(<"$tmp_response")
        rm -f "$tmp_response"

        if [[ "$http_status" != "200" ]]; then
          echo "Perplexity API responded with status ${http_status} for model ${model}." >&2
          if [[ -n "$body" ]]; then
            echo "$body" >&2
            PERPLEXITY_LAST_ERROR="$body"
          else
            PERPLEXITY_LAST_ERROR="HTTP ${http_status}"
          fi
          return 1
        fi

        local summary
        summary=$(printf '%s' "$body" | jq -r '.choices[0].message.content' 2>/dev/null || true)
        if [[ -z "${summary}" || "${summary}" == "null" ]]; then
          summary="$body"
        fi
        append_context "Perplexity personal health research summary:" "$summary"
        return 0
      }

      if ! call_perplexity "$PERPLEXITY_MODEL" "$PERPLEXITY_PROMPT"; then
        if [[ -n "$PERPLEXITY_FALLBACK_MODEL" && "$PERPLEXITY_FALLBACK_MODEL" != "$PERPLEXITY_MODEL" ]]; then
          echo "Retrying Perplexity search with fallback model ${PERPLEXITY_FALLBACK_MODEL}..." >&2
          if ! call_perplexity "$PERPLEXITY_FALLBACK_MODEL" "$PERPLEXITY_PROMPT"; then
            echo "Perplexity search request failed after fallback. ${PERPLEXITY_LAST_ERROR:-See error above.}" >&2
          fi
        else
          echo "Perplexity search request failed. ${PERPLEXITY_LAST_ERROR:-See error above.}" >&2
        fi
      fi
    fi
  else
    echo "Perplexity search was enabled but PERPLEXITY_API_KEY is not configured; skipping." >&2
  fi
fi

BASE_PROMPT=$(<"${BASE_PROMPT_FILE}")
PROMPT="$BASE_PROMPT"

if [[ -n "${ADDITIONAL_CONTEXT}" ]]; then
  PROMPT+=$'\n\nSupplemental external research:\n'"${ADDITIONAL_CONTEXT}"
fi

JSON=$(jq -n \
  --arg repo "https://github.com/${REPO}" \
  --arg prompt "$PROMPT" \
  '{model:"gpt-5",prompt:{text:$prompt},source:{repository:$repo,ref:"main"},target:{autoCreatePr:true}}')

if ! curl --fail-with-body -sS \
  --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer ${CURSOR_API_KEY}" \
  --header "Content-Type: application/json" \
  --data "$JSON"; then
  echo "Failed to launch Cursor agent for monthly competitive research." >&2
  exit 1
fi