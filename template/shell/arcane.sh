# ============================
# arcane.sh — Arcane Scholar Shell Ecology
# ============================
# Part of the Ithaca shell ecology.
# Source this in ~/.bashrc after utils.sh:
#   [ -f "$HOME/.ithaca/shell/arcane.sh" ] && source "$HOME/.ithaca/shell/arcane.sh"
#
# Requires: utils.sh (sourced first), all ACADEMY/BAG/TOWN/etc. exports set
# See: template/shell/bashrc-additions.sh for the full export block
#
# Customize: sphere names, NPC greetings, and creation rituals are all
# designed to be edited. Read docs/customization-guide.md first.
# ============================


# =====================
# ITHACA MAP PRINTS
# =====================

map_academy() {
cat << 'EOF'
   .-----------------------------------------.
   |              THE ACADEMY                |
   |  .---------.    [|*|]    .---------.    |
   |  |         |   [=====]   |         |    |
   |  | WORKSHOP|   |     |   |  LABS   |    |
   |  |         |   |     |   |         |    |
   |  |_________|   |_____|   |_________|    |
   |  .-------------------------------------.|
   |  |             LIBRARY               |  |
   |  |___________________________________|  |
   '-----------------------------------------'
EOF
}

map_woodlands() {
cat << 'EOF'
              /\             o
             /MM\          o R o
            /MMMM\          o o
           /______\
         ^^^^ ^^^^^^      | | | |
        ^^ WOODLANDS         T
       ^^^^^^^^^^^^^^^^
      ^^^^^^^^^^^^^^^^^
       ^^^^^^^^^^^^^^^

EOF
}

map_town() {
cat << 'EOF'
   .-----------------------------------------.
   |           .---------------------.       |
   |           |     TOWN  HALL      |       |
   |           |_____________________|       |
   |                                         |
   |  .-------.    (~ o ~)    .---------.    |
   |  |       |  QUESTBOARD   |         |    |
   |  | TAVERN|    [~~~~~]    |  MARKET |    |
   |  |       |               |         |    |
   |  |_______|               |_________|    |
   |               THE  TOWN                 |
   '-----------------------------------------'
EOF
}

# ---------------------------------------------------------
# THE ACADEMY
# Role: Scholar
# Entity: The Lunar Society
# Houses research, sense-making, and making
# --------------------------------------------------------

academy() {
  cd "$ACADEMY"
  local phase
  phase="$(__phase_of_day)" || return 1

  echo "┌─────────────────────────────────────────────┐"
  echo "│===========  ☄️  THE ACADEMY ☄️   =============│"
  echo "│              Welcome Scholar                │"
  echo "└─────────────────────────────────────────────┘"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "             $(__phase_pretty "$phase")             "
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo ""
  echo "---------------  ⛤ RITUALS  -------------------"
  echo "             labx | expx | prjx"
  echo "           tomex | tomadd | drafta"
  echo "      threadx | fieldx | methodx | readx"
  echo ""
  echo "---------------   ☉ SPACES   ------------------"
  __ls
  echo ""
  echo "===========  🧙 THE LUNAR SOCIETY  ============"
  echo "  The Scribe    library/   thread-weaver"
  echo "  The Steward   workshop/  commission-keeper"
  echo "  /advisor-a    faculty    generative advisor"
  echo "  /advisor-b    faculty    critical advisor"
  echo ""
}

# Academy Spaces (cd + context)
# ----------------------------

labs() {
  cd "$LABS" || return
  echo "⚗️  THE LAB — Exploration, play"
  echo "Prompt: What happens if?"
  __ls
}

# Shelves -----------------------

exp() {
  cd "$LABS/experiments"
  echo "🧪 EXPERIMENTS — Notebooks & sketches"
  echo "Prompt: What are you trying to see today?"
  __ls
}

labsrc() {
  cd "$LABS/src"
  echo "🧬 SRC — Code that survives"
  __ls
}

data() {
  cd "$LABS/data"
  echo "🧫 DATA — Materials for input"
  __ls
}

# ----------------------------------

library(){
    cd "$LIBRARY" || return
    echo "📚️ THE LIBRARY — Sense-making across time"
    __ls
}

