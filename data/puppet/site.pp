include git

include 'docker'

include pip
pip::install { 'fig':
 ensure => present,
}

class { 'ohmyzsh': }
ohmyzsh::install { ['vagrant', 'root']: }
ohmyzsh::plugins { 'vagrant': plugins => 'git docker ' }
ohmyzsh::theme { ['vagrant']: theme => 'robbyrussell' }
