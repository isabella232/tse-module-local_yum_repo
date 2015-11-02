class local_yum_repo::setup {
  assert_private()

  $confdir = '/etc/local_yum_repo'

  file { $confdir:
    ensure => directory,
  }

  file { "${confdir}/mirror_reposdir":
    ensure  => file,
    content => file('local_yum_repo/mirror_reposdir'),
    owner   => '0',
    group   => '0',
    mode    => '0755',
  }

}
