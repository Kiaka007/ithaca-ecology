# ============================
# utils.sh — shared temporal and directory helpers
# ============================
# Part of the Ithaca shell ecology.
# Source this in ~/.bashrc before arcane.sh:
#   [ -f "$HOME/.ithaca/shell/utils.sh" ] && source "$HOME/.ithaca/shell/utils.sh"
#
# Dependencies:
#   Required: bash, awk, date
#   Optional: eza (prettier directory listings)
#   Optional: curl + jq (real solar times; falls back to clock approximation)
#
# Solar location: create ~/.arcane_location with LAT=XX.XXXX and LON=-XX.XXXX
# ============================

# ----------------------------
# Directory Helpers
# ----------------------------

# Capability flag — cached at load time
__ARCANE_HAS_EZA=false
command -v eza >/dev/null 2>&1 && __ARCANE_HAS_EZA=true

# Pretty directory listing (top 10) with eza if available
__ls() {
  if $__ARCANE_HAS_EZA; then
    eza -1 --group-directories-first --icons --color=always | head -n 10
  else
    ls | head -n 10
  fi
}

# Quick cd commands
alias home='cd "$HOME"'
alias sundial="__sun_anchors"

# ----------------------------
# Temporal / Celestial
# Available to all ecologies (arcane, guild, etc.)
# Wheel + Moon: pure date arithmetic (no deps)
# Solar: optional curl + jq; degrades gracefully
# ----------------------------

# Internal lookup — shared logic for wheel functions
# mode "phrase" → NAME|PHRASE, mode "start" → YYYY-MM-DD
# Currently calibrated for Northern Hemisphere.
# For Southern Hemisphere, offset sabbat dates by ~6 months.
__wheel_lookup() {
  local mode="$1"
  local mmdd year
  mmdd="$(date +%m%d)"
  year="$(date +%Y)"

  local name phrase start
  if [ "$mmdd" -ge 1221 ] || [ "$mmdd" -lt 0201 ]; then
    name="🌑 Yule";              phrase="When warmth & light are scarce, people must make their own"
    [ "$mmdd" -lt 0201 ] && start="$((year-1))-12-21" || start="$year-12-21"
  elif [ "$mmdd" -ge 0201 ] && [ "$mmdd" -lt 0320 ]; then
    name="🌒 Imbolc";            phrase="Allow yourself to thaw and listen.";                  start="$year-02-01"
  elif [ "$mmdd" -ge 0320 ] && [ "$mmdd" -lt 0501 ]; then
    name="🌓 Ostara";            phrase="Balance returns; let small experiments bud"; start="$year-03-20"
  elif [ "$mmdd" -ge 0501 ] && [ "$mmdd" -lt 0621 ]; then
    name="🌔 Beltane";           phrase="Follow vitality; choose what you'll actually nourish"; start="$year-05-01"
  elif [ "$mmdd" -ge 0621 ] && [ "$mmdd" -lt 0801 ]; then
    name="🌕️ Litha (Midsummer)"; phrase="Stand in full light; refine what's already strong";   start="$year-06-21"
  elif [ "$mmdd" -ge 0801 ] && [ "$mmdd" -lt 0922 ]; then
    name="🌖 Lughnasadh (Lammas)"; phrase="Harvest the first results; keep what works";         start="$year-08-01"
  elif [ "$mmdd" -ge 0922 ] && [ "$mmdd" -lt 1031 ]; then
    name="🌗 Mabon";             phrase="Edit with care; align effort with meaning";            start="$year-09-22"
  else
    name="🌘 Samhain";           phrase="Let endings be clean; honor what you're carrying forward."; start="$year-10-31"
  fi

  case "$mode" in
    phrase) echo "$name|$phrase" ;;
    start)  echo "$start" ;;
  esac
}

__wheel_of_year()      { __wheel_lookup "phrase"; }
__wheel_season_start() { __wheel_lookup "start"; }

# Moon phase (local calc — requires awk)
__moon_phase_line() {
  local now ref syn
  now="$(date -u +%s)"
  ref="1776426692"
  syn="29.53058867"

  local idx
  idx="$(
    awk -v now="$now" -v ref="$ref" -v syn="$syn" '
      BEGIN {
        age = ((now - ref) / 86400.0)
        age = age - int(age / syn) * syn
        if (age < 0) age += syn
        print int((age / syn) * 8) % 8
      }'
  )"

  local emoji name phrase
  case "$idx" in
    0) emoji="🌑"; name="New Moon";        phrase="I release what I do not need; I learn; I grow." ;;
    1) emoji="🌒"; name="Waxing Crescent"; phrase="I am open to receive. Plant the seeds." ;;
    2) emoji="🌓"; name="First Quarter";   phrase="I am patient. Observe and balance." ;;
    3) emoji="🌔"; name="Waxing Gibbous";  phrase="I am ready. Near culmination." ;;
    4) emoji="🌕"; name="Full Moon";       phrase="I am full, I am whole, I have what I need." ;;
    5) emoji="🌖"; name="Waning Gibbous";  phrase="I am generous. Begin to shed." ;;
    6) emoji="🌗"; name="Last Quarter";    phrase="I am protected. Begin to prune." ;;
    7) emoji="🌘"; name="Waning Crescent"; phrase="I am free. Rest and compost." ;;
  esac

  echo "Moon: $emoji  $name"
  echo "✧ $phrase"
}

