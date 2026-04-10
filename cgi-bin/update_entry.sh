#!/bin/bash

echo "Content-Type: text/html"
echo

DB="/var/www/html/data/jobsearch.db"

# Read POST data
read -n "$CONTENT_LENGTH" data

# URL decode
urldecode() {
    local raw="$1"
    raw="${raw//+/ }"
    printf '%b' "${raw//%/\\x}"
}

# Parse fields
for pair in ${data//&/ }; do
    key="${pair%%=*}"
    val="${pair#*=}"
    decoded=$(urldecode "$val")

    case "$key" in
        id) id="$decoded" ;;
        date) date="$decoded" ;;
        employer) employer="$decoded" ;;
        position) position="$decoded" ;;
        method) method="$decoded" ;;
        contact_person) contact_person="$decoded" ;;
        contact_info) contact_info="$decoded" ;;
        outcome) outcome="$decoded" ;;
        notes) notes="$decoded" ;;
    esac
done

# Escape single quotes for SQL
esc() { printf "%s" "$1" | sed "s/'/''/g"; }

# Update row
sqlite3 "$DB" "
UPDATE logs SET
    date='$(esc "$date")',
    employer='$(esc "$employer")',
    position='$(esc "$position")',
    method='$(esc "$method")',
    contact_person='$(esc "$contact_person")',
    contact_info='$(esc "$contact_info")',
    outcome='$(esc "$outcome")',
    notes='$(esc "$notes")'
WHERE id=$id;
"

# Redirect back to viewer
cat <<EOF
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="0; URL=/cgi-bin/showlog.sh">
</head>
<body>
Updating entry...
</body>
</html>
EOF
