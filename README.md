/***\
| ⟬ |
————

smart dom . a (a ui on Bash for Home Assistant)
https://www.figma.com/board/PO4qn5jgKiLK1GVocJlFqA/smart-dom?node-id=0-1&p=f&t=9QZv3Rs6Gsc37ge0-0

## Home Assistant setup

`logic.sh` reads Home Assistant connection details from environment variables:

```bash
export HOME_ASSISTANT_URL="http://localhost:8123"
export HOME_ASSISTANT_TOKEN="your_long_lived_access_token"
export HOME_ASSISTANT_LIGHT_ENTITY="light.living_room"
export HOME_ASSISTANT_TEMPERATURE_SENSOR="sensor.living_room_temperature"
```

Available functions:

```bash
source ./logic.sh
turn_on_light
get_temperature
```

`turn_on_light` calls the Home Assistant `light.turn_on` service. `get_temperature` reads the configured sensor state and prints the value plus unit when Home Assistant returns one.