# Shelves ---------------------------

notes() {
  cd "$NOTES" || return
  echo "🔮 NOTES — Thinking, slow sense-making"
  echo "Rule: Ask questions before answers."
  __ls
}

tomes() {
  cd "$TOMES" || return
  echo "💡 TOMES — Wells of generative thought"
  echo "Prompt: What wants to be recorded before it fades?"
  __ls
}

drafts() {
  cd "$DRAFTS" || return
  echo "📜 DRAFTS — Rehearsal space, nothing is final"
  __ls
}

archive() {
  cd "$ARCHIVE" || return
  echo "📚 Retired work and snapshots."
  __ls
}

insp() {
    cd "$INSPIRATION" || return
    echo "✨ INSPIRATION ─ My North Stars"
    __ls
}

# Folders ---------------------------
threads() {
    cd "$THREADS" || return
    echo "🪡 THREADS — Concepts under iteration"
    echo "Prompt: Where can this grow?"
    __ls
}

field() {
  cd "$FIELD" || return
  echo "🌿 FIELD — Preserve experience, not interpretation"
  echo "Prompt: What did I actually observe?"
  __ls
}

methods() {
  cd "$METHODS" || return
  echo "📏 METHODS — Practical wisdom, what worked / failed"
  __ls
}

research() {
  cd "$RESEARCH" || return
  echo "📑 RESEARCH — Slow synthesis, careful claims"
  __ls
}

readings() {
  cd "$READINGS" || return
  echo "✨ READINGS — What texts have changed my thinking?"
  __ls
}

# -----------------------------------

workshop(){
    cd "$WORKSHOP" || return
    echo "⚙️  THE WORKSHOP — Bounded Commitments"
    __ls
}

# Shelves ----------------------------
commissions() {
  cd "$COMMISSIONS" || return
  echo "⌛️ COMMISSIONS ─ Time-bound projects, defined outcomes"
  __ls
}

# ============================
# ACADEMY RITUALS
# ============================

# ----------------------
# Create new tome
# ----------------------
tomex() {
  local name="$1"
  if [ -z "$name" ]; then
    echo "Usage: tomex <tome-name>"
    return 1
  fi
  cp "$TOOLS/templates/tome-base.md" "$TOMES/$name.md"
  cd "$TOMES" || return
  nvim "$name.md"
}

# Add an entry to an existing tome
# Usage: tomadd <tome> "<title>" "<entry text>" "<tags>"
tomadd() {
  local tome_name="$1"
  local title="$2"
  local entry_text="$3"
  local raw_tags="$4"

  # Validate all args present
  if [ -z "$tome_name" ] || [ -z "$title" ] || [ -z "$entry_text" ] || [ -z "$raw_tags" ]; then
    echo "Usage: tomadd <tome> \"<title>\" \"<entry text>\" \"<tags>\""
    echo "Available tomes:"
    ls "$TOMES"*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//' | grep -v '^_' | sed 's/^/  /'
    return 1
  fi

  # Resolve tome file — exact match first, then partial match
  local tome_file="$TOMES/$tome_name.md"
  if [ ! -f "$tome_file" ]; then
    local matches match_count
    matches=$(ls "$TOMES/"*.md 2>/dev/null | grep -v "/_" | grep -i "$tome_name")
    match_count=$(echo "$matches" | grep -c .)
    if [ "$match_count" -eq 1 ]; then
      tome_file="$matches"
    else
      echo "⚠️  Tome not found: $tome_name"
      echo "Available tomes:"
      ls "$TOMES/"*.md 2>/dev/null | xargs -n1 basename | sed 's/.md$//' | grep -v '^_' | sed 's/^/  /'
      return 1
    fi
  fi

  # Compute next index (count numeric **Index:** entries, ignoring template "##")
  local index_count next_index
  index_count=$(grep -cP '^\*\*Index:\*\* \d+' "$tome_file" 2>/dev/null || echo 0)
  next_index=$(printf "%02d" $(( index_count + 1 )))

  # Normalize tags: split on comma/space, deduplicate, prefix with #
  local formatted_tags
  formatted_tags=$(echo "$raw_tags" | tr ',' ' ' | tr -s ' ' | xargs -n1 | sed 's/^#*//' | sort -u | sed 's/^/#/' | tr '\n' ' ' | sed 's/ $//')

  # Get today's date
  local today
  today=$(date +%Y-%m-%d)

  # Append entry to file
  printf '\n## %s\n**Index:** %s\n**Date:** %s\n**Tags:** %s\n\n%s\n\n***\n' \
    "$title" "$next_index" "$today" "$formatted_tags" "$entry_text" >> "$tome_file"

  echo "📚 Entry added to $(basename "$tome_file" .md)"
  echo "   [$next_index] $title"
  echo "   Tags: $formatted_tags  ·  $today"
}

