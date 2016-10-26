#nginx/manifests/init.pp
class nginx {

  package { 'nginx':
    ensure => installed,
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

  file { '/etc/nginx/nginx.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/nginx/nginx.conf',
    before => Package['nginx'],
    #notify => Service['nginx'],
  }
  
  file { '/etc/nginx/conf.d/default.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/nginx/default.conf',
    before => Package['nginx'],
    #notify => Service['nginx'],
  }
  
  service { 'nginx':
    ensure    => running,
    enable    => true,   
    subscribe => [ File['/etc/nginx/nginx.conf'],File['/etc/nginx/conf.d/default.conf'] ] ,
}

}
