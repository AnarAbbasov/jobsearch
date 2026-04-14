FROM darrenlester/cgi

# Install SQLite + Python
RUN apt-get update && \
    apt-get install -y sqlite3 python3 python3-pip && \
    apt-get clean

# Copy CGI scripts
COPY ./cgi-bin/*.cgi /usr/lib/cgi-bin/
COPY ./cgi-bin/*.sh /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*

# Copy HTML
COPY ./www/index.html /var/www/html/

# Run Apache in the foreground (correct for containers)
ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]

