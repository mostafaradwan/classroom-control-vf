#memcached/manifests/init.pp
package 'memcashed' {
  ensure  => 'installed'

}

file '/etc/sysconfig/memcached' {
  ensure    =>  'file',
  port      =>  '11211',
  user      =>  'memcached',
  maxconn   =>  '96',
  cachsize  =>   '32',
  options   =>   '',
  require => Package['memcashed'],
  
}

service { 'memcached':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/sysconfig/memcached'],
}
