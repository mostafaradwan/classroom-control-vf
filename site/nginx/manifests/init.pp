#nginx/manifests/init.pp

class nginx {

  package { 'nginx':
    ensure => present,
  }

  file { '/var/www':
   ensure => 'directory',
   group  => 'root',
   mode   => '0755',
   owner  => 'root',
   before => Package['nginx'],
  }

  file { '/var/www/index.html':
   ensure => 'file',
   group  => 'root',
   mode   => '0755',
   owner  => 'root',
   source => 'puppet:///modules/nginx/index.html',
   before => File['/var/www'],
  }

}