# to create a new experiment
expx() {
  local slug="$1"
  if [ -z "$slug" ]; then
    echo "Usage: expx <short-topic-name>"
    return 1
  fi

  local base
  base="$(date +%Y-%m)-$slug"
  exp || return

  echo "🜂 RITUAL: Opening an Experiment"
  echo "Question: What are you trying to *see*, not prove?"
  echo

  if [ ! -f "$base-notes.md" ]; then
    cp "$TOOLS/templates/experiments-base.md" "$base-notes.md"
  fi

  echo "Created/ready:"
  echo "  • $base-notes.md"
  echo "  • create notebook in lab"
}

# to open jupyter lab
labx() {
  exp || return
  conda activate jupyter && jupyter lab
}

# to open taguette (qualitative coding)
# Customize the path below to match your conda environment and database location.
taguette() {
  echo "🏷️  TAGUETTE — Qualitative coding"
  echo "Opening at http://localhost:7465"
  # Replace the path below with your own taguette executable and database path:
  # ~/miniconda3/envs/YOUR_ENV/bin/taguette --port 7465 --browser --database ~/sp_academy/labs/data/taguette.sqlite3
  echo "⚠️  Configure the taguette path in arcane.sh before using this command."
}

# to create a new thread
threadx() {
  if [ -z "$1" ]; then
    echo "Usage: threadx <concept-name>"
    return 1
  fi
  mkdir -p "$THREADS/$1"/{decisions,handoffs,feedback,returns}
  cd "$THREADS/$1" || return
  local f="$THREADS/$1/overview.md"
  if [ ! -f "$f" ]; then
    cp "$TOOLS/templates/thread-overview.md" "$f"
  fi
  nvim "$f"
  threads
}

# to create a new field note
  fieldx() {
    local study="$1"
    if [ -z "$study" ]; then
        echo "Usage: fieldx <study-name>"
        return 1
    fi

    local base="$FIELD/$study"

    # Check for existing study
    if [ -d "$base" ]; then
        echo "⚠️  Study '$study' already exists at:"
        echo "    $base"
        echo "Creation cancelled."
        return 1
    fi

    # Create directory structure
    mkdir -p "$base"/{pre,raw,post}

    # Copy templates
    cp "$TOOLS/templates/fieldnote-pre.md" "$base/pre/$(date +%Y-%m)-pre.md"
    cp "$TOOLS/templates/fieldnote-raw.md" "$base/raw/$(date +%Y-%m)-raw.md"
    cp "$TOOLS/templates/fieldnote-post.md" "$base/post/$(date +%Y-%m)-post.md"

    cd "$base" || return

    echo
    echo "🌿 FIELD STUDY: $study"
    echo "Created:"
    echo "  • pre — preparing the lens"
    echo "  • raw — recording what is"
    echo "  • post — making meaning"
    echo
    echo "Prompt: What are you hoping to observe?"
    __ls
  }

# to create a new method note
  methodx() {
    local method="$1"
    if [ -z "$method" ]; then
        echo "Usage: methodx <method-topic>"
        return 1
    fi

    local f="$METHODS/$method.md"

    if [ ! -f "$f" ]; then
        cp "$TOOLS/templates/method-base.md" "$f"
    fi

    nvim "$f"
  }

# to create a new reading note
  readx() {
    local read="$1"
    if [ -z "$read" ]; then
        echo "Usage: readx <source-name>"
        return 1
    fi

    local f="$READINGS/$read.md"

    if [ ! -f "$f" ]; then
        cp "$TOOLS/templates/reading-base.md" "$f"
    fi

    nvim "$f"
  }

