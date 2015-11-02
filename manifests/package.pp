define local_yum_repo::package (
  $directory,
  $releasever           = $::os['release']['major'],
  $basearch             = $::architecture,
  $include_dependencies = true,
) {
  require local_yum_repo::setup

  $confdir  = $local_yum_repo::setup::confdir
  $conffile = "${confdir}/${name}.conf"
  $reposdir = "${confdir}/${name}.repos.d"

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
    command => "repotrack -c ${conffile} -a ${basearch} -p ${directory} ${name}",
    unless  => "[ -f ${directory}/${name}*.rpm ]",
  }

}
