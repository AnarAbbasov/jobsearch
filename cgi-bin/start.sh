docker run -t -d -p 8081:80 -v $(pwd)/cgi-bin:/usr/lib/cgi-bin -v $(pwd)/www:/var/www/html -v $(pwd)/www/data:/var/www/html/data darrenlester/cgi
chmod ao+w /var/www/html/data/