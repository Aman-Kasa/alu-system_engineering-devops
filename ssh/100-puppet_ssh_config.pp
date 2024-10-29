# This Puppet manifest configures the SSH client configuration file

file { '/home/ubuntu/.ssh/config':
  ensure  => file,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0600',  # Set file permissions to read/write for owner only
  content => template('ssh/config.erb'),  # Use a template for dynamic content
}

file_line { 'Turn off passwd auth':
  path  => '/home/ubuntu/.ssh/config',
  line  => 'PasswordAuthentication no',
  match => 'PasswordAuthentication yes',  # Only add if it exists
}

file_line { 'Declare identity file':
  path  => '/home/ubuntu/.ssh/config',
  line  => 'IdentityFile ~/.ssh/school',
  match => 'IdentityFile',
}
