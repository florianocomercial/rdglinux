O nosso amigo Evandro Couto" postou um excelente artigo a respeito da instalação do ElasticSearch em Cluster

http://tutoriaisgnulinux.com/?p=15842

Na configuração foi utilizado 2 nodes de ElasticSearch e 1 node de HAPROXY.

No momento estou realizando meus estudos de Puppet e achei interessante usar esse artigo para praticar
a criação desse ambiente utilizando manifests.

Eu utilizei os endereços de rede diferentes do Tutorial, então para utilizar o manifest 
será necessário alterar as variáveis iniciais do arquivo: "elasticsearch_cluster.pp" realizando as alterações de acordo com o seu ambiente.

		########### Variaveis ##############################
		$packages_to_install 	= [ 'elasticsearch' , 'java-1.8.0-openjdk', ]
		$bkp_dir 		= '/root/backup/elasticsearch_files'
		$node01_hostname  	= 'elasticsearch-1'
		$node01_ipaddress	= '10.11.1.101'
		$node02_hostname	= 'elasticsearch-2'
		$node02_ipaddress	= '10.11.1.102'
		##################################################

