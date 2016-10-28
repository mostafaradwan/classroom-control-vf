# laura_epel/manifests/init.pp
class mostafa_epel {
  class { 'epel':
    epel_proxy => 'www.laura.com:1234'
  }
}
