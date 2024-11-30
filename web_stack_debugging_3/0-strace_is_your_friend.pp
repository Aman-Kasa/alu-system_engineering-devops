exec { 'fix-wp-locale-path':
  command => '/bin/sed -i "s|/wp-includes/class-wp-locale.phpp|' +
             '/wp-includes/class-wp-locale.php|g" ' +
             '/var/www/html/wp-config.php',
  path    => ['/bin', '/usr/bin'],
  onlyif  => '/bin/grep -q "class-wp-locale.phpp" ' +
             '/var/www/html/wp-config.php',
}

service { 'apache2':
  ensure    => running,
  enable    => true,
  subscribe => Exec['fix-wp-locale-path'],
}
