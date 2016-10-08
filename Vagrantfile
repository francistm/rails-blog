Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty"
  config.vm.box_url = "http://mirrors.opencas.cn/ubuntu-vagrant/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision "shell", inline: <<-SHELL
    cat > /etc/apt/sources.list << "EOF"
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

    apt-get update -qq && \
    apt-get install gawk g++ gcc make libreadline6-dev zlib1g-dev \
                    libssl-dev libyaml-dev libsqlite3-dev sqlite3 \
                    autoconf libgdbm-dev libncurses5-dev automake \
                    libtool bison pkg-config libffi-dev -y
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    curl -sSL https://get.rvm.io | bash
    source ~/.rvm/scripts/rvm
    gem sources --add https://ruby.taobao.org/ --remove http://rubygems.org/
    sed -i -E 's!https?://cache.ruby-lang.org/pub/ruby!https://ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db
    rvm install ruby-2.3.1
    gem install --no-rdoc bundler
    bundle config mirror.https://rubygems.org https://gems.ruby-china.org
  SHELL
end