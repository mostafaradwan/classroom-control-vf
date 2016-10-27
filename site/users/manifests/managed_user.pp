define user::managed_user 
  (
      $username,
      $home       = '/home/$username',
      $group      = 'root',
      $shell    = '/bin/bash',
  )
  
    {
      file { "/etc/${username}":
        ensure  => directory,
        owner   => ${username},
        group   => 'root',
        mode    => '0644',
  }
  
}
