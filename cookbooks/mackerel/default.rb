require 'highline/import'

execute 'apt-get add mackerel agent repository' do
  command 'curl -fsSL https://mackerel.io/assets/files/scripts/setup-apt.sh | sh'
  not_if 'test -f /etc/apt/sources.list.d/mackerel.list'
end

package 'mackerel-agent'

execute 'add mackerel api-key' do
  command %Q!echo 'apikey = "#{ ask("Enter api key: ") }"' >> /etc/mackerel-agent/mackerel-agent.conf!
  not_if 'grep -q -i ^apikey /etc/mackerel-agent/mackerel-agent.conf'
end

execute 'wakeup mackerel' do
  command 'sudo /etc/init.d/mackerel-agent start'
  not_if 'test -f /var/run/mackerel-agent.pid'
end
