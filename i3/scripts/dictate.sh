#!/bin/bash

set -euo pipefail

AUDIO_FILE="/tmp/audio.wav"
PID_FILE="/tmp/dictate.pid"
FFMPEG_LOG="/tmp/dictate.ffmpeg.log"

# PulseAudio/PipeWire source name. Override with DICTATE_SOURCE.
# Examples:
#   DICTATE_SOURCE=default
#   DICTATE_SOURCE=alsa_input.pci-0000_04_00.6.HiFi__Mic1__source
SOURCE="${DICTATE_SOURCE:-default}"

MODEL="${DICTATE_MODEL:-ggml-base.en.bin}"
MODEL_PATH="${DICTATE_MODEL_PATH:-${HOME}/TOOLS/whisper.cpp/models/${MODEL}}"

usage() {
	printf 'Usage: %s {start|stop}\n' "$0" >&2
}

is_running() {
	local pid
	pid="$1"
	kill -0 "$pid" 2>/dev/null
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

	if [[ ! -s "$AUDIO_FILE" ]]; then
		exit 1
	fi

	TEXT="$(whisper-cpp -m "$MODEL_PATH" -f "$AUDIO_FILE" -nt)"
	xdotool type --clearmodifiers -- "$TEXT"
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
