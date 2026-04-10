#!/bin/bash

echo "Content-Type: text/html"
echo

DB="/var/www/html/data/jobsearch.db"

ID=$(echo "$QUERY_STRING" | sed -n 's/^id=\(.*\)/\1/p')

if [ -z "$ID" ]; then
    echo "<h3>Error: No ID provided.</h3>"
    exit 1
fi

sqlite3 "$DB" "DELETE FROM logs WHERE id = $ID;"

cat <<EOF
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="0; url=/cgi-bin/showlog.sh">
</head>
<body>
<p>Entry deleted. Redirecting...</p>
</body>
</html>
EOF