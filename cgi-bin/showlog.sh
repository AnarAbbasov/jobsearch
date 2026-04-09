#!/bin/bash

echo "Content-Type: text/html"
echo

DB="/var/www/html/data/jobsearch.db"

########################################
# HTML ESCAPE FUNCTION
########################################
html_escape() {
    echo "$1" | sed \
        -e 's/&/\&amp;/g' \
        -e 's/</\&lt;/g' \
        -e 's/>/\&gt;/g' \
        -e 's/"/\&quot;/g' \
        -e "s/'/\&#39;/g"
}

########################################
# START HTML
########################################
cat <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Log Viewer</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        table { border-collapse: collapse; width: 100%; background: white; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #0078ff; color: white; }
        tr:nth-child(even) { background: #f9f9f9; }
        .btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 18px;
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

<h2>Logged Entries</h2>

<a class="btn" href="/index.html">⬅ Back to Main Page</a>

<table>
<tr>
    <th>Date</th>
    <th>Employer</th>
    <th>Position</th>
    <th>Method</th>
    <th>Contact Person</th>
    <th>Contact Info</th>
    <th>Outcome</th>
    <th>Notes</th>
</tr>
EOF

########################################
# READ FROM SQLITE AND OUTPUT ROWS
########################################

sqlite3 -csv "$DB" "SELECT date, employer, position, method, contact_person, contact_info, outcome, notes FROM logs ORDER BY id DESC;" \
| while IFS=',' read -r date employer position method contact_person contact_info outcome notes
do
    printf "<tr>"
    printf "<td>%s</td>" "$(html_escape "$date")"
    printf "<td>%s</td>" "$(html_escape "$employer")"
    printf "<td>%s</td>" "$(html_escape "$position")"
    printf "<td>%s</td>" "$(html_escape "$method")"
    printf "<td>%s</td>" "$(html_escape "$contact_person")"
    printf "<td>%s</td>" "$(html_escape "$contact_info")"
    printf "<td>%s</td>" "$(html_escape "$outcome")"
    printf "<td>%s</td>" "$(html_escape "$notes")"
    printf "</tr>\n"
done

########################################
# END HTML
########################################
cat <<EOF
</table>
</body>
</html>
EOF
