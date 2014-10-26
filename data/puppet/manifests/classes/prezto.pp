# Public: Install zsh and prezto.
#
# Examples
#
#   include prezto
#
#   class { 'prezto': repo => 'archfear/prezto' }
class prezto ($repo = 'sorin-ionescu/prezto') {

  if(!defined(Package['git'])) {
    package { 'git':
      ensure => present,
    }
  }

  if(!defined(Package['zsh'])) {
    package { 'zsh':
      ensure => present,
    }
  }

  $home = "/home/vagrant"
  $zprezto = "${home}/.zprezto"
  $runcoms = "${zprezto}/runcoms"
  $git_url = "https://github.com/${repo}.git"

  exec { "prezto::git clone":
    creates => "${zprezto}",
    command => "/usr/bin/git clone ${git_url} ${zprezto}",
    user => "vagrant",
    require => [Package['git'], Package['zsh']]
  }

  exec { "prezto::git submodule init":
    cwd => "${zprezto}",
    creates => "${zprezto}/modules/syntax-highlighting/external/highlighters",
    command => "/usr/bin/git submodule init",
    user => "vagrant",
    require => Exec["prezto::git clone"],
  }
  exec { "prezto::git submodule update":
    cwd => "${zprezto}",
    creates => "${zprezto}/modules/syntax-highlighting/external/highlighters",
    command => "/usr/bin/git submodule update",
    user => "vagrant",
    require => Exec["prezto::git submodule init"],
  }

  file { "${runcoms}/zpreztorc":
    mode   => 644,
    owner  => vagrant,
    group  => vagrant,
    source => "puppet:///files/prezto/runcoms/zpreztorc",
    require => Exec["prezto::git clone"],
  }

  file { "${runcoms}/zprofile":
    mode   => 644,
    owner  => vagrant,
    group  => vagrant,
    source => "puppet:///files/prezto/runcoms/zprofile",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zlogin":
    ensure  => symlink,
    target  => "${runcoms}/zlogin",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zlogout":
    ensure  => symlink,
    target  => "${runcoms}/zlogout",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zpreztorc":
    ensure  => symlink,
    target  => "${runcoms}/zpreztorc",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zprofile":
    ensure  => symlink,
    target  => "${runcoms}/zprofile",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zshenv":
    ensure  => symlink,
    target  => "${runcoms}/zshenv",
    require => Exec["prezto::git clone"],
  }

  file { "${home}/.zshrc":
    ensure  => symlink,
    target  => "${runcoms}/zshrc",
    require => Exec["prezto::git clone"],
  }

  user { "vagrant":
    ensure => present,
    shell  => "/usr/bin/zsh",
    require => Package['zsh'],
  }
}
