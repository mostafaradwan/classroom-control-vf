# nginx/manifests/init.pp
class nginx ($param = '/var/www',) {
 
  #$svcname = hiera('nginx_svcname','nginx')
 
  case $::osfamily {
    'RedHat','Debian': {
      $docroot = $docrootparam #'/var/www'
      $logsdir = '/var/log/nginx'
      $confdir = '/etc/nginx'
      $blckdir = '/etc/nginx/conf.d'
      $pkgname = 'nginx'
      $fileown = 'root'
      $filegrp = 'root'
      $svcname = 'nginx'
    }
    'windows': {
      $docroot = $docrootparam# 'C:/ProgramData/nginx/html'
      $logsdir = 'C:/ProgramData/nginx/logs'
      $confdir = 'C:/ProgramData/nginx'
      $blckdir = 'C:/ProgramData/nginx/conf.d'
      $pkgname = 'nginx-service'
      $fileown = 'Administrator'
      $filegrp = 'Administrators'
      $svcname = 'nginx'
    }
  }
 
  $svcuser = $::osfamily ? {
    'RedHat'  => 'nginx',
    'Debian'  => 'www-data',
    'windows' => 'nobody',
  }
  
  File {
    ensure => file,
    owner  => $fileown,
    group  => $filegrp,
    mode   => '0644',
  }

  package { $pkgname:
    ensure => present,
    before => [File["${blckdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }
  
  file { $docroot: 
    ensure => directory,
  }
  
  file { "${docroot}/index.html":
    source => 'puppet:///modules/nginx/index.html',
  }
  
  file { "${blckdir}/default.conf":
    content  => epp('nginx/default.conf.epp'),
  }
  
  file { "${confdir}/nginx.conf":
    content  => epp('nginx/nginx.conf.epp'),
}
    
  service { $svcname:
    ensure    => running,
    enable    => true,
    subscribe => [File["${blckdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }
}

   

