### Summary
The local Sentry webhook receiver (`sentry_webhook_server.py`) accepts unauthenticated POSTs on 0.0.0.0 and logs/parses full payloads. There is no signature verification, request size limit, or rate limiting. If exposed beyond localhost (e.g., via a tunnel), this can be abused to spam logs, exfiltrate sensitive event data, or trigger unwanted agent runs.

### Recommended remediation / acceptance criteria
- Implement HMAC signature verification using a shared secret passed via env (e.g., `SENTRY_WEBHOOK_SECRET`) and Sentry’s signature header. Reject requests with invalid/missing signatures.
- Enforce a maximum Content-Length (e.g., 1–2 MB) and return 413 when exceeded.
- Bind to `127.0.0.1` by default; allow override via `SENTRY_WEBHOOK_HOST` if needed.
- Add optional bearer token auth via `SENTRY_WEBHOOK_TOKEN` checked against `Authorization: Bearer ...`.
- Redact/limit logging of PII: avoid printing entire payload; keep the summarized output. Add a `SENTRY_WEBHOOK_REDACT_LOGS=true` flag to suppress stack/breadcrumb dumps.
- Add basic request rate limiting (e.g., token bucket in-memory) to cap bursts.
- Add unit tests for `format_sentry_event` and signature verification paths.

### Notes
- Related file: `sentry_webhook_server.py`.
- Tests: add a small pytest (or stdlib `unittest`) suite under `tests/` to validate signature verification, 404/200 status paths, and redaction toggles.
- Gotchas: Sentry sends different envelope shapes; keep parsing tolerant. Ensure time-safe signature comparison.