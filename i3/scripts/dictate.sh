#!/bin/bash

set -euo pipefail

AUDIO_FILE="/tmp/audio.wav"
PID_FILE="/tmp/dictate.pid"
FFMPEG_LOG="/tmp/dictate.ffmpeg.log"
WINDOW_FILE="/tmp/dictate.window"
NAGBAR_PID_FILE="/tmp/dictate.nagbar.pid"

STATUS_RECORD="(Recording...)"
STATUS_TRANSCRIBE="(Transcribing...)"

# PulseAudio/PipeWire source name. Override with DICTATE_SOURCE.
# Examples:
#   DICTATE_SOURCE=default
#   DICTATE_SOURCE=alsa_input.pci-0000_04_00.6.HiFi__Mic1__source
SOURCE="${DICTATE_SOURCE:-default}"

# MODEL="${DICTATE_MODEL:-ggml-base.en.bin}"
MODEL="${DICTATE_MODEL:-ggml-small.bin}"
MODEL_PATH="${DICTATE_MODEL_PATH:-${HOME}/TOOLS/whisper.cpp/models/${MODEL}}"

usage() {
	printf 'Usage: %s {start|stop}\n' "$0" >&2
}

is_running() {
	local pid
	pid="$1"
	kill -0 "$pid" 2>/dev/null
}

xdo_available() {
	command -v xdotool >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]
}

is_integer() {
	[[ "${1:-}" =~ ^[0-9]+$ ]]
}

get_target_window() {
	local win
	win=""

	if [[ -f "$WINDOW_FILE" ]]; then
		win="$(cat "$WINDOW_FILE" 2>/dev/null || true)"
	fi

	if [[ -z "$win" ]] && xdo_available; then
		win="$(xdotool getactivewindow 2>/dev/null || true)"
	fi

	if is_integer "$win"; then
		printf '%s' "$win"
		return 0
	fi

	return 1
}

save_active_window() {
	local win
	if ! xdo_available; then
		return 0
	fi

	win="$(xdotool getactivewindow 2>/dev/null || true)"
	if is_integer "$win"; then
		echo "$win" >"$WINDOW_FILE"
	fi
}

xdo_type() {
	local win text
	win="$1"
	text="$2"

	if ! xdo_available; then
		return 0
	fi

	if is_integer "$win"; then
		xdotool windowactivate --sync "$win" 2>/dev/null || true
		xdotool type --window "$win" --clearmodifiers --delay 1 -- "$text" 2>/dev/null || true
	else
		xdotool type --clearmodifiers --delay 1 -- "$text" 2>/dev/null || true
	fi
}

xdo_backspace() {
	local win count
	win="$1"
	count="$2"

	if ! xdo_available; then
		return 0
	fi

	if [[ "$count" -le 0 ]]; then
		return 0
	fi

	if is_integer "$win"; then
		xdotool windowactivate --sync "$win" 2>/dev/null || true
		xdotool key --window "$win" --clearmodifiers --repeat "$count" BackSpace 2>/dev/null || true
	else
		xdotool key --clearmodifiers --repeat "$count" BackSpace 2>/dev/null || true
	fi
}

i3_available() {
	command -v i3-nagbar >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]
}

nagbar_stop() {
	local pid
	pid=""
	if [[ -f "$NAGBAR_PID_FILE" ]]; then
		pid="$(cat "$NAGBAR_PID_FILE" 2>/dev/null || true)"
	fi

	if is_integer "$pid" && is_running "$pid"; then
		kill "$pid" 2>/dev/null || true
	fi

	rm -f "$NAGBAR_PID_FILE"
}

nagbar_start() {
	local msg
	msg="$1"

	if ! i3_available; then
		return 0
	fi

	nagbar_stop

i3-nagbar -t warning -m "$msg" >/dev/null 2>&1 &
	echo $! >"$NAGBAR_PID_FILE"
}

start_recording() {
	if [[ -f "$PID_FILE" ]]; then
		local existing_pid
		existing_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
		if [[ -n "$existing_pid" ]] && is_running "$existing_pid"; then
			# Already recording (likely key repeat while holding).
			exit 0
		fi
		rm -f "$PID_FILE"
	fi

	save_active_window
	nagbar_start "$STATUS_RECORD"

	rm -f "$AUDIO_FILE"

	# Record until stopped. Use SIGINT to finalize WAV on stop.
	ffmpeg -nostdin -hide_banner -loglevel error \
		-y -f pulse -i "$SOURCE" \
		-ac 1 -ar 16000 \
		"$AUDIO_FILE" \
		>"$FFMPEG_LOG" 2>&1 &

	echo $! >"$PID_FILE"
}

stop_recording_and_dictate() {
	local pid
	pid=""
	if [[ -f "$PID_FILE" ]]; then
		pid="$(cat "$PID_FILE" 2>/dev/null || true)"
	fi

	if [[ -n "$pid" ]] && is_running "$pid"; then
		kill -INT "$pid" 2>/dev/null || true

		# Wait for ffmpeg to exit so WAV header is finalized.
		for _ in $(seq 1 80); do
			if ! is_running "$pid"; then
				break
			fi
			sleep 0.05
		done
	fi

	rm -f "$PID_FILE"

	nagbar_stop

	local win
	win="$(get_target_window 2>/dev/null || true)"
	xdo_type "$win" "$STATUS_TRANSCRIBE"

	if [[ ! -s "$AUDIO_FILE" ]]; then
		nagbar_stop
		rm -f "$WINDOW_FILE"
		exit 1
	fi

	TEXT="$(whisper-cpp -m "$MODEL_PATH" -f "$AUDIO_FILE" -nt)"

	xdo_backspace "$win" "${#STATUS_TRANSCRIBE}"
	xdo_type "$win" "$TEXT"

	nagbar_stop
	rm -f "$WINDOW_FILE"
}

cmd="${1:-}"
case "$cmd" in
	start)
		start_recording
		;;
	stop)
		stop_recording_and_dictate
		;;
	*)
		usage
		exit 2
		;;
esac
