# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Set up Nginx configuration file
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => "
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
    # multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    server_tokens off;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        server_name _;

        # Add custom HTTP header
        add_header X-Served-By $hostname;

        root /var/www/html;
        index index.html;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
}
",
}

# Restart Nginx service
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/nginx/nginx.conf'],
}
