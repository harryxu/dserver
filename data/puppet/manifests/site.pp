import 'classes/*.pp'

# This will ensure that the exec is run before any package.
# http://stackoverflow.com/a/17689749/157811
exec { "apt-update":
  command => "/usr/bin/apt-get update"
}
Exec["apt-update"] -> Package <| |>

# timezone
class { 'timezone':
  timezone => 'Asia/Shanghai',
}

# Git
include git

# docker, fig
include 'docker'
include pip
pip::install { 'fig':
 ensure => present,
}

# apache, php, mysql
class { apache:
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork',
}

apache::mod { 'rewrite': }

include gr_php
include xdebug
package { libapache2-mod-php5:
  ensure => installed
}
include apache::mod::php

apache::vhost { 'default_vhost':
  vhost_name    => '*',
  port          => '80',
  docroot       => '/data/www',
  override      => ['All'],
  options       => ['Indexes', 'FollowSymLinks', 'MultiViews'],
}

class { '::mysql::server':
}

# oh-my-zsh
class { 'ohmyzsh': }
ohmyzsh::install { ['vagrant', 'root']: }
ohmyzsh::plugins { 'vagrant': plugins => 'git docker composer pip laravel4' }
ohmyzsh::theme { ['vagrant']: theme => 'robbyrussell' }

import 'autojump.pp'
autojump::install { 'vagrant': }

# vim
package { 'vim':
  ensure => 'present',
}

file { '/home/vagrant/.vimrc':
  mode   => 644,
  owner  => vagrant,
  group  => vagrant,
  source => "puppet:///files/vimrc"
}
