# nginx/manifests/init.pp
class nginx {

  case $::osfamily {
    'RedHat','Debian': {
      $docroot = '/var/www'
      $logsdir = '/var/log/nginx'
      $confdir = '/etc/nginx'
      $blckdir = '/etc/nginx/conf.d'
    }
    'windows': {
      $docroot = 'C:/ProgramData/nginx/html'
      $logsdir = 'C:/ProgramData/nginx/logs'
      $confdir = 'C:/ProgramData/nginx'
      $blckdir = 'C:/ProgramData/nginx/conf.d'
    }
  }
 
  $svcuser = $::osfamily ? {
    'RedHat'  => 'nginx',
    'Debian'  => 'www-data',
    'windows' => 'nobody',
  }
  
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  package { 'nginx':
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
    
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => [File["${blckdir}/default.conf"],File["${confdir}/nginx.conf"]],
  }
}

    Contact GitHub API Training Shop Blog About 

