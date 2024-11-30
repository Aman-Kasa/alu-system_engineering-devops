# Puppet manifest to resolve WordPress 500 Internal Server Error

# Ensure wp-config.php has correct permissions
file { '/var/www/html/wp-config.php':
  ensure => file,
  mode   => '0644',
  owner  => 'www-data',
  group  => 'www-data',
}

# Fix WordPress directory permissions
exec { 'fix-wordpress-permissions':
  command => '/bin/chmod -R 755 /var/www/html',
  path    => ['/bin', '/usr/bin'],
}

# Ensure PHP MySQL extension is installed
package { 'php5-mysql':
  ensure => installed,
}

# Ensure proper Apache configuration
service { 'apache2':
  ensure    => running,
  enable    => true,
  subscribe => [
    File['/var/www/html/wp-config.php'],
    Exec['fix-wordpress-permissions']
  ],}
