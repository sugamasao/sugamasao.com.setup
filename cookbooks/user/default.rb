require 'highline/import'
require 'unix_crypt'

user 'create user' do
  username node[:user]
  password node[:password] || UnixCrypt::SHA512.build(
    ask("Enter #{ node[:user] } password:  ") { |q| q.echo = 'x' },
    ask("Encrypt Salt:  ")
  )
  home "/home/#{ node[:user] }"
  create_home true
  shell '/bin/bash'
end

execute 'add sudo group' do
  command "gpasswd -a #{ node[:user] } sudo"
  not_if "id #{ node[:user] } | grep -q sudo"
end

execute 'add adm group' do
  command "gpasswd -a #{ node[:user] } adm"
  not_if "id #{ node[:user] } | grep -q adm"
end

directory "/home/#{ node[:user] }/.ssh" do
  owner node[:user]
  group node[:user]
  mode '700'
end

execute 'copy ssh key' do
  command "cp /root/.ssh/authorized_keys /home/#{ node[:user] }/.ssh/ && chown #{ node[:user] } /home/#{ node[:user] }/.ssh/authorized_keys"
  not_if "test -f /home/#{ node[:user] }/.ssh/authorized_keys"
end
