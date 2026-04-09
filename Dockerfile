FROM darrenlester/cgi

# Install SQLite
RUN apt-get update && apt-get install -y sqlite3

# Copy CGI scripts
COPY ./cgi-bin/log_job_search.cgi /var/www/cgi-bin/
COPY ./cgi-bin/showlog.sh /var/www/cgi-bin/
RUN chmod +x /var/www/cgi-bin/log_job_search.cgi
RUN chmod +x /var/www/cgi-bin/showlog.sh

# Copy HTML
COPY ./www/index.html /var/www/html/
