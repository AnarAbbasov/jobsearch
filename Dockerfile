FROM darrenlester/cgi

COPY ./cgi-bin/log_job_search.cgi /var/www/cgi-bin/
COPY ./cgi-bin/showlog.sh /var/www/cgi-bin/
RUN chmod +x ./var/www/cgi-bin/log_job_search.cgi
RUN chmod +x ./var/www/cgi-bin/showlog.sh

COPY ./www/index.html /var/www/html/