# Capability flags (set once at load time)
__ARCANE_HAS_CURL=false
__ARCANE_HAS_JQ=false
command -v curl >/dev/null 2>&1 && __ARCANE_HAS_CURL=true
command -v jq   >/dev/null 2>&1 && __ARCANE_HAS_JQ=true

# In-memory cache for today's sun JSON
__ARCANE_SUN_JSON=""

# Load LAT/LON from ~/.arcane_location
# Create this file with two lines: LAT=XX.XXXX and LON=-XX.XXXX
__arcane_load_location() {
  if [ -f "$HOME/.arcane_location" ]; then
    # shellcheck disable=SC1090
    . "$HOME/.arcane_location"
  fi
  if [ -z "${LAT:-}" ] || [ -z "${LON:-}" ]; then
    echo "⚠️  Missing LAT/LON. Create ~/.arcane_location with LAT=.. and LON=.."
    return 1
  fi
}

# Sun times: sunrise-sunset.org (cached)
# Fallback order:
# 1) today's cache
# 2) API fetch
# 3) yesterday's cache
# 4) clock approximation
__sun_times_today_json() {
  # Memory cache
  if [ -n "$__ARCANE_SUN_JSON" ]; then
    echo "$__ARCANE_SUN_JSON"
    return 0
  fi

  local day cache_dir cache_file result
  cache_dir="$HOME/.cache/arcane-sun"
  mkdir -p "$cache_dir"
  day="$(date +%F)"
  cache_file="$cache_dir/$day.json"

  # Check today's file cache
  if [ -f "$cache_file" ]; then
    result="$(cat "$cache_file")"
  # Try API fetch
  elif $__ARCANE_HAS_CURL && $__ARCANE_HAS_JQ; then
    if __arcane_load_location; then
      local url="https://api.sunrise-sunset.org/json?lat=${LAT}&lng=${LON}&formatted=0"
      if result="$(curl -fsSL --max-time 6 "$url" 2>/dev/null)"; then
        echo "$result" | jq . > "$cache_file" 2>/dev/null || rm -f "$cache_file"
      fi
    fi
  fi
  # Try yesterday's cache as fallback
  if [ -z "$result" ]; then
    local yday ycache
    yday="$(date -d 'yesterday' +%F)"
    ycache="$cache_dir/$yday.json"
    [ -f "$ycache" ] && result="$(cat "$ycache")"
  fi
  # Final fallback
  [ -z "$result" ] && result="{}"

  __ARCANE_SUN_JSON="$result"
  echo "$result"
}

__iso_to_epoch() {
  date -d "$1" +%s 2>/dev/null
}

# Determine solar phase of day based on real sunrise/noon/sunset times.
# Falls back to clock approximation (07:00/12:00/17:00) if API unavailable.
__phase_from_epochs() {
  local now="$1" sr="$2" nn="$3" ss="$4"
  local midnight mid_morning mid_afternoon eve_mid
  midnight="$(date -d "tomorrow 00:00" +%s)"
  mid_morning=$(( sr + (nn - sr) / 2 ))
  mid_afternoon=$(( nn + (ss - nn) / 2 ))
  eve_mid=$(( ss + (midnight - ss) / 2 ))

  if   [ "$now" -lt "$sr" ];            then echo "Deep Night"
  elif [ "$now" -lt "$mid_morning" ];   then echo "Early Morning"
  elif [ "$now" -lt "$nn" ];            then echo "Late Morning"
  elif [ "$now" -lt "$mid_afternoon" ]; then echo "Early Afternoon"
  elif [ "$now" -lt "$ss" ];            then echo "Late Afternoon"
  elif [ "$now" -lt "$eve_mid" ];       then echo "Early Evening"
  else                                       echo "Late Evening"
  fi
}

__phase_of_day_clock_fallback() {
  local now sr nn ss
  now="$(date +%s)"
  sr="$(date -d "today 07:00" +%s)"
  nn="$(date -d "today 12:00" +%s)"
  ss="$(date -d "today 17:00" +%s)"
  __phase_from_epochs "$now" "$sr" "$nn" "$ss"
}

