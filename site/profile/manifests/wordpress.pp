#profile/manifests/wordpress.pp

class profile::wordpress {

  include apache
  include wordpress

}
