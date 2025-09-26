# 2025-09-26: Bound by Duty
v1.1.0

- Fixed black background when hiding the divider
    - Resolved by changing hook from `hook_safe` to `hook`
- Added support for toggling off some settings mid game
    - Disables and enables hooks whenever settings are changed
    - Only works with hints and prompt
    - Divider hooks into `LoadingView.init` which only runs at startup, so rehooking midgame doesn't matter if it's never run again with the new values
    - Skull is a `hook_origin` which can't be disabled

# 2025-04-11
v1.0.1

Added Simplified Chinese `["zh-cn"]` localization (thanks RinAnarchy!)

# 2025-02-10
v1.0.0

Initial upload