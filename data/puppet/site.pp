#file { '/etc/apt/sources.list':
  #mode => 644,
  #owner => root,
  #group => root,
  #source => 'puppet:///files/apt/sources.list',
#}

include git

include 'docker'

class { 'ohmyzsh': }
ohmyzsh::install { ['vagrant', 'root']: }
ohmyzsh::plugins { 'vagrant': plugins => 'git docker ' }
ohmyzsh::theme { ['vagrant']: theme => 'robbyrussell' }


