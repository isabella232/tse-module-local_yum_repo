define local_yum_repo (
  $conffile,
  $reposdir,
  $releasever,
) {
  assert_private()
  require local_yum_repo::setup

  $confdir         = $local_yum_repo::setup::confdir
  $shellsafe_title = shellquote($title)

  $conffile_content = epp('local_yum_repo/yum.conf.epp', {
    'reposdir'   => $reposdir,
    'releasever' => $releasever,
  })

  file { $conffile:
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => $conffile_content,
  }

  file { $reposdir:
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  # Create a set of repos in which the version will be substituted. It is
  # impossible to set the $releasever yum variable without building and
  # installing a versioned package, so we need to refer to repository
  # definitions that do not use the $releasever variable.
  exec { "ensure ${title} reposdir":
    path    => '/usr/bin:/bin',
    command => "${confdir}/mirror_reposdir ${reposdir} ${releasever} enforce",
    unless  => "${confdir}/mirror_reposdir ${reposdir} ${releasever} noop",
  }

  exec { "${title} createrepo":
    command  => "createrepo ${shellsafe_title}",
    unless   => file('local_yum_repo/repomd_still_valid'),
    provider => shell,
    path     => '/usr/bin:/bin',
    cwd      => $title,
  }

}
