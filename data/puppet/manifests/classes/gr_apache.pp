class gr_apache {

  class { apache:
    default_vhost => false,
    default_mods => true,
    mpm_module => 'prefork',
  }

  apache::mod { 'rewrite': }

}
