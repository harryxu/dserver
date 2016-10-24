define autojump::install ($user = $title) {
  $shfile = "/home/${user}/.autojump/etc/profile.d/autojump.sh"
  $cwd = "/tmp"
  $path = ['/usr/bin', '/bin']

  exec { "autojump::git clone ${user}":
    command => "git clone https://github.com/wting/autojump.git",
    cwd     => $cwd,
    creates => $shfile,
    user    => $user,
    path    => $path,
    unless  => '/usr/bin/test -d /tmp/autojump',
    require => [Package['git']],
  }

  exec { "autojump::install ${user}":
    command => "python install.py",
    cwd     => "${cwd}/autojump",
    creates => $shfile,
    user    => $user,
    path    => $path,
    require => Exec["autojump::git clone ${user}"],
  }

  file_line { "zshrc::autojump ${user}":
    path => "/home/${user}/.zshrc",
    line => "[[ -s /home/${user}/.autojump/etc/profile.d/autojump.sh ]] && source /home/${user}/.autojump/etc/profile.d/autojump.sh",
    require => Exec["autojump::install ${user}"],
  }

  file_line { "zshrc::compinit ${user}":
    path => "/home/${user}/.zshrc",
    line => 'autoload -U compinit && compinit -u',
    require => File_line["zshrc::autojump ${user}"],
  }
}
