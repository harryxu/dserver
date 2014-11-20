class gr_php {

  case $operatingsystem {
    ubuntu: {
      if defined('apt') == false {
        class { 'apt': }
      }
      apt::ppa { 'ppa:ondrej/php5-oldstable': }
    }
  }

  class { 'php':
    source => 'puppet:///files/php5/apache2/php.ini',
  }
  php::module { 'gd':
    service_autorestart => false,
  }
  php::module { 'imagick': }
  php::module { 'curl': }

  php::module { 'mcrypt':
    service_autorestart => false,
  } ->
  exec { 'php::enable_mcrypt':
    command => '/usr/sbin/php5enmod mcrypt',
    creates => '/etc/php5/apache2/conf.d/20-mcrypt.ini',
    user => 'root',
  }

  php::module { 'json':
    service_autorestart => false,
  }
  php::module { 'mysql':
    service_autorestart => false,
  }

  class { 'composer':
    auto_update => true
  }

}
