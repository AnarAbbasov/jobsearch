#!/bin/bash

echo "Content-Type: text/html"
echo

DB="/var/www/html/data/jobsearch.db"

# Extract ID from query string
id=$(echo "$QUERY_STRING" | sed -n 's/^id=//p')

# Fetch row from SQLite
IFS='|' read -r date employer position method contact_person contact_info outcome notes <<EOF
$(sqlite3 "$DB" "SELECT date, employer, position, method, contact_person, contact_info, outcome, notes FROM logs WHERE id=$id;")
EOF

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
<title>Edit Entry</title>
<style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
    form { background: white; padding: 20px; border-radius: 8px; max-width: 600px; margin: auto; }
    label { display: block; margin-top: 12px; font-weight: bold; }
    input, textarea {
        width: 100%; padding: 8px; margin-top: 4px;
        border: 1px solid #ccc; border-radius: 4px;
    }
    .btn {
        display: inline-block; margin-top: 20px; padding: 10px 18px;
        background: #0078ff; color: white; text-decoration: none;
        border-radius: 6px; font-size: 16px; transition: 0.2s;
    }
    .btn:hover { background: #005fcc; }
</style>
</head>
<body>

<h2>Edit Entry #$id</h2>

<form action="/cgi-bin/update_entry.sh" method="POST">
    <input type="hidden" name="id" value="$id">

    <label>Date</label>
    <input type="text" name="date" value="$(html_escape "$date")">

    <label>Employer</label>
    <input type="text" name="employer" value="$(html_escape "$employer")">

    <label>Position</label>
    <input type="text" name="position" value="$(html_escape "$position")">

    <label>Method</label>
    <input type="text" name="method" value="$(html_escape "$method")">

    <label>Contact Person</label>
    <input type="text" name="contact_person" value="$(html_escape "$contact_person")">

    <label>Contact Info</label>
    <input type="text" name="contact_info" value="$(html_escape "$contact_info")">

    <label>Outcome</label>
    <input type="text" name="outcome" value="$(html_escape "$outcome")">

    <label>Notes</label>
    <textarea name="notes" rows="4">$(html_escape "$notes")</textarea>

    <button class="btn" type="submit">Save Changes</button>
    <a class="btn" href="/cgi-bin/showlog.sh">Cancel</a>
</form>

</body>
</html>
EOF