__phase_of_day() {
  local json sunrise_utc noon_utc sunset_utc
  json="$(__sun_times_today_json)" || return 1

  if ! $__ARCANE_HAS_JQ; then
    __phase_of_day_clock_fallback
    return 0
  fi

  read -r sunrise_utc noon_utc sunset_utc <<< "$(
    echo "$json" | jq -r '[.results.sunrise // "", .results.solar_noon // "", .results.sunset // ""] | @tsv'
  )"

  if [ -z "$sunrise_utc" ] || [ -z "$noon_utc" ] || [ -z "$sunset_utc" ]; then
    __phase_of_day_clock_fallback
    return 0
  fi

  local sr nn ss now
  sr="$(__iso_to_epoch "$sunrise_utc")"
  nn="$(__iso_to_epoch "$noon_utc")"
  ss="$(__iso_to_epoch "$sunset_utc")"
  now="$(date +%s)"

  if [ -z "$sr" ] || [ -z "$nn" ] || [ -z "$ss" ]; then
    __phase_of_day_clock_fallback
    return 0
  fi

  __phase_from_epochs "$now" "$sr" "$nn" "$ss"
}

__phase_pretty() {
  case "$1" in
    "Deep Night")      echo "⚫️ Deep Night (Rest)" ;;
    "Early Morning")   echo "⚪️ Early Morning (Wonder)" ;;
    "Late Morning")    echo "🟡 Late Morning (Play)" ;;
    "Early Afternoon") echo "🟠 Early Afternoon (Move)" ;;
    "Late Afternoon")  echo "🔴 Late Afternoon (Manage)" ;;
    "Early Evening")   echo "🟣 Early Evening (Connect)" ;;
    "Late Evening")    echo "🔵 Late Evening (Wind-Down)" ;;
    *) echo "$1" ;;
  esac
}

__sun_anchors() {
  local fallback="Sun anchors (fallback): Sunrise ~07:00 | Midday 12:00 | Sunset ~17:00"
  local json sunrise_utc noon_utc sunset_utc
  json="$(__sun_times_today_json)" || return 0

  if ! $__ARCANE_HAS_JQ; then
    echo "$fallback"
    return 0
  fi

  read -r sunrise_utc noon_utc sunset_utc <<< "$(
    echo "$json" | jq -r '[.results.sunrise // "", .results.solar_noon // "", .results.sunset // ""] | @tsv'
  )"

  if [ -n "$sunrise_utc" ] && [ -n "$noon_utc" ] && [ -n "$sunset_utc" ]; then
    echo "Sunrise: $(date -d "$sunrise_utc" '+%H:%M') | Solar noon: $(date -d "$noon_utc" '+%H:%M') | Sunset: $(date -d "$sunset_utc" '+%H:%M')"
  else
    echo "$fallback"
  fi
}


# ----------------------------
# Rituals
# ----------------------------

map_ithaca() {
cat << 'EOF'

                                                 /\
    .-------------------------------.           /^^\
    |           THE ACADEMY         |          /^^^^\
    |  ___      ___|*|___      ___  |         /______\
    | |   |    [=========]   |   |  |       ^^^ ^^^^^^
    | |   |    |         |   |   |  |       ^^^^^THE^^^^
    | |___|    |_________|   |___|  |      ^^ WOODLANDS ^
    | [===]    [=========]   [===]  |      ^^^^^^^^^^^^^^^^
    |                               |    ^^ ^^^^ ^^^^ ^^^^^
    '-------------------------------'
                 | | | |
           [h]   | | | |  [h]
         [h][h]  | | | | [h][h]
        [h][h][h][h][h][h][h][h]                 N
       [h][h][h] ~TOWN~ [h][h][h]              W + E
      [h][h][h][h]    [h][h][h][h]               S
       [h][h][h][h]--[h][h][h][h]


EOF
}

# invoke — the welcome ritual
# Prints the Ithaca map, current season, moon phase, and solar phase of day.
invoke() {
  local season phrase phase
  IFS='|' read -r season phrase <<< "$(__wheel_of_year)"
  phase="$(__phase_of_day)" || return 1

  echo ".~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~."
  echo ".                      I T H A C A                          ."
  echo ".         A realm of study, commerce, and adventure         ."
  echo " ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
  map_ithaca
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "Season: $season"
  echo "✧ $phrase"
  echo ""
  echo "$(__moon_phase_line)"
  echo ""
  echo "Sun: $(__phase_pretty "$phase")"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo ""
  echo "🪴 weed (empties sun cache)"
  echo ""
}

# Clear arcane caches
weed() {
  local dirs=("$HOME/.cache/arcane-sun")
  for d in "${dirs[@]}"; do
    if [ -d "$d" ]; then
      rm -rf "${d:?}"/*
      echo "✓ Cleared $d"
    else
      echo "• $d (not found, skipping)"
    fi
  done
  __ARCANE_SUN_JSON=""
  echo "✧ Caches emptied."
}
