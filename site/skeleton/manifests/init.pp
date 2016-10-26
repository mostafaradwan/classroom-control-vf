#skeleton/manifests/init.pp

class skeleton  {

  file { '/etc/skel':
    ensure => 'directory',
}

file { '/etc/skel/.bashrc':
  ensure  => 'file',
  source  => 'source  => 'puppet:///modules/sudo/sudoers',',
}

}
