#!/bin/bash
DB="/var/www/html/data/jobsearch.db"
ts=$(date +"%Y-%m-%d_%H-%M-%S")

# Output HTTP headers FIRST
echo "Content-Type: text/csv"
echo "Content-Disposition: attachment; filename=\"jobsearch_logs_$ts.csv\""

echo

# Output CSV directly from SQLite
sqlite3 -header -csv "$DB" \
"SELECT date, employer, position, method, contact_person, contact_info, outcome, notes 
 FROM logs 
 ORDER BY id DESC;"
