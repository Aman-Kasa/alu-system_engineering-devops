# This Puppet manifest configures the global SSH client configuration file

file { '/etc/ssh/ssh_config':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',  # Set file permissions to read/write for owner and read for others
  content => template('ssh/ssh_config.erb'),  # Using a template for the content
}

file_line { 'Turn off passwd auth':
  path  => '/etc/ssh/ssh_config',
  line  => 'PasswordAuthentication no',
  match => 'PasswordAuthentication yes',  # Only add if it exists
}

file_line { 'Declare identity file':
  path  => '/etc/ssh/ssh_config',
  line  => 'IdentityFile ~/.ssh/school',
  match => 'IdentityFile',
}
