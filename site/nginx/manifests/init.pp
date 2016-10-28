#nginx/manifests/init.pp
class nginx {

    $servicename     = 'nginx'
   

   if $::osfamily == 'RedHat'or $::osfamily == 'Debian' {
       $packagename     = 'nginx'    
       $fileowner       = 'root'
       $filegroup       = 'root'
       $docroot         = '/var/www'
       $configdir       = '/etc/nginx/'
       $serverblock     = '/etc/nginx/conf.d'
       $logsdir         = '/var/log/nginx'
       
       if $::osfamily == 'Debian'  {
          $servicerunas    = 'nginx'
       }
       
    } 
   elseif $osfamily == 'windows' {
       $packagename     = 'nginx-service'    
       $fileowner       = 'Administrator'
       $filegroup       = 'Administrators'
       $docroot         = 'C:/ProgramData/nginx/html'
       $configdir       = 'C:/ProgramData/nginx'
       $serverblock     = 'C:/ProgramData/nginx/conf.d'
       $logsdir         = 'C:/ProgramData/nginx/logs'
       $servicename     = 'nginx'
       $servicerunas    = 'nobody'
    } 
   else {
    print "This is not a supported OS."
  }

 
   File {
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
   }

   package { 'nginx':
    ensure => installed,
    
    #Added before here instead of require at each file resource that's dependent on the package
    before => File['/var/www' ,'/var/www/index.html','/etc/nginx/nginx.conf'] ,
   }

   file {'/var/www' :
    #since this is a directory, Puppet will change the mode to 0775
    ensure   => directory, 
    
    #require  => Package['nginx'],
   }

   file { '/var/www/index.html':
    source   => 'puppet:///modules/nginx/index.html',
    #require  => File['/var/www'],
   }

   file { '/etc/nginx/nginx.conf':
    source   => 'puppet:///modules/nginx/nginx.conf',
       
    #require  => Package['nginx'],
    #before => File['/etc/nginx/'],
    #notify => Service['nginx'],
   }
  
   file { '/etc/nginx/conf.d/default.conf':
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
