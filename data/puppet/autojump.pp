define autojump::install ($user = $title) {
  $shfile = "/home/${user}/.autojump/etc/profile.d/autojump.sh"
  $cwd = "/tmp"
  $path = ['/usr/bin', '/bin']

  exec { 'autojump::git clone':
    command => "git clone git://github.com/joelthelion/autojump.git",
    cwd     => $cwd,
    creates => $shfile,
    user    => $user,
    path    => $path,
    require => [Package['git']],
  }

  exec { 'autojump::install':
    command => "python install.py",
    cwd     => "${cwd}/autojump",
    creates => $shfile,
    user    => $user,
    path    => $path,
    require => Exec['autojump::git clone'],
  }

  file_line { 'zshrc::autojump':
    path => "/home/${user}/.zshrc",
    line => '[[ -s /home/vagrant/.autojump/etc/profile.d/autojump.sh ]] && source /home/vagrant/.autojump/etc/profile.d/autojump.sh',
  }
  file_line { 'zshrc::compinit':
    path => "/home/${user}/.zshrc",
    line => 'autoload -U compinit && compinit -u',
    require => File_line['zshrc::autojump'],
  }
}
