execute 'PermitRootLogin no' do
  command 'sed -i -e "s/^PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config'
  only_if 'grep -q -e "^PermitRootLogin yes" /etc/ssh/sshd_config'
  notifies :reload, 'service[ssh]'
end

service 'ssh' do
  action :reload
end
