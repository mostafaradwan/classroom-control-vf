# laura_epel/manifests/init.pp
class mostafa_epel {
  class { 'epel':
    epel_proxy => 'http://www.ooproxy.pw:80'
  }
}
