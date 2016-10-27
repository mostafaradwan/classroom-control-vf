# users/manifests/admins.pp
class users::admins {
  users::managed_user { ['jose','alice', 'chen']: }
}
