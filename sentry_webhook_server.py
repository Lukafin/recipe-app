"""Minimal Sentry webhook receiver for local testing.

Run with:
    python sentry_webhook_server.py
Then point Sentry's webhook to http://localhost:5001/webhook
"""

import json
import logging
import os
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from typing import Any, Dict, Iterable, List, Tuple


LOG_LEVEL = os.getenv("SENTRY_WEBHOOK_LOG_LEVEL", "INFO").upper()
logging.basicConfig(
    level=LOG_LEVEL,
    format="[%(asctime)s] %(levelname)s %(message)s",
)
LOGGER = logging.getLogger(__name__)


def _read_json_body(handler: BaseHTTPRequestHandler) -> Tuple[dict, bytes]:
    """Read and decode JSON body, returning dict and raw bytes."""
    length_header = handler.headers.get("Content-Length")
    if not length_header:
        return {}, b""
    try:
        body_length = int(length_header)
    except ValueError:
        return {}, b""

    raw_body = handler.rfile.read(body_length)
    try:
        payload = json.loads(raw_body.decode("utf-8"))
    except (ValueError, UnicodeDecodeError):
        payload = {}
    return payload, raw_body


def _is_in_app(frame: Dict[str, Any]) -> bool:
    flag = frame.get("in_app")
    if isinstance(flag, str):
        return flag.lower() == "true"
    return bool(flag)


def _format_frame(frame: Dict[str, Any], idx: int) -> str:
    function = frame.get("function") or "<unknown>"
    module = frame.get("module")
    file_name = frame.get("filename")
    line_no = frame.get("lineno")
    parts: List[str] = [f"{idx}. "]
    if module:
        parts.append(f"{module}.")
    parts.append(function)
    if file_name or line_no:
        suffix = file_name or ""
        if line_no:
            suffix = f"{suffix}:{line_no}" if suffix else str(line_no)
        parts.append(f" ({suffix})")
    if _is_in_app(frame):
        parts.append(" [in-app]")
    return "".join(parts)


def _format_frames(frames: Iterable[Dict[str, Any]], limit: int = 10) -> List[str]:
    frame_list = [f for f in frames if isinstance(f, dict)]
    preferred = [f for f in frame_list if _is_in_app(f)] or frame_list
    ordered = list(reversed(preferred))  # most recent first
    return [_format_frame(frame, idx + 1) for idx, frame in enumerate(ordered[:limit])]


def _format_full_stack(frames: Iterable[Dict[str, Any]]) -> List[str]:
    all_frames = [f for f in frames if isinstance(f, dict)]
    ordered = list(reversed(all_frames))
    return [_format_frame(frame, idx + 1) for idx, frame in enumerate(ordered)]


def _parse_tags(event: Dict[str, Any]) -> Dict[str, str]:
    tags = event.get("tags")
    if isinstance(tags, list):
        tag_pairs: Dict[str, str] = {}
        for item in tags:
            if isinstance(item, list) and len(item) >= 2:
                key, value = item[0], item[1]
                if isinstance(key, str):
                    tag_pairs[key] = value if isinstance(value, str) else str(value)
        return tag_pairs
    if isinstance(tags, dict):
        return {str(k): str(v) for k, v in tags.items()}
    return {}


def _format_breadcrumbs(event: Dict[str, Any], keep: int = 5) -> List[str]:
    breadcrumbs = event.get("breadcrumbs", {}) or {}
    values = breadcrumbs.get("values")
    if not isinstance(values, list):
        return []

    def _fmt(bc: Dict[str, Any]) -> str:
        ts = bc.get("timestamp")
        category = bc.get("category")
        level = bc.get("level")
        bc_type = bc.get("type")
        message = bc.get("message")
        data_obj = bc.get("data") if isinstance(bc.get("data"), dict) else {}
        data_summary = ", ".join(f"{k}={v}" for k, v in data_obj.items()) if data_obj else ""
        parts: List[str] = []
        if ts:
            parts.append(f"{ts} ")
        if category:
            parts.append(f"[{category}] ")
        if bc_type:
            parts.append(f"{bc_type}: ")
        if message:
            parts.append(f"{message}")
        if data_summary:
            if message:
                parts.append(" | ")
            parts.append(data_summary)
        if level:
            parts.append(f" (level={level})")
        return "".join(parts).strip()

    recent = values[-keep:]
    return [_fmt(bc) for bc in recent if isinstance(bc, dict) and _fmt(bc)]


