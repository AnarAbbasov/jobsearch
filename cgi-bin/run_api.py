#!/usr/bin/env python3
import json, sqlite3

print("Content-Type: application/json")
print("Access-Control-Allow-Origin: *")
print()

conn = sqlite3.connect("/var/www/html/data/jobsearch.db")

rows = conn.execute("""
    SELECT date(timestamp) AS day, COUNT(*) AS count
    FROM logs
    GROUP BY date(timestamp)
    ORDER BY day ASC
""").fetchall()

result = []
for day, count in rows:
   
    iso = day 
    result.append({"timestamp": iso, "count": count})

print(json.dumps(result))
