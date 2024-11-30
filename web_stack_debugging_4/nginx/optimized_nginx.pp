# This Puppet manifest configures Nginx with optimized settings

class nginx::optimized {

  # Define the variables for the Nginx configuration
  $server_name            = 'localhost'
  $root                   = '/var/www/html'
  $client_max_body_size   = '10m'
  $keepalive_timeout      = 65
  $worker_processes       = '4'
  $worker_connections     = '1024'
  $client_body_timeout    = '60s'
  $client_header_timeout  = '60s'

  # Render the Nginx configuration template
  file { '/etc/nginx/sites-available/optimized_nginx.conf':
    ensure  => file,
    content => template('nginx/optimized_nginx.conf.erb'),
    require => Package['nginx'],
  }

  # Create a symbolic link to enable the site
  file { '/etc/nginx/sites-enabled/optimized_nginx.conf':
    ensure  => link,
    target  => '/etc/nginx/sites-available/optimized_nginx.conf',
    require => File['/etc/nginx/sites-available/optimized_nginx.conf'],
  }

  # Restart Nginx to apply the configuration
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/nginx/sites-available/optimized_nginx.conf'],
  }
}
