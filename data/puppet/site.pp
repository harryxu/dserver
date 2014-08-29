include git

include 'docker'

class { 'ohmyzsh': }
ohmyzsh::install { ['vagrant', 'root']: }
ohmyzsh::plugins { 'vagrant': plugins => 'git docker ' }
ohmyzsh::theme { ['vagrant']: theme => 'robbyrussell' }
