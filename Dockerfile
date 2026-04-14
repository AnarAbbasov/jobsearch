FROM darrenlester/cgi

# Install SQLite
RUN apt-get update && apt-get install -y sqlite3
RUN apt-get update && apt-get install -y python3 python3-pip

# Copy CGI scripts
COPY ./cgi-bin/log_job_search.cgi /usr/lib/cgi-bin/
COPY ./cgi-bin/showlog.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/log_job_search.cgi
RUN chmod +x /usr/lib/cgi-bin/showlog.sh
COPY ./cgi-bin/edit_entry.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/edit_entry.sh
COPY ./cgi-bin/update_entry.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/update_entry.sh
COPY ./cgi-bin/delete_entry.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/delete_entry.sh
# Copy HTML
COPY ./www/index.html /var/www/html/
