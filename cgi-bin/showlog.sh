#!/bin/bash

echo "Content-Type: text/html"
echo

# Read GET or POST data
if [ "$REQUEST_METHOD" = "GET" ]; then
    data="$QUERY_STRING"
elif [ "$REQUEST_METHOD" = "POST" ]; then
    read -n "$CONTENT_LENGTH" data
fi

# Start HTML
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
        .btn:hover {
            background: #005fcc;
        }
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

# Read and print rows 
while IFS='&' read -r date employer position method contact_person contact_info outcome notes
do
   # employer="${employer//+/ }"
   # employer="${employer//%3A/:}"
   # employer="${employer//%2F/\/}"
   # position="${position//+/ }"
   # method="${method//+/ }"
   # contact_person="${contact_person//+/ }"
   # contact_person="${contact_person//%3A/: }"
   # contact_person="${contact_person//%2F/\/ }"
#
   # contact_info="${contact_info//+/ }"
   # contact_info="${contact_info//%3A/:}"
   # contact_info="${contact_info//%2F/\/}"
   # contact_info="${contact_info//%3F/?}"
   #  #contact_info="${contact_info//%3D/=}"
     #contact_info="${contact_info//%26/&}"
    #printf "<tr>"
    #printf "<td>%s</td>" "${date##*=}"
    #printf "<td>%s</td>" "${employer##*=}"
    #printf "<td>%s</td>" "${position##*=}"
    #printf "<td>%s</td>" "${method##*=}"
    #printf "<td>%s</td>" "${contact_person##*=}"
    #printf "<td>%s</td>" "${contact_info##*=}"
    #printf "<td>%s</td>" "${outcome##*=}"
    #printf "<td>%s</td>" "${notes##*=}"
    #printf "</tr>\n"


 printf "<tr>"
 printf "<td>%s</td>" "${date##*=}"
 printf "<td>%s</td>" "${employer#*=}"
 printf "<td>%s</td>" "${position#*=}"
 printf "<td>%s</td>" "${method#*=}"
 printf "<td>%s</td>" "${contact_person#*=}"
 printf "<td>%s</td>" "${contact_info#*=}"
 printf "<td>%s</td>" "${outcome#*=}"
 printf "<td>%s</td>" "${notes#*=}"
 printf "</tr>\n"









done < /var/www/html/data/js.txt

# Close HTML
cat <<EOF
</table>
</body>
</html>
EOF
