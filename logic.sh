#!/usr/bin/env bash

# ==========================================
# Home Assistant API logic
# ==========================================

HOME_ASSISTANT_URL="${HOME_ASSISTANT_URL:-http://localhost:8123}"
HOME_ASSISTANT_LIGHT_ENTITY="${HOME_ASSISTANT_LIGHT_ENTITY:-light.your_light_entity_id}"
HOME_ASSISTANT_TEMPERATURE_SENSOR="${HOME_ASSISTANT_TEMPERATURE_SENSOR:-sensor.your_temperature_sensor_id}"

ha_request() {
    local method="$1"
    local path="$2"
    local body="${3:-}"
    local url="${HOME_ASSISTANT_URL%/}${path}"

    if [ -z "${HOME_ASSISTANT_TOKEN:-}" ]; then
        echo "Error: set HOME_ASSISTANT_TOKEN before calling Home Assistant." >&2
        return 1
    fi

    if [ -n "$body" ]; then
        curl -fsS -X "$method" \
            -H "Authorization: Bearer ${HOME_ASSISTANT_TOKEN}" \
            -H "Content-Type: application/json" \
            -d "$body" \
            "$url"
    else
        curl -fsS -X "$method" \
            -H "Authorization: Bearer ${HOME_ASSISTANT_TOKEN}" \
            -H "Content-Type: application/json" \
            "$url"
    fi
}

turn_on_light() {
    local body
    body="{\"entity_id\":\"${HOME_ASSISTANT_LIGHT_ENTITY}\"}"

    ha_request "POST" "/api/services/light/turn_on" "$body" >/dev/null || return 1
    echo "Command sent: Light ON (${HOME_ASSISTANT_LIGHT_ENTITY})"
}

get_temperature() {
    local response
    local state
    local unit

    response=$(ha_request "GET" "/api/states/${HOME_ASSISTANT_TEMPERATURE_SENSOR}") || return 1
    state=$(printf '%s' "$response" | sed -n 's/.*"state"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    unit=$(printf '%s' "$response" | sed -n 's/.*"unit_of_measurement"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

    if [ -z "$state" ]; then
        echo "Error: could not read temperature from Home Assistant response." >&2
        return 1
    fi

    echo "Current temperature: ${state}${unit}"
}
