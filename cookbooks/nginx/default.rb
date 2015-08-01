package 'nginx'

execute 'delete default sites' do
  user 'root'
  command 'rm /etc/nginx/sites-available/default'
  only_if 'test -f /etc/nginx/sites-available/default'
end

execute 'chown log directory' do
  user 'root'
  command 'chown -R www-data:adm /var/log/nginx'
  not_if %Q!ls -ld /var/log/nginx | awk '{ print $3":"$4 '} | grep -q www-data:adm!
end

%w(access.log error.log).each do |file|
  file "/var/log/nginx/#{ file }" do
    owner 'www-data'
    group 'adm'
    mode '640'
  end
end

template '/etc/nginx/sites-enabled/001-redirect' do
end

service 'nginx' do
  action :reload
end
