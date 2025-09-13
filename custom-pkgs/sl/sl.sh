#!/usr/bin/env bash

win_id=$(niri msg --json windows | jq '.[] | select(.is_focused==true) | .id')

niri msg action move-window-to-floating

position() {
    niri msg --json windows | jq ".[] | select(.id==${win_id}) | .layout.tile_pos_in_workspace_view.[0] | round"
}

while true; do
    before_pos_x=${ position; }
    niri msg action move-floating-window --id "$win_id" -x +50
    after_pos_x=${ position; }

    if [[ "$before_pos_x" == "$after_pos_x" ]]; then
        break;
    fi
done

while true; do
    niri msg action move-floating-window --id "$win_id" -x -50
    after_pos_x=${ position; }

    if (( $after_pos_x <= 0 )); then
        break;
    fi
done

niri msg action toggle-window-floating --id "$win_id"
