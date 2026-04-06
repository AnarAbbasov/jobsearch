#!/bin/bash

echo "Content-Type: text/html"
echo

# Read GET or POST data
if [ "$REQUEST_METHOD" = "GET" ]; then
    data="$QUERY_STRING"
elif [ "$REQUEST_METHOD" = "POST" ]; then
    read -n "$CONTENT_LENGTH" data
fi

# Log the data
echo "$data" >> /var/www/html/data/js.txt

# HTML response
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
        h2 {
            color: #333;
        }
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
        .btn:hover {
            background: #005fcc;
        }
    </style>
</head>
<body>
    <h2>Data received and logged successfully</h2>
    <p><strong>Logged value:</strong> $data</p>

    <a class="btn" href="/index.html">Return to Main Page</a>
    <a class="btn" href="/cgi-bin/showlog.sh">View Log File</a>
</body>
</html>
EOF
