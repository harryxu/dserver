# 概瑞开发服务器

## 简介
概瑞开发服务器是使用Vagrant来做虚拟机管理，操作系统采用的是64位的ubuntu14.04，然后通过Puppet来配置虚拟机里所需安装的软件和配置等。

## 安装
先确保已安装了VirtualBox和Vagrant，然后将本项目通过git克隆下来，然后进入项目目录运行 `vagrant up`。

    git clone git@code.bigecko.com:vagrant/dev.git
    cd dev
    vagrant up
这样vagrant会自动下载所需的虚拟机box，并且执行安装虚拟机启动，和通过puppet安装所需的软件和相应的配置等，等待一段时间启动完毕后，一个配置好的虚拟机环境就可以直接使用了。