# to create a new project
prjx() {
  if [ -z "$1" ]; then
    echo "Usage: prjx <project-name>"
    return 1
  fi
  mkdir -p "$COMMISSIONS/$1"/{design,research,prototypes,outputs}
  cp "$TOOLS/templates/project-README.md" "$COMMISSIONS/$1/README.md"
  cp "$TOOLS/templates/project-sow.md" "$COMMISSIONS/$1/sow.md"
  cd "$COMMISSIONS/$1" || return
  nvim "$COMMISSIONS/$1/sow.md"
}

# to create a new application within Drafts
drafta() {
  if [ -z "$1" ]; then
    echo "Usage: drafta <application-name>"
    return 1
  fi
  mkdir -p "$DRAFTS/applications/$1"
  cp "$TOOLS/templates/application-README.md" "$DRAFTS/applications/$1/README.md"
  cd "$DRAFTS/applications/$1" || return
  nvim "README.md"
}

# -----------------------------------------------------------------------
# THE TOWN
# Role: Adventurer
# Entity: The Guild
# Houses public-facing work, relationships, and commerce
# ------------------------------------------------------------------------
town() {
  cd "$TOWN"
  local phase
  phase="$(__phase_of_day)" || return 1

  echo "┌─────────────────────────────────────────────┐"
  echo "│==============  🕍  TOWN  🏚️🏚️  ===============│"
  echo "│            Greetings Adventurer             │"
  echo "└─────────────────────────────────────────────┘"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "             $(__phase_pretty "$phase")             "
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo ""
  echo "---------------  ⛤ RITUALS  -------------------"
  echo "             ...tavern rituals..."
  echo "     offer coin | purse_goal | balance"
  echo "            ...townhall rituals..."
  echo ""
  echo "---------------   ☉ SPACES   ------------------"
  __ls
  echo ""
  echo "==============  🛡️ THE GUILD  ================="
  echo "  🍺 Tavern Keeper  town/  readiness-check"
  echo ""
}

# ----------------------------
# Town Spaces (cd + context)
# ----------------------------

market() {
  cd "$MARKET" || return
  echo "🏷️ THE MARKET — A lively place for commerce"
  echo "What is ready to be made public?"
  __ls
}

tavern() {
  cd "$TAVERN" || return
  echo "🍻 THE TAVERN — A hub of good eats and the latest news"
  __ls
}

townhall() {
  cd "$TOWNHALL" || return
  echo "⛲️ TOWNHALL — Where records about the community are kept"
  __ls
}

addressbook() {
  cd "$ADDRESSBOOK" || return
  echo "📇 COMMUNITIES — Address book of contacts and circles"
  __ls
}

# ----------------------------------------------------------------------
# THE WOODLANDS
# Role: Witch
# Entity: The Coven
# Houses spiritual practices, wellbeing, and seasonal attunement
# -----------------------------------------------------------------------
woodlands() {
  cd "$WOODLANDS"
  local phase
  phase="$(__phase_of_day)" || return 1

  echo "┌─────────────────────────────────────────────┐"
  echo "│^^^^^^^^^^^^^^  THE WOODLANDS  ^^^^^^^^^^^^^^│"
  echo "│        A gentle breeze calls you forth      │"
  echo "└─────────────────────────────────────────────┘"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "             $(__phase_pretty "$phase")             "
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo ""
  echo "---------------  ⛤ RITUALS  -------------------"
  echo "        offer element | balance"
  echo ""
  echo "---------------   ☉ SPACES   ------------------"
  map_woodlands
  echo "==============  🌙 THE COVEN  ================="
  echo "  🔮 The Oracle    woodlands/  seasonal-reader"
  echo ""
}

# ------------------------------
# Woodland Spaces (cd + context)
# ------------------------------

rituals() {
  cd "$RITUALS" || return
  echo "🌚 RITUALS — Spiritual activities"
  __ls
}

training() {
  cd "$TRAINING" || return
  echo "💪 TRAINING — Physical or errand-based activities"
  __ls
}

