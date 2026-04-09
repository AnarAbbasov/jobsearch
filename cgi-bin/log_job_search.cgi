#!/bin/bash

echo "Content-Type: text/html"
echo

# Read GET or POST data
if [ "$REQUEST_METHOD" = "GET" ]; then
    data="$QUERY_STRING"
elif [ "$REQUEST_METHOD" = "POST" ]; then
    read -n "$CONTENT_LENGTH" data
fi

########################################
# URL-DECODE FUNCTION
########################################
urldecode() {
    local raw="$1"
    raw="${raw//+/ }"
    printf '%b' "${raw//%/\\x}"
}

########################################
# PARSE FORM FIELDS
########################################
for pair in ${data//&/ }; do
    key="${pair%%=*}"
    val="${pair#*=}"

    decoded_val=$(urldecode "$val")
    cleaned_val=$(printf '%s' "$decoded_val" | tr -d '\r\n\t' | tr -cd '[:print:]')

    case "$key" in
        date) date="$cleaned_val" ;;
        employer) employer="$cleaned_val" ;;
        position) position="$cleaned_val" ;;
        method) method="$cleaned_val" ;;
        contact_person) contact_person="$cleaned_val" ;;
        contact_info) contact_info="$cleaned_val" ;;
        outcome) outcome="$cleaned_val" ;;
        notes) notes="$cleaned_val" ;;
    esac
done

########################################
# INSERT INTO SQLITE
########################################
DB="/var/www/html/data/jobsearch.db"

# Ensure table exists
sqlite3 "$DB" "
CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    employer TEXT,
    position TEXT,
    method TEXT,
    contact_person TEXT,
    contact_info TEXT,
    outcome TEXT,
    notes TEXT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
"

# Escape single quotes for SQL
esc() { printf "%s" "$1" | sed "s/'/''/g"; }

sqlite3 "$DB" "
INSERT INTO logs (date, employer, position, method, contact_person, contact_info, outcome, notes)
VALUES (
    '$(esc "$date")',
    '$(esc "$employer")',
    '$(esc "$position")',
    '$(esc "$method")',
    '$(esc "$contact_person")',
    '$(esc "$contact_info")',
    '$(esc "$outcome")',
    '$(esc "$notes")'
);
"

########################################
# HTML RESPONSE
########################################
cat <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Data Logged</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            padding: 40px;
            text-align: center;
        }
        h2 { color: #333; }
        .btn {
            display: inline-block;
            margin: 15px;
            padding: 12px 22px;
            background: #0078ff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            transition: 0.2s;
        }
        .btn:hover { background: #005fcc; }
    </style>
</head>
<body>
    <h2>Data received and logged successfully</h2>

    <a class="btn" href="/index.html">Return to Main Page</a>
    <a class="btn" href="/cgi-bin/showlog.sh">View Log File</a>
</body>
</html>
EOF
