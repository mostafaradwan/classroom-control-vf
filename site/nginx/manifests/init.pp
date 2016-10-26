#nginx/manifests/init.pp
class nginx {

   package { 'nginx':
    ensure => installed,
    before => File ['/var/www','/etc/nginx/nginx.conf','/etc/nginx/conf.d/default.conf']
   }

   file { '/var/www':
    ensure   => 'directory',
    group    => 'root',
    mode     => '0755',
    owner    => 'root',
    #require  => Package['nginx'],
   }

   file { '/var/www/index.html':
    ensure   => 'file',
    group    => 'root',
    mode     => '0755',
    owner    => 'root',
    source   => 'puppet:///modules/nginx/index.html',
    #require  => File['/var/www'],
   }

   file { '/etc/nginx/nginx.conf':
    ensure   => 'file',
    group    => 'root',
    mode     => '0755',
    owner    => 'root',
    source   => 'puppet:///modules/nginx/nginx.conf',
    
    #require  => Package['nginx'],
    #before => File['/etc/nginx/'],
    #notify => Service['nginx'],
   }
  
   file { '/etc/nginx/conf.d/default.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/nginx/default.conf',
    #require  => Package['nginx'],
    #before => File['/etc/nginx/conf.d'],
    #notify => Service['nginx'],
   }
  
   service { 'nginx':
    ensure    => running,
    enable    => true,   
    subscribe => [ File['/etc/nginx/nginx.conf'],File['/etc/nginx/conf.d/default.conf'] ] ,
   }
   
 
  #Package['nginx'] -> File ['/var/www'] -> File ['/etc/nginx/nginx.conf'] ->  File ['/etc/nginx/conf.d/default.conf'] -> Service['nginx'] 
  
}
