# This Puppet manifest fixes missing PHP module and adjusts permissions for WordPress

package { 'php-mysql':
  ensure => installed,
}

exec { 'set-permissions':
  command => 'chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html',
  path    => '/bin:/usr/bin',
}

service { 'apache2':
  ensure  => running,
  enable  => true,
  require => Package['php-mysql'],
}
