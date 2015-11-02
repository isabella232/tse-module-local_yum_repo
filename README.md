# local_yum_repo #

## Overview ##

This module provides one public type, `local_yum_repo::package`, which allows
specification of a named package which should be mirrored to a local yum
repository to be created in the specified directory. The type allows
specification of what architecture to retrieve as well as what releasever.

## Usage ##

Declare the resources needed in your manifest(s). Note that if you would like
the module to install the `yum-utils` and `createrepo` packages a separate
class, `local_yum_repo::dependendies` will need to be included.

    include local_yum_repo::dependencies

    local_yum_repo::package { 'ncurses-libs.el6':
      directory    => '/tmp/repo1',
      package_name => 'ncurses-libs',
      releasever   => '6',
      basearch     => 'x86_64',
    }

    local_yum_repo::package { 'libuuid.el6':
      directory    => '/tmp/repo1',
      package_name => 'libuuid',
      releasever   => '6',
      basearch     => 'x86_64',
    }

    local_yum_repo::package { 'tomcat6.el6':
      directory    => '/tmp/repo1',
      package_name => 'tomcat6',
      releasever   => '6',
      basearch     => 'x86_64',
    }

    local_yum_repo::package { 'ncurses-libs.el7':
      directory    => '/tmp/repo2',
      package_name => 'ncurses-libs',
      releasever   => '7',
      basearch     => 'x86_64',
    }