# =============================================
# ELEMENTAL OFFERING BOWL
# offer <earth|wind|water|fire> "description"
# offer coin <amount> "description"
# purse_goal <amount>   — set season coin goal
# balance               — view chart + coin row
# =============================================

__season_slug() {
  __wheel_lookup phrase \
    | cut -d'|' -f1 \
    | sed 's/([^)]*)//g' \
    | tr -cd 'a-zA-Z ' \
    | awk '{print tolower($1)}'
}

__next_season_start() {
  local slug="$1" year mmdd
  year="$(date +%Y)"
  mmdd="$(date +%m%d)"
  case "$slug" in
    yule)       [ "$mmdd" -lt "0201" ] \
                  && echo "${year}-02-01" \
                  || echo "$((year+1))-02-01" ;;
    imbolc)     echo "${year}-03-20" ;;
    ostara)     echo "${year}-05-01" ;;
    beltane)    echo "${year}-06-21" ;;
    litha)      echo "${year}-08-01" ;;
    lughnasadh) echo "${year}-09-22" ;;
    mabon)      echo "${year}-10-31" ;;
    samhain)    echo "${year}-12-21" ;;
  esac
}

__season_week_of_total() {
  local slug="$1"
  local s0 s1 ep0 ep1 now diff tot cur totw
  s0="$(__wheel_lookup start)"
  s1="$(__next_season_start "$slug")"
  ep0="$(date -d "$s0" +%s)"
  ep1="$(date -d "$s1" +%s)"
  now="$(date +%s)"
  diff=$(( (now - ep0) / 86400 ))
  tot=$(( (ep1 - ep0) / 86400 ))
  cur=$(( diff / 7 + 1 ))
  totw=$(( (tot + 6) / 7 ))
  printf "week %d of %d" "$cur" "$totw"
}

__elem_seg() {
  local color="$1" filled="$2"
  local DIM='\033[2m' RST='\033[0m'
  [ "$filled" -eq 1 ] \
    && printf "${color}■${RST}" \
    || printf "${DIM}${color}□${RST}"
}

offer() {
  local element="$1"
  local slug year date_str
  slug="$(__season_slug)"
  year="$(date +%Y)"
  date_str="$(date +%Y-%m-%d)"

  case "$element" in
    earth|wind|water|fire)
      if [ -z "$2" ]; then
        printf "Usage: offer %s \"description\"\n" "$element"
        return 1
      fi
      local file="$RITUALS/offerings/${slug}-${year}.md"
      mkdir -p "$(dirname "$file")"
      if [ ! -f "$file" ]; then
        { echo '---'; echo "season: $slug"; echo "year: $year"; echo '---'; } > "$file"
      fi
      echo "- $date_str $element \"$2\"" >> "$file"
      printf "✓ offered %-6s · %s\n" "$element" "$2"
      ;;
    coin)
      if [ -z "$2" ] || [ -z "$3" ]; then
        printf "Usage: offer coin <amount> \"description\"\n"
        return 1
      fi
      local file="$MARKET/purse/${slug}-${year}.md"
      mkdir -p "$(dirname "$file")"
      if [ ! -f "$file" ]; then
        { echo '---'; echo "season: $slug"; echo "year: $year"; echo 'goal: 0'; echo '---'; } > "$file"
      fi
      echo "- $date_str $2 \"$3\"" >> "$file"
      printf "✓ coin logged  · \$%s · %s\n" "$2" "$3"
      ;;
    *)
      printf "Usage: offer <earth|wind|water|fire> \"description\"\n"
      printf "       offer coin <amount> \"description\"\n"
      return 1
      ;;
  esac
}

purse_goal() {
  if [ -z "$1" ]; then
    printf "Usage: purse_goal <amount>\n"
    return 1
  fi
  local slug year file
  slug="$(__season_slug)"
  year="$(date +%Y)"
  file="$MARKET/purse/${slug}-${year}.md"
  mkdir -p "$(dirname "$file")"
  if [ ! -f "$file" ]; then
    { echo '---'; echo "season: $slug"; echo "year: $year"; echo "goal: $1"; echo '---'; } > "$file"
  else
    sed -i "s/^goal:.*/goal: $1/" "$file"
  fi
  printf "✓ season goal set · \$%s\n" "$1"
}

