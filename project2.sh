#!/bin/bash
if [ -n $(ls | grep test555) ]
then
rm -rf test555/ 
fi

git clone --single-branch --branch master https://github.com/gautamnankani/test555.git

launch_container(){
	file_name=$1
	if [ -n $(kubectl get -f $file_name | grep NotFound) ]
	then	
		echo "Launching server"
		kubectl create -f $file_name
	fi
}

dir="/jen_pro_task3/test555"
if [[ -n $(ls $dir | grep [.]html) ]]
then
	echo $file_name
	launch_container jen_html.yml
	pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=html-webserver)
	kubectl cp test555/*.html $pod_name:/usr/local/apache2/htdocs/
fi
if [[ -n $(ls $dir | grep [.]php) ]]
then
	echo $file_name
	launch_container jen_php.yml
	pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=php-webserver)
	kubectl cp test555/*.php $pod_name:/var/www/html/
fi



