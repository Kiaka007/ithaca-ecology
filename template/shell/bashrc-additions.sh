#!/usr/bin/env bash
# ============================================================
# Ithaca Shell Additions — add these lines to your ~/.bashrc
# ============================================================
# After adding, run: source ~/.bashrc
# ============================================================

# --- Sphere Roots (parent directories) ---
# Rename these to match your own sphere names if desired.
# See docs/customization-guide.md for guidance.
export ACADEMY="$HOME/sp_academy"
export TOWN="$HOME/sp_town"
export WOODLANDS="$HOME/sp_woodlands"
export BAG="$HOME/bag"
export QUESTBOARD="$HOME/questboard"   # optional

# --- Space Roots (sphere subdirectories) ---
export LABS="$ACADEMY/labs"
export LIBRARY="$ACADEMY/library"
export WORKSHOP="$ACADEMY/workshop"
export JOURNAL="$BAG/journal"
export META="$BAG/meta"
export TOOLS="$BAG/tools"
export MARKET="$TOWN/market"
export TAVERN="$TOWN/tavern"
export TOWNHALL="$TOWN/townhall"
export RITUALS="$WOODLANDS/rituals"
export TRAINING="$WOODLANDS/training"

# --- Shelf Roots (nested layers inside spaces) ---
export DATA="$LABS/data"
export EXPERIMENTS="$LABS/experiments"
export SRC="$LABS/src"
export INSPIRATION="$LIBRARY/inspiration"
export DRAFTS="$LIBRARY/drafts"
export ARCHIVE="$LIBRARY/archive"
export NOTES="$LIBRARY/notes"
export TOMES="$LIBRARY/tomes"
export COMMISSIONS="$WORKSHOP/commissions"
export ADDRESSBOOK="$TOWNHALL/address-book"

# --- Folder Roots (named folders inside shelves) ---
export FIELD="$NOTES/field"
export METHODS="$NOTES/methods"
export READINGS="$NOTES/readings"
export RESEARCH="$NOTES/research"
export THREADS="$NOTES/threads"

# --- Source the shell scripts ---
[ -f "$HOME/.ithaca/shell/utils.sh" ] && source "$HOME/.ithaca/shell/utils.sh"
[ -f "$HOME/.ithaca/shell/arcane.sh" ] && source "$HOME/.ithaca/shell/arcane.sh"

# --- Solar anchoring: create this file with your coordinates ---
# ~/.arcane_location should contain:
#   LAT=XX.XXXX
#   LON=-XX.XXXX
# The system uses these to fetch real sunrise/sunset times.
# If the file is absent, it falls back to clock-based approximations.
