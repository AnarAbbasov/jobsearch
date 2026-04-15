#!/bin/bash

echo "Content-Type: text/html"
echo

DB="/var/www/html/data/jobsearch.db"

html_escape() {
    echo "$1" | sed \
        -e 's/&/\&amp;/g' \
        -e 's/</\&lt;/g' \
        -e 's/>/\&gt;/g' \
        -e 's/"/\&quot;/g' \
        -e "s/'/\&#39;/g"
}

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
        margin-right: 10px;
        padding: 10px 18px;
        background: #0078ff;
        color: white;
        text-decoration: none;
        border-radius: 6px;
        font-size: 16px;
        transition: 0.2s;
    }
    .btn:hover { background: #005fcc; }
    .btn-delete {
        background: #d9534f;
    }
    .btn-delete:hover {
        background: #b52b27;
    }
</style>

<script>
function confirmDelete(id) {
    if (confirm("Are you sure you want to delete this entry? This cannot be undone.")) {
        window.location.href = "/cgi-bin/delete_entry.sh?id=" + id;
    }
}
</script>

</head>
<body>

<h2>Logged Entries</h2>

<a class="btn" href="/index.html">⬅ Back to Main Page</a>
<a class="btn" href="/cgi-bin/download_csv.sh">⬇ Download CSV</a>

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
    <th>Edit</th>
    <th>Delete</th>
</tr>
EOF

sqlite3 -csv "$DB" "SELECT id, date, employer, position, method, contact_person, contact_info, outcome, notes FROM logs ORDER BY id DESC;" \
| while IFS=',' read -r id date employer position method contact_person contact_info outcome notes
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

    printf "<td><a class='btn' href='/cgi-bin/edit_entry.sh?id=%s'>Edit</a></td>" "$id"
    printf "<td><a class='btn btn-delete' href='javascript:void(0);' onclick='confirmDelete(%s)'>Delete</a></td>" "$id"

    printf "</tr>\n"
done

cat <<EOF
</table>
</body>
</html>
EOF
