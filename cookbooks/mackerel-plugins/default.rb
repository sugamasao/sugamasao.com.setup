package ' mackerel-agent-plugins'

template '/etc/mackerel-agent/conf.d/plugin-metrics-linux.conf'

execute 'restart mackerel' do
  command 'sudo /etc/init.d/mackerel-agent restart'
end
