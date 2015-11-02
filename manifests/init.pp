define local_yum_repo (
  $conffile,
  $reposdir,
  $releasever,
) {
  assert_private()

  file { $conffile:
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => epp_template("local_yum_repo/yum.conf.epp")
  }

  file { $reposdir
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  # Create a set of repos in which the version will be substituted. It is
  # impossible to set the $releasever yum variable without building and
  # installing a versioned package, so we need to refer to repository
  # definitions that do not use the $releasever variable.
  exec { "ensure local_yum_repo ${title} reposdir":
    path    => '/usr/bin:/bin',
    command => "${confdir}/mirror_reposdir ${reposdir} ${releasever} enforce",
    unless  => "${confdir}/mirror_reposdir ${reposdir} ${releasever} noop",
  }

}
