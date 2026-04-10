sqlite3 www/data/jobsearch.db "
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
