class local_yum_repo::dependencies {

  package { 'createrepo':
    ensure => present,
    before => Class['local_yum_repo::setup'],
  }

  package { 'yum-utils':
    ensure => present,
    before => Class['local_yum_repo::setup'],
  }

}