balance() {
  local YEL='\033[33m' RED='\033[31m' BLU='\033[34m'
  local GRN='\033[32m' DIM='\033[2m'  RST='\033[0m'
  local BLD='\033[1m'

  local slug year
  slug="$(__season_slug)"
  year="$(date +%Y)"

  local offerings="$RITUALS/offerings/${slug}-${year}.md"
  local purse="$MARKET/purse/${slug}-${year}.md"

  local label week_str
  label="$(echo "$slug" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
  local upper_label
  upper_label="$(echo "$label" | tr '[:lower:]' '[:upper:]')"
  week_str="$(__season_week_of_total "$slug")"

  # Count offerings per element
  local ec=0 wc=0 ac=0 fc=0
  if [ -f "$offerings" ]; then
    ec=$(awk '/^- / && $3=="earth" {c++} END{print c+0}' "$offerings")
    wc=$(awk '/^- / && $3=="wind"  {c++} END{print c+0}' "$offerings")
    ac=$(awk '/^- / && $3=="water" {c++} END{print c+0}' "$offerings")
    fc=$(awk '/^- / && $3=="fire"  {c++} END{print c+0}' "$offerings")
  fi

  # Segments 0–5 relative to max
  local mx=1
  for v in $ec $wc $ac $fc; do [ "$v" -gt "$mx" ] && mx=$v; done
  local es ws as fs
  es=$(awk "BEGIN{v=int($ec/$mx*5+0.5); print(v>5?5:v)}")
  ws=$(awk "BEGIN{v=int($wc/$mx*5+0.5); print(v>5?5:v)}")
  as=$(awk "BEGIN{v=int($ac/$mx*5+0.5); print(v>5?5:v)}")
  fs=$(awk "BEGIN{v=int($fc/$mx*5+0.5); print(v>5?5:v)}")

  # Coin purse
  local goal=0 earned=0 coin_filled=0
  if [ -f "$purse" ]; then
    goal=$(awk  '/^goal:/ {print $2+0}' "$purse")
    earned=$(awk '/^- /   {s+=$3}  END{print s+0}' "$purse")
  fi
  [ "${goal:-0}" -gt 0 ] && \
    coin_filled=$(awk "BEGIN{v=int($earned/$goal*10+0.5); print(v>10?10:v)}")

  # ── Render ──────────────────────────────────────────────
  printf "\n"
  printf "  ${BLD}${upper_label} ${year} · ${week_str}${RST}\n"
  printf "  ──────────────────────────────\n\n"

  printf "                WIND\n"

  local r
  for r in 5 4 3 2 1; do
    printf "                  "
    [ "$r" -le "$ws" ] && __elem_seg "$YEL" 1 || __elem_seg "$YEL" 0
    printf "\n"
  done

  printf "WATER  "
  local i
  for i in 1 2 3 4 5; do
    [ "$(( 6 - i ))" -le "$as" ] && __elem_seg "$BLU" 1 || __elem_seg "$BLU" 0
    printf " "
  done
  printf " + "
  for i in 1 2 3 4 5; do
    [ "$i" -le "$es" ] && __elem_seg "$GRN" 1 || __elem_seg "$GRN" 0
    printf " "
  done
  printf " EARTH\n"

  for r in 1 2 3 4 5; do
    printf "                  "
    [ "$r" -le "$fs" ] && __elem_seg "$RED" 1 || __elem_seg "$RED" 0
    printf "\n"
  done

  printf "                FIRE\n\n"
  printf "  ──────────────────────────────\n"

  # Coin row
  printf "  "
  for i in $(seq 1 10); do
    [ "$i" -le "$coin_filled" ] && printf "🪙 " || printf "○ "
  done
  if [ "${goal:-0}" -gt 0 ]; then
    printf "  \$%s of \$%s\n" "$earned" "$goal"
  else
    printf "  \$%s earned\n" "$earned"
  fi
  printf "  ──────────────────────────────\n\n"
}

