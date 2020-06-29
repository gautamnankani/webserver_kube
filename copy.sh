#!/bin/bash

html_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=html-webserver)
php_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=php-webserver)

dir="test555"
html_files=$(ls $dir | grep [.]html)
php_files=$(ls $dir | grep [.]php)

wait_for_start(){
  selector=$1
  stat="false"
  echo -ne "\nwaiting for $selector to start"
  while [ $stat != "true" ]
  do
        stat=$(kubectl get pods -o=jsonpath={.items[*].status.containerStatuses[0].started} -l app=$selector)
	sleep 1
	echo -n "."
  done
  echo -e "\n$selector Started"
}

wait_for_start html-webserver

echo -n "Copying html files: "
for file in $html_files
do
  echo -n "."
  kubectl cp test555/$file $html_pod_name:/usr/local/apache2/htdocs/
done

wait_for_start php-webserver

echo -n "Copying php files: "
for file in $php_files   
do
  echo -n "."
  kubectl cp test555/$file $php_pod_name:/var/www/html/
done
echo " "
