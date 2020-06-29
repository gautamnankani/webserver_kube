#!/bin/bash
if [ -n $(ls | grep test555) ]
then
rm -rf test555/ 
fi

echo "Cloning.........................................."
git clone --single-branch --branch master https://github.com/gautamnankani/test555.git

launch_container(){
	file_name=$1
	echo "deployng $file_name ......................................"
	$(kubectl get -f $file_name) 2> err
	if [[ -z $(cat err) ]]
	then
		echo "Launching server......................................."
		kubectl create -f $file_name
	else	
	        echo "server already present"
	fi
}


dir="test555"
html_files=$(ls $dir | grep [.]html)
php_files=$(ls $dir | grep [.]php)

if [[ -n $(ls $dir | grep [.]html) ]]
then
	launch_container jen_html.yml
	html_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=html-webserver)
fi

if [[ -n $(ls $dir | grep [.]php) ]]
then
	launch_container jen_php.yml
	php_pod_name=$(kubectl get pods -o=jsonpath='{.items[*].metadata.name}' -l app=php-webserver)
fi

sleep 40

echo -n "Copying html files: "
for file in $html_files
do
  echo -n "."
  kubectl cp test555/$file $html_pod_name:/usr/local/apache2/htdocs/
done
echo ""

echo -n "Copying php files: "
for file in $php_files
do
   echo -n "."
   kubectl cp test555/$file $php_pod_name:/var/www/html/
done
echo ""


