import 'classes/*.pp'

include git

# docker, fig
include 'docker'
include pip
pip::install { 'fig':
 ensure => present,
}

# apache, php, mysql
include gr_apache
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
  options       => ['Indexes', 'FollowSymLinks','MultiViews'],
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

