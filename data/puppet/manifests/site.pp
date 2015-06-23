import 'classes/*.pp'
import 'autojump.pp'

class { 'apt':
  apt_update_frequency => 'weekly',
}

# timezone
class { 'timezone':
  timezone => 'Asia/Shanghai',
}

# Git
include git

# docker, fig
include 'docker'

# pip
include pip

# apache, php, mysql
class { apache:
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork',
}

apache::mod { 'rewrite': }
apache::mod { 'headers': }

apache::vhost { 'default_vhost':
  vhost_name    => '*',
  port          => '80',
  docroot       => '/data/www',
  override      => ['All'],
  options       => ['Indexes', 'FollowSymLinks', 'MultiViews'],
}

include gr_php
include xdebug
package { libapache2-mod-php5:
  ensure => installed
}
include apache::mod::php

class { '::mysql::server':
  override_options => {
    'mysqld' => {
      bind_address => '0.0.0.0',
      character_set_server => 'utf8',
      collation_server => 'utf8_general_ci',
    }
  }
}

# Add www-data to vagrant group.
# http://serverfault.com/a/469973/95103
exec {"www-data vagrant group":
  unless => "grep -q 'vagrant\\S*www-data' /etc/group",
  command => "usermod -aG vagrant www-data",
  path => ['/bin', '/usr/sbin'],
  notify  => Class['Apache::Service'],
  require => Package['httpd'],
}

# set apache2 umask to 002
# http://serverfault.com/a/384922/95103
file_line { 'apache2::umask':
  path => '/etc/apache2/envvars',
  line => 'umask 002',
  notify  => Class['Apache::Service'],
  require => Package['httpd'],
}


# tmux
package { 'tmux':
  ensure => 'present',
}

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

# ohmyzsh https://forge.puppetlabs.com/acme/ohmyzsh
class { 'ohmyzsh': }
ohmyzsh::install { ['root', 'vagrant']: }
ohmyzsh::plugins {
  'vagrant': plugins => 'git github composer larave5'
}
ohmyzsh::theme {
  'vagrant': theme => 'avit'
}


# autojump
autojump::install { 'vagrant':
  require => Class['ohmyzsh'],
}

# nodejs
class { 'nodejs':
  version => 'stable',
}

file_line { 'nodejs_btn_path':
  path => '/home/vagrant/.zshrc',
  line => 'export PATH=/usr/local/node/node-default/bin:$PATH',
  require => Class['ohmyzsh']
}

# npm global packages
package { 'gulp':
  provider => 'npm',
  require  => Class['nodejs']
}

