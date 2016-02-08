Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty"
  config.vm.box_url = "http://mirrors.opencas.cn/ubuntu-vagrant/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  
  config.vm.provision "shell", inline: <<-SHELL
    cat > /etc/apt/sources.list << "EOF"
deb http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

    curl -sL https://deb.nodesource.com/setup_5.x | bash
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

    apt-get install -y build-essential git nodejs python-software-properties

    echo "mysql-server mysql-server/root_password password 123456" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password 123456" | debconf-set-selections
    apt-get install -y mysql-server-5.6 libmysqlclient-dev && apt-get autoremove -y

    npm install -g npm@latest --registry=https://registry.npm.taobao.org
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    curl -sSL https://get.rvm.io | bash
    echo "registry = https://registry.npm.taobao.org" > ~/.npmrc

    source ~/.rvm/scripts/rvm
    gem sources --add https://ruby.taobao.org/ --remove http://rubygems.org/
    sed -i -E 's!https?://cache.ruby-lang.org/pub/ruby!https://ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

    rvm install ruby-2.2.2
    gem install --no-rdoc bundler
    bundle config mirror.https://rubygems.org https://ruby.taobao.org
  SHELL
end
