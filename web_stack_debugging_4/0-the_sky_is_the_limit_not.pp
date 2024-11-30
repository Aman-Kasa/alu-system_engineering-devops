# Ensure nginx is installed
package { 'nginx':
  ensure => 'installed',
}

# Execute the command to optimize nginx config
exec { 'optimize_nginx':
  command => "/bin/bash -c 'cat > /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 4096;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    client_body_buffer_size 16K;
    client_max_body_size 32M;
    client_header_buffer_size 8k;
    large_client_header_buffers 4 16k;

    gzip on;
    gzip_disable \"msie6\";

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF' ",
  onlyif  => '/bin/grep -q "worker_connections 4096;" /etc/nginx/nginx.conf',
  require => Package['nginx'],  # Ensure nginx is installed before this resource runs
}

# Ensure nginx service is running
service { 'nginx':
   ensure   => 'running',
   enable   => true,
  subscribe => Exec['optimize_nginx'],  # Restart nginx if exec changes its config
}
