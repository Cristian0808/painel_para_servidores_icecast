#!/bin/bash
echo "ATENCAO!!! Rode esse script como usuario root (nao usando sudo) ou o painel nao sera instalado corretamente!!!"
echo "Digite o usuario que sera usada para acessar o painel"
read usuario
echo "Digite a senha que sera usada tambem para acessar o painel"
read senha
echo "Instalando painel para o Icecast..."
sudo apt-get install php -y
sudo apt-get install icecast2 -y
sudo apt-get install liquidsoap -y
sudo mkdir /var/www/html/painel/
sudo cp html/index.php /var/www/html/painel/index.php
sudo cp html/backend.php /var/www/html/painel/backend.php
sudo cp configs/liquidsoap-painel-init.sh /usr/local/bin/liquidsoap-painel-init.sh
sudo cp configs/painel-interface.liq /etc/liquidsoap/painel-interface.liq
sudo cp configs/icecast.xml /etc/icecast2/icecast.xml
sudo cp configs/liquidsoap-painel.service /etc/systemd/system/liquidsoap-painel.service
sudo htpasswd -c -b /var/www/html/painel/.htpasswd $usuario $senha
sudo cat > /etc/apache2/sites-enabled/000-default.conf << "EOF"
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

   <Directory /var/www/html/painel/>
      Options FollowSymLinks
      AllowOverride All
      Require all denied
      <RequireAll>
         <RequireAll>
            Require valid-user
            AuthBasicProvider file
            AuthType Basic
            AuthName "Login"
            AuthUserFile /var/www/html/painel/.htpasswd
         </RequireAll>
      </RequireAll>
   </Directory>
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF
sudo systemctl daemon-reload
sudo systemctl enable liquidsoap-painel
sudo systemctl restart icecast2
sudo systemctl restart apache2
sudo systemctl restart liquidsoap-painel
exit 0