# ---------------------------------------------------------
# MY BAG
# Cross-sphere tools, templates, and daily journal
# --------------------------------------------------------

bag() {
  cd "$BAG" || return

  echo ""
  echo "===============  🎒 MY BAG  ================="
  __ls
  echo ""
  echo "==============  QUICK TOOLS  ================"
  echo "  Journal (entry, status, recap, eod)"
  echo "  todo (todo_add, todo_edit)"
  echo ""
}

# ----------------------------
# Bag Compartments (cd + context)
# ----------------------------
journal() {
  cd "$JOURNAL" || return
  echo "🕯JOURNAL — Dated thinking, uncertainty welcome"
  __ls
}

meta() {
  cd "$META" || return
  echo "☄️ META — Aha moments of reflection."
  echo "Prompt: How does this change my views?"
  __ls
}

tools() {
  cd "$TOOLS" || return
  echo "🧭 TOOLS: Repeatable resources."
  __ls
}

# Pockets -------------------------------------------------
scripts() {
  cd "$TOOLS/scripts"
  echo "🪄 SCRIPTS:  Repeatable Code"
  __ls
}

templates() {
  cd "$TOOLS/templates"
  echo "🗺️ TEMPLATES: Repeatable formats & frames"
  __ls
}

spellbooks() {
  cd "$TOOLS/spellbooks"
  echo "📖 SPELLBOOKS: References to commands & shortcuts"
  __ls
}

# =====================
# RITUALS
# =====================

# to print to-dos
todo() {
  local file="$BAG/todo.md"
  echo
  echo "☑️  TO-DO (ambient)"
  echo "------------------"
  if [ ! -f "$file" ]; then
    echo "• (no to-do file yet)"
    return 0
  fi
  grep '^- ' "$file" | sed 's/^/• /'
  echo
  echo "Prompt: What wants light attention today?"
  echo
}

# to add to to-do's
todo_add() {
  local file="$BAG/todo.md"
  mkdir -p "$BAG"
  echo "- $*" >> "$file"
  echo "✓ added: $*"
}

# to edit to-do's
todo_edit() {
  local file="$BAG/todo.md"
  mkdir -p "$BAG"
  [ -f "$file" ] || echo "- " > "$file"
  nvim "$file"
}

# to create a new journal entry
entry() {
  journal || return
  local f="$JOURNAL/$(date +%F).md"
  if [ ! -f "$f" ]; then
    cp "$TOOLS/templates/entry.md" "$f"
  fi
  nvim "$f"
}

# ----------------------------
# Recap + status + eod
# ----------------------------
journal-tail() {
  local lines="${1:-18}"
  local today latest
  today="$(date +%F)"

  latest="$(ls "$JOURNAL"/*.md 2>/dev/null \
    | sed "s|.*/||" \
    | grep -v "^${today}\.md$" \
    | sort -r \
    | head -n 1)"

  if [ -z "$latest" ]; then
    echo "🕯 No journal entries found."
    return 0
  fi

  latest="$JOURNAL/$latest"
  echo "🕯 Last Journal Entry — $(basename "$latest")"
  echo "------------------------------------------"
  tail -n "$lines" "$latest"
  echo
}