def format_sentry_event(payload: Dict[str, Any]) -> str:
    """Produce a readable summary of a Sentry webhook payload."""
    if not isinstance(payload, dict):
        return ""

    data = payload.get("data") or {}
    event = data.get("event") or payload.get("event") or {}
    issue = payload.get("issue") or data.get("issue") or {}

    title = (
        event.get("title")
        or issue.get("title")
        or "Unknown issue"
    )
    level = event.get("level")
    platform = event.get("platform")
    release = event.get("release")
    dist = event.get("dist")
    environment = event.get("environment")
    culprit = event.get("culprit")

    short_id = issue.get("short_id") or issue.get("id")
    url = (
        issue.get("permalink")
        or issue.get("web_url")
        or event.get("web_url")
        or payload.get("web_url")
    )

    user_id = None
    if isinstance(event.get("user"), dict):
        user_id = event["user"].get("id")

    tags = _parse_tags(event)
    selected_tags = [f"{k}={v}" for k, v in tags.items() if k in {"device", "os", "os.name", "release", "environment"}]

    exceptions = []
    exception_block = event.get("exception")
    if isinstance(exception_block, dict):
        values = exception_block.get("values")
        if isinstance(values, list):
            exceptions = [ex for ex in values if isinstance(ex, dict)]
    first_exception = exceptions[0] if exceptions else {}
    ex_type = first_exception.get("type")
    ex_value = first_exception.get("value")
    frames = []
    if isinstance(first_exception.get("stacktrace"), dict):
        stack_frames = first_exception["stacktrace"].get("frames")
        if isinstance(stack_frames, list):
            frames = [frame for frame in stack_frames if isinstance(frame, dict)]

    formatted_frames = _format_frames(frames)
    full_stack = _format_full_stack(frames)
    recent_breadcrumbs = _format_breadcrumbs(event)

    lines: List[str] = []
    header = "Sentry webhook"
    if short_id:
        header += f" (ID: {short_id})"
    lines.append(f"{header}:")
    lines.append(f"Title: {title}")
    if ex_type or ex_value:
        exc_line = "Exception: "
        if ex_type:
            exc_line += ex_type
        if ex_value:
            exc_line += f": {ex_value}"
        lines.append(exc_line)
    if culprit:
        lines.append(f"Culprit: {culprit}")
    lines.append(
        f"Level: {level or 'unknown'} | Platform: {platform or 'unknown'} | Release: {release or 'unknown'}"
        + (f" (dist {dist})" if dist else "")
        + f" | Env: {environment or 'unknown'}"
    )
    if user_id:
        lines.append(f"User: {user_id}")
    if selected_tags:
        lines.append("Tags: " + ", ".join(selected_tags))
    if url:
        lines.append(f"URL: {url}")
    if formatted_frames:
        lines.append("\nTop frames:")
        lines.extend(formatted_frames)
    if recent_breadcrumbs:
        lines.append("\nRecent breadcrumbs:")
        lines.extend(f"- {bc}" for bc in recent_breadcrumbs)
    if full_stack:
        lines.append("\nFull stack trace:")
        lines.extend(full_stack)
    return "\n".join(lines)


class SentryWebhookHandler(BaseHTTPRequestHandler):
    def _send_response(self, code: int = 200, message: str = "ok") -> None:
        self.send_response(code)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(message.encode("utf-8"))

    def do_POST(self) -> None:  # noqa: N802 (matching BaseHTTPRequestHandler API)
        if self.path.rstrip("/") != "/webhook":
            self._send_response(404, "not found")
            return

        payload, raw_body = _read_json_body(self)

        LOGGER.info("Received Sentry webhook at %s", self.path)
        summary = format_sentry_event(payload)
        if summary:
            LOGGER.info("Parsed Sentry payload:\n%s", summary)
        else:
            LOGGER.info("Raw body:\n%s", raw_body.decode("utf-8", errors="ignore"))

        self._send_response()

    def do_GET(self) -> None:  # noqa: N802 (matching BaseHTTPRequestHandler API)
        if self.path.rstrip("/") in ("", "/health", "/webhook"):
            self._send_response(200, "pong")
        else:
            self._send_response(404, "not found")

    # Silence noisy default logging
    def log_message(self, format: str, *args) -> None:  # noqa: A003,D401
        LOGGER.debug("Server log: " + format, *args)


def run() -> None:
    port = int(os.getenv("SENTRY_WEBHOOK_PORT", "5001"))
    server = HTTPServer(("0.0.0.0", port), SentryWebhookHandler)
    LOGGER.info("Listening for Sentry webhooks on http://localhost:%s/webhook", port)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        LOGGER.info("Shutting down server.")
        server.server_close()


if __name__ == "__main__":
    sys.exit(run())
