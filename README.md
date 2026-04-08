📘 Job Search Activity Log (CGI Web App)
This project provides a simple, lightweight Job Search Activity Log web application designed to meet Washington State ESD job‑search documentation requirements.
It uses:

A static HTML form (index.html)

Two CGI scripts for logging and viewing entries

A writable data file for storing job‑search activity

A Docker container based on darrenlester/cgi

The application runs entirely locally or inside a container — no external dependencies.

📁 Project Structure
Code
jobsearch/
│
├── www/
│   ├── index.html        # Main HTML form UI
│   ├── data/
│   │   └── js.txt        # Log file (created automatically)
│
├── cgi-bin/
│   ├── log_job_search.cgi
│   └── showlog.sh
│
└── Dockerfile
🧱 Dockerfile
The included Dockerfile installs your CGI scripts and HTML into the correct locations:

dockerfile
FROM darrenlester/cgi

COPY ./cgi-bin/log_job_search.cgi /var/www/cgi-bin/
COPY ./cgi-bin/showlog.sh /var/www/cgi-bin/
RUN chmod +x ./var/www/cgi-bin/log_job_search.cgi
RUN chmod +x ./var/www/cgi-bin/showlog.sh

COPY ./www/index.html /var/www/html/
🏗️ Building the Docker Image
Run this inside the project directory:

bash
docker build -t jobsearch .
This creates a local image named jobsearch.

🚀 Running the Container
The application requires three bind‑mounts:

CGI scripts → /usr/lib/cgi-bin

HTML files → /var/www/html

Writable data directory → /var/www/html/data

Start the container:

bash
docker run -t -d \
  -p 8081:80 \
  -v $(pwd)/cgi-bin:/usr/lib/cgi-bin \
  -v $(pwd)/www:/var/www/html \
  -v $(pwd)/www/data:/var/www/html/data \
  jobsearch
The service will be available at:

Code
http://localhost:8081
✍️ Required Permissions (Logging)
Your CGI script must be able to write to the log file.
Ensure the data directory is writable:

bash
chmod a+w www/data
If the log file already exists:

bash
chmod a+w www/data/js.txt
Inside the container, this corresponds to:

Code
/var/www/html/data/js.txt
📄 Accessing the Application
Submit job‑search entries:
Code
http://localhost:8081
View logged entries:
Code
http://localhost:8081/cgi-bin/showlog.sh
🧪 Testing the CGI Endpoint
You can test the logging script directly:

bash
curl -X POST \
  -d "date=2025-01-01&employer=Test&position=Engineer" \
  http://localhost:8081/cgi-bin/log_job_search.cgi
🛠️ Troubleshooting
CGI script not executing
bash
chmod +x cgi-bin/*.cgi
chmod +x cgi-bin/*.sh
Log file not updating
bash
chmod a+w www/data
chmod a+w www/data/js.txt
500 Internal Server Error
Check logs inside the container:

bash
docker exec -it <container-id> bash
tail 