status() {
  local hours="${1:-48}"
  local days
  days="$(( (hours + 23) / 24 ))"

  echo
  echo "══════════ 🧭 STATUS ══════════"
  echo "Now: $(date '+%A, %Y-%m-%d %H:%M')"
  echo

  echo "🧵 THREADS touched in last ${hours}h"
  echo "-----------------------------------"
  if [ -d "$THREADS" ]; then
    find "$THREADS" -type f -mtime "-$days" 2>/dev/null \
      | sed "s|$THREADS/||" \
      | awk -F/ '{print $1}' \
      | sort -u \
      | sed 's/^/• /'
  else
    echo "• (no threads directory at $THREADS)"
  fi
  echo

  echo "📜 Latest handoffs"
  echo "------------------"
  if [ -d "$THREADS" ]; then
    for t in "$THREADS"/*; do
      [ -d "$t" ] || continue
      local name latest
      name="$(basename "$t")"
      latest="$(ls -t "$t/handoffs"/*handoff* 2>/dev/null | head -n 1)"
      if [ -n "$latest" ]; then
        echo "• $name → $(basename "$latest")"
      fi
    done
  fi
  echo

  echo "🧪 Experiments modified in last ${hours}h"
  echo "----------------------------------------"
  if [ -d "$LABS/experiments" ]; then
    find "$LABS/experiments" -type f \
      \( -name "*.ipynb" -o -name "*-notes.md" -o -name "*.md" \) \
      -mtime "-$days" 2>/dev/null \
      | sed "s|$HOME/||" \
      | sort \
      | sed 's/^/• /'
  else
    echo "• (no experiments directory at $LABS/experiments)"
  fi
  echo

  echo "✴️  Commissions modified in last ${hours}h"
  echo "------------------------------------------"
  if [ -d "$COMMISSIONS" ]; then
    find "$COMMISSIONS" -type f -mtime "-$days" \
      ! -path "*/.git/*" 2>/dev/null \
      | sed "s|$HOME/||" \
      | sort \
      | sed 's/^/• /'
  else
    echo "• (no commissions directory at $COMMISSIONS)"
  fi
  echo
}

recap() {
  echo
  echo "══════════ ⏳ RECAP ══════════"
  echo "Date: $(date '+%A, %Y-%m-%d')"
  echo
  journal-tail
  status "48"
  todo
  echo "Prompt:"
  echo "• What thread feels alive right now?"
  echo "• What can wait?"
  echo
}

eod() {
  local today now stamp jf
  today="$(date +%F)"
  now="$(date '+%H:%M')"
  stamp="$(date '+%Y-%m-%d')"
  jf="$JOURNAL/${today}.md"

  echo
  echo "══════════ 🕯 END OF DAY ══════════"
  echo "Date: $stamp   Time: $now"
  echo

  echo "Evidence — files touched today"
  echo "--------------------------------"

  if [ -d "$LABS/experiments" ]; then
    echo "🧪 Experiments:"
    find "$LABS/experiments" -type f \
      \( -name "*.ipynb" -o -name "*.md" -o -name "*.py" -o -name "*.txt" \) \
      -newermt "$today 00:00" ! -newermt "tomorrow 00:00" 2>/dev/null \
      | sed "s|$HOME/||" | sort | sed 's/^/• /'
    echo
  fi

  if [ -d "$COMMISSIONS" ]; then
    echo "✴️ Commissions:"
    find "$COMMISSIONS" -type f \
      -newermt "$today 00:00" ! -newermt "tomorrow 00:00" \
      ! -path "*/.git/*" 2>/dev/null \
      | sed "s|$HOME/||" | sort | sed 's/^/• /'
    echo
  fi

  if [ -d "$THREADS" ]; then
    echo "🪡 Threads:"
    find "$THREADS" -type f \
      -newermt "$today 00:00" ! -newermt "tomorrow 00:00" 2>/dev/null \
      | awk -F'threads/' '{print $2}' | awk -F/ '{print $1}' \
      | sort -u | sed 's/^/• /'
    echo
  fi

  if [ ! -f "$jf" ]; then
    mkdir -p "$JOURNAL"
    cat > "$jf" <<EOT
# $today — End of Day

## What I did (facts)
-

## What I learned (insights)
-

## What surprised me
-

## What to try next
-

## One Seed to Carry into Tomorrow
-
EOT
  fi

  echo "📔 Today's journal (tail)"
  echo "------------------------"
  tail -n 18 "$jf"
  echo

  echo "🜄 Reflection prompts (write 3–7 lines)"
  echo "-------------------------------------"
  echo "1) One thing I *actually* accomplished:"
  echo "2) One thing I learned (even if small):"
  echo "3) One constraint or assumption that shifted:"
  echo "4) One open thread I'm choosing to keep open:"
  echo "5) Tomorrow's seed (one concrete next step):"
  echo
  echo "Tip: run → eod_edit"
  echo
}

eod_edit() {
  local jf
  jf="$JOURNAL/$(date +%F).md"
  mkdir -p "$JOURNAL"
  [ -f "$jf" ] || eod >/dev/null 2>&1
  nvim "$jf"
}
