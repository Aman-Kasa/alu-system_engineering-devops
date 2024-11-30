# Puppet manifest to resolve WordPress 500 Internal Server Error

# Specific fix for WordPress configuration
exec { 'fix-wordpress-configuration':
        command => '/bin/sed -i "s/MyISAM/InnoDB/g" /var/www/html/wp-config.php',
        path    => ['/bin', '/usr/bin'],
        onlyif  => '/bin/grep -q "MyISAM" /var/www/html/wp-config.php',
}

file { '/var/www/html/wp-config.php':
        ensure => file,
        mode   => '0644',
        owner  => 'www-data',
        group  => 'www-data',
}

exec { 'fix-wordpress-permissions':
        command => '/bin/chmod -R 755 /var/www/html',
        path    => ['/bin', '/usr/bin'],
}

service { 'apache2':
        ensure    => running,
        enable    => true,
        subscribe => [
                File['/var/www/html/wp-config.php'],
                Exec['fix-wordpress-configuration'],
                Exec['fix-wordpress-permissions']
        ],
}
