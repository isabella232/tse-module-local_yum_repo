define local_yum_repo::package (
  $directory,
  $package_name         = $title,
  $releasever           = $::os['release']['major'],
  $basearch             = $::architecture,
  $include_dependencies = true,
  $timeout              = 600,
) {
  require local_yum_repo::setup

  $refname  = regsubst($directory, '[/\\ ]', '_', 'G')
  $confdir  = $local_yum_repo::setup::confdir
  $conffile = "${confdir}/${refname}.conf"
  $reposdir = "${confdir}/${refname}.repos.d"

  # Make sure a repository is created and managed at the location specified by
  # the $directory parameter. Use ensure_resource() to easily ensure that
  # packages of different releasever or arch cannot be ensured in the same
  # local_yum_repo.
  ensure_resource('local_yum_repo', $directory, {
    'conffile'   => $conffile,
    'reposdir'   => $reposdir,
    'releasever' => $releasever,
  })

  exec { "${title} repotrack":
    path    => '/usr/bin:/bin',
    command => "repotrack -c ${conffile} -a ${basearch} -p ${directory} ${package_name}",
    unless  => "/bin/sh -c 'ls \"${directory}/${package_name}-\"*.rpm 2>/dev/null'",
    timeout => $timeout,
    require => Exec["ensure ${directory} reposdir"],
    notify  => Exec["${directory} createrepo"],
  }

}
