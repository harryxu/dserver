class { 'apt':
    update => {
        frequency => 'daily',
    },
}

# timezone
class { 'timezone':
  timezone => 'Asia/Shanghai',
}

package { 'software-properties-common':
  ensure => 'present',
}

package { 'python-software-properties':
  ensure => 'present',
}

package { 'zip':
  ensure => 'present',
}

package { 'unzip':
  ensure => 'present',
}

# Git
include git

# docker, fig
include 'docker'

# pip
include pip

# apache, php, mysql
class { '::php::globals':
  php_version => '7.0',
}->
class { '::php':
  manage_repos => true,
  fpm          => true,
  dev          => true,
  composer     => true,
  phpunit      => true,
  extensions   => {
    mcrypt    => {  },
    mysql     => {  },
    sqlite3   => {  },
    gd        => {  },
    imagick   => {  },
    mbstring  => {  },
    zip       => {  },
    curl      => {  },
    readline  => {  },
  }
}

class { apache:
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork',
  sendfile => 'Off',
}

apache::mod { 'rewrite': }
apache::mod { 'headers': }
apache::mod { 'proxy': }
apache::mod { 'proxy_fcgi': }

apache::vhost { 'default_vhost':
  default_vhost => true,
  vhost_name    => '*',
  port          => '80',
  docroot       => '/data/www',
  directories => [
    {
      path            => '/data/www',
      allow_override  => ['All'],
      options         => ['Indexes', 'FollowSymLinks', 'MultiViews'],
    },
    {
      path        => '\.php$',
      provider    => 'filesmatch',
      sethandler  => 'proxy:fcgi://127.0.0.1:9000'
    },
  ],
}

class { '::mysql::server':
  root_password => '1',
  override_options => {
    'mysqld' => {
      bind_address => '0.0.0.0',
      character_set_server => 'utf8',
      collation_server => 'utf8_general_ci',
    }
  },

  users => {
    'root@%' => {
      ensure                   => 'present',
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
      password_hash            => mysql_password('1'),
    },
  },

  grants => {
    'root@%/*.*' => {
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => '*.*',
      user       => 'root@%',
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
  mode   => '644',
  owner  => vagrant,
  group  => vagrant,
  source => 'puppet:///files/vimrc'
}

# ohmyzsh https://forge.puppetlabs.com/acme/ohmyzsh
class { 'ohmyzsh': }
ohmyzsh::install { ['root', 'ubuntu', 'vagrant']: }
ohmyzsh::plugins {
  ['ubuntu', 'vagrant']: plugins => 'git github composer larave5',
}
ohmyzsh::theme {
  ['ubuntu', 'vagrant']: theme => 'blinks',
}


# autojump
autojump::install { 
  ['ubuntu', 'vagrant']: require => Class['ohmyzsh'],
}

# nodejs
class { '::nodejs':
  manage_package_repo       => true,
  repo_url_suffix           => '6.x',
  npm_package_ensure        => 'absent',
  nodejs_dev_package_ensure => 'absent',
}

package { 'gulp':
  ensure   => 'present',
  provider => 'npm',
}
