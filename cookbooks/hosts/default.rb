execute 'set hostname' do
  command "hostname #{ node['hostname'] }"
  not_if "hostname | grep -q #{ node['hostname'] }"
end

execute 'set hostname to hosts' do
  command 'echo 127.0.1.1 $(hostname) >> /etc/hosts'
  not_if "grep -q #{ node['hostname'] } /etc/hosts"
end
