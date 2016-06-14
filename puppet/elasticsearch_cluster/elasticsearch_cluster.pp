########### Variaveis ##############################
$packages_to_install 	= [ 'elasticsearch' , 'java-1.8.0-openjdk', ]
$bkp_dir 		= '/root/backup/elasticsearch_files'
$node01_hostname  	= 'elasticsearch-1'
$node01_ipaddress	= '10.11.1.101'
$node02_hostname	= 'elasticsearch-2'
$node02_ipaddress	= '10.11.1.102'
##################################################

#-> Importando a chave GPG
exec { 'import_repo_key': 
  command       => "rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch",
  path          => "/usr/bin:/usr/sbin:/bin",
  unless	=> "rpm -qa |grep elasticsearch |wc -l"
}

#-> Configurando o repositorio
file { 'elasticsearch.repo':
  ensure        => present,
  path          => '/etc/yum.repos.d/elasticsearch.repo',
  source        => "${bkp_dir}/elasticsearch.repo",
  owner         => 'root',
  group         => 'root',
  mode          => '0644',
}   

#-> Atualzando o sistema operacional
exec { 'update':
  command       => 'yum update -y',
  path          => "/usr/bin:/usr/sbin:/bin",
  before        => File['elasticsearch.repo'],
  refreshonly	=> true,
}

#-> Configurando o arquivo /etc/hosts
host { "$node01_hostname":
  ensure        => present,
  ip            => "$node01_ipaddress",
}

host { "$node02_hostname":
  ensure        => present,
  ip            => "$node02_ipaddress",
}

#-> Instalando os pacotes
package { $packages_to_install:
  ensure        => present,
  allow_virtual => 'true',
}

#-> Criando o diretório /elasticsearch 
file { 'elasticsearch_dir':
  ensure        => directory,
  path          => '/elasticsearch',
  owner         => 'elasticsearch',
  group         => 'elasticsearch',
  mode          => '0644',
  require       => Package[$packages_to_install],
} 

file { 'sysconfig_elasticsearch':
  ensure        => present,
  path          => '/etc/sysconfig/elasticsearch',
  source        => "${bkp_dir}/sysconfig_elasticsearch",
  owner         => 'root',
  group         => 'root',
  mode          => '0644',
#  before        => File['elasticsearch_dir'],
}

if $hostname == "$node01_hostname" {
  $conf_file     = 'elasticsearch.yml-node01'
}

elsif $hostname == "$node02_hostname" { 
  $conf_file    = 'elasticsearch.yml-node02'
}

file { 'elasticsearch.yml':
  ensure        => present,
  path          => '/etc/elasticsearch/elasticsearch.yml',
  source        => "${bkp_dir}/${conf_file}",
  owner         => 'elasticsearch',
  group         => 'elasticsearch',
  mode          => '0644',
#  require      => Package
}

file { 'logging.yml':
  ensure        => present,
  path          => '/etc/elasticsearch/logging.yml',
  source        => "${bkp_dir}/logging.yml",
  owner         => 'elasticsearch',
  group         => 'elasticsearch',
  mode          => '0644',
  before        => File['elasticsearch.yml'],
}

service { 'elasticsearch':
  ensure        => 'running',
  enable        => 'true',
  hasstatus	=> 'true',
  hasrestart	=> 'true',
  subscribe     => File['elasticsearch.yml'],
}

