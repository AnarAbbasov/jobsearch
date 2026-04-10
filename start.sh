docker run -t -d -p 8081:80 -v $(pwd)/cgi-bin:/usr/lib/cgi-bin -v $(pwd)/www:/var/www/html -v $(pwd)/www/data:/var/www/html/data darrenlester/cgi
chmod ao+w /var/www/html/data/

docker run -t -d -p 8081:80 -v $(pwd)/jobsearch/cgi-bin:/usr/lib/cgi-bin -v $(pwd)/jobsearch/www:/var/www/html -v $(pwd)/jobsearch/www/data:/var/www/html/data darrenlester/cgi

chmod a+w /home/anar/jobsearch/www/data/jobsearch.db


podman run -t -d -p 8081:80 -v $(pwd)/jobsearch/cgi-bin:/usr/lib/cgi-bin -v $(pwd)/jobsearch/www:/var/www/html -v $(pwd)/jobsearch/www/data:/var/www/html/data anarabbasov/jobster:0.1.0