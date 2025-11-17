#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROMPT_DIR="${SCRIPT_DIR}/prompts"

BASE_PROMPT_FILE="${PROMPT_DIR}/maintenance_base_prompt.txt"
OPENAI_QUERY_FILE="${PROMPT_DIR}/openai_research_query.txt"
PERPLEXITY_PROMPT_FILE="${PROMPT_DIR}/perplexity_prompt.txt"

if [[ ! -f "${BASE_PROMPT_FILE}" ]]; then
  echo "Base prompt file not found: ${BASE_PROMPT_FILE}" >&2
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
    echo "Fetching supplemental insights from OpenAI Deep Research..."

    if [[ ! -f "${OPENAI_QUERY_FILE}" ]]; then
      echo "OpenAI research query template not found: ${OPENAI_QUERY_FILE}" >&2
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
        append_context "OpenAI Deep Research findings:" "$OPENAI_ANALYSIS"
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
    echo "Running Perplexity search for recent advisories..."

    if [[ ! -f "${PERPLEXITY_PROMPT_FILE}" ]]; then
      echo "Perplexity prompt template not found: ${PERPLEXITY_PROMPT_FILE}" >&2
    else
      PERPLEXITY_PROMPT=$(<"${PERPLEXITY_PROMPT_FILE}")
      PERPLEXITY_PAYLOAD=$(jq -n --arg prompt "$PERPLEXITY_PROMPT" '{model:"sonar-large-online", temperature:0.1, messages:[{role:"system",content:"You are a vigilant software maintenance assistant that surfaces recent news, advisories, and library updates."},{role:"user",content:$prompt}] }')

      PERPLEXITY_RESPONSE=$(curl --fail-with-body -sS https://api.perplexity.ai/chat/completions \
        -H "Authorization: Bearer ${PERPLEXITY_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$PERPLEXITY_PAYLOAD" || true)

      if [[ -n "${PERPLEXITY_RESPONSE}" ]]; then
        PERPLEXITY_SUMMARY=$(printf '%s' "$PERPLEXITY_RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null || true)
        if [[ -z "${PERPLEXITY_SUMMARY}" || "${PERPLEXITY_SUMMARY}" == "null" ]]; then
          PERPLEXITY_SUMMARY="$PERPLEXITY_RESPONSE"
        fi
        append_context "Perplexity search highlights:" "$PERPLEXITY_SUMMARY"
      else
        echo "Perplexity search request failed or returned no data." >&2
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

curl --request POST \
  --url https://api.cursor.com/v0/agents \
  --header "Authorization: Bearer ${CURSOR_API_KEY}" \
  --header "Content-Type: application/json" \
  --data "$JSON"