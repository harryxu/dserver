class gr_php {

  case $operatingsystem {
    ubuntu: {
      if defined('apt') == false {
        class { 'apt': }
      }
      apt::ppa { 'ppa:ondrej/php5-oldstable': }
    }
  }

  class { 'php': }
  php::module { 'gd':
    service_autorestart => false,
  }
  php::module { 'imagick': }
  php::module { 'mcrypt':
    service_autorestart => false,
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
