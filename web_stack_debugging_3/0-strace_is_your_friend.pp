# 0-strace_is_your_friend.pp
# This manifest fixes Apache's 500 error by addressing a configuration issue.

# Ensure the Apache configuration file is present with the correct content.
file { '/etc/apache2/sites-available/000-default.conf':
  ensure  => present,
  content => '
<VirtualHost *:80>
    DocumentRoot /var/www/html
    # You can add more configuration details here as needed
</VirtualHost>',
  owner   => 'www-data',
  group   => 'www-data',
  mode    => '0644',
}

# Ensure the Apache service is running and enabled.
service { 'apache2':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/apache2/sites-available/000-default.conf'],
}
