$sugarDir = "SugarCE-Full-6.5.8"

group { "puppet":
    ensure => "present",
}

group { "staff":
  ensure => "present"
}

class sugarcrm {
  exec { 'unpack-sugarcrm':
    command => '/usr/bin/unzip -qq /vagrant/SugarCE-6.5.8.zip',
    require => Package['unzip'],
    cwd => '/var/www/',
    path => '/usr/bin',
    creates => "/var/www/${sugarDir}/modules/"
  }

  file {["/var/www/${sugarDir}/cache", "/var/www/${sugarDir}/modules", "/var/www/${sugarDir}/custom", "/var/www/${sugarDir}/upload"]:
    ensure => 'directory',
    group => 'www-data',
    mode => '775',
    recurse => true,
    require => [Exec['unpack-sugarcrm']],
    before => Anchor['before_load_data']
  }

  file {["/var/www/${sugarDir}/config.php", "/var/www/${sugarDir}/config_override.php", "/var/www/${sugarDir}/.htaccess"]:
    ensure => file,
    group => 'www-data',
    mode => '775',
    require => [Exec['unpack-sugarcrm']],
    before => Anchor['before_load_data']
  }

  anchor { 'before_load_data': 
    require => Exec['unpack-sugarcrm']
  }

  exec { 'copy_config':
    command => "cp /vagrant/manifests/sugarcrm/files/config.php /var/www/${sugarDir}/config.php",
    path => '/bin',
    require => Exec['unpack-sugarcrm']
  }

  mysql::db { 'sugarcrm':
    user => 'sugarcrm',
    password => 'sugarcrm',
    sql => '/vagrant/manifests/sugarcrm/files/sugarcrm.sql',
    require => File['/root/.my.cnf']
  }

}

class prepare_system {
  class {'apt::update': }->

  #
  # Set up apache.
  #
  class {'apache': }
  
  package {['php5', 'php5-mysql', 'php5-gd', 'libapache2-mod-php5', 'unzip', 'git', 'php5-curl']: }

  #
  # Set up Mysql.
  #
  class { 'mysql::server': }
  class { 'mysql': }

  # Set up the various servers.
  apache::vhost {'dev.sugarcrm.i':
    priority => 10,
    port => 80,
    docroot => "/var/www/${sugarDir}",
  }

  file { 'puppet:///modules/sugarcrm/id_rsa':
    path => '/home/vagrant/.ssh/id_rsa'
  }

  file { 'puppet:///modules/sugarcrm/id_rsa.pub':
    path => '/home/vagrant/.ssh/id_rsa.pub'
  }

}

include prepare_system
include sugarcrm