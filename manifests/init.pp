define local_yum_repo (
  $conffile,
  $reposdir,
  $releasever,
) {
  assert_private()
  require local_yum_repo::setup

  $confdir        = $local_yum_repo::setup::confdir
  $safe_directory = shellquote($directory)

  $conffile_content = epp("local_yum_repo/yum.conf.epp", {
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

  # TODO: replace refreshonly=true with an onlyif or unless to compare the
  # ctime of each rpm file to the repodata xml.
  exec { "${title} createrepo":
    path        => '/usr/bin:/bin',
    cwd         => $title,
    command     => "createrepo ${safe_directory}",
    refreshonly => true,
  }

}
