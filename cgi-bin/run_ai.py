#!/usr/bin/env python3
import json
import os
import requests
import html
import urllib.request
import sys

# Force UTF‑8 output so Apache doesn't default to ASCII
sys.stdout = open(1, "w", encoding="utf-8", closefd=False)

print("Content-Type: text/html; charset=utf-8\n")

API_KEY = os.getenv("API_KEY")
MODEL = "gpt-4.1-mini"

# Step 1: Fetch your job-application JSON
API_URL = "http://192.168.1.18:8081/cgi-bin/run_api.py"

try:
    with urllib.request.urlopen(API_URL) as response:
        raw_json = response.read().decode("utf-8")
        job_data = json.loads(raw_json)
except Exception as e:
    print("<h1>Error fetching job data</h1>")
    print("<pre>%s</pre>" % html.escape(str(e)))
    raise SystemExit

# Step 2: Build the prompt for OpenAI
prompt_text = (
    "Here is my job application history as JSON:\n\n"
    + json.dumps(job_data, indent=2)
    + "\n\nAnalyze how many jobs I applied each day and explain the trend clearly."
)

payload = {
    "model": MODEL,
    "messages": [
        {"role": "user", "content": prompt_text}
    ]
}

# Step 3: Call OpenAI
response = requests.post(
    "https://api.openai.com/v1/chat/completions",
    headers={
        "Content-Type": "application/json",
        "Authorization": "Bearer " + API_KEY
    },
    data=json.dumps(payload)
)

# Step 4: Extract AI response
try:
    data = response.json()
    ai_text = data["choices"][0]["message"]["content"]
except Exception as e:
    ai_text = "Error: " + html.escape(str(e)) + "\nRaw: " + html.escape(response.text)

# Escape HTML but keep UTF‑8 characters intact
ai_text_escaped = html.escape(ai_text)

# Step 5: Output HTML
print("""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Job Application Trend</title>

<style>
    body {
        font-family: Arial, Helvetica, sans-serif;
        background: #f4f6f9;
        margin: 0;
        padding: 20px;
        color: #333;
    }

    h1 {
        background: #4a90e2;
        color: white;
        padding: 20px;
        border-radius: 8px;
        text-align: center;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .card {
        background: white;
        padding: 20px;
        margin-top: 20px;
        border-radius: 10px;
        border-left: 6px solid #4a90e2;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .card h2 {
        margin-top: 0;
        color: #4a90e2;
    }

    pre {
        background: #272822;
        color: #f8f8f2;
        padding: 15px;
        border-radius: 8px;
        overflow-x: auto;
        font-size: 14px;
        line-height: 1.4;
    }

    .ai-box {
        background: #e8f4ff;
        border-left: 6px solid #4a90e2;
        padding: 15px;
        border-radius: 8px;
        font-size: 16px;
        line-height: 1.5;
        white-space: pre-wrap;
    }
</style>

</head>
<body>

<h1>📊 Job Application Trend Analysis</h1>

<div class="card">
    <h2>📁 Raw Job Data</h2>
    <pre>%s</pre>
</div>

<div class="card">
    <h2>🤖 AI Explanation</h2>
    <div class="ai-box">%s</div>
</div>

</body>
</html>
""" % (html.escape(json.dumps(job_data, indent=2)), ai_text_escaped))











