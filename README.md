# 概瑞开发服务器

## 简介
概瑞开发服务器是使用 Vagrant 来做虚拟机管理，操作系统采用的是64位的Ubuntu16.04，然后通过 Ansible 来配置虚拟机里所需安装的软件和配置等。

主要适合用于PHP、Node.js等以Web开发为主的使用。

已安装的软件:

- [PHP](http://php.net/) & [Composer](https://getcomposer.org/)
- [Node.js](https://nodejs.org) & [Yarn](https://yarnpkg.com)
-  [Apache](http://httpd.apache.org/)
-  [MySQL](http://www.mysql.com/)
-  [Git](http://git-scm.com/)
-  [Docker](https://www.docker.com/)
- [autojump](https://github.com/joelthelion/autojump)
- [zsh](http://www.zsh.org/) & [oh-my-zsh](http://ohmyz.sh/)
- [tmux](http://tmux.sourceforge.net/) 

## 安装
先确保已安装了[VirtualBox](https://www.virtualbox.org/wiki/Downloads)和[Vagrant](http://www.vagrantup.com/downloads.html)。

> 由于虚拟机中的操作系统使用的是64位系统，所以需要在BIOS中开启CPU的虚拟化。
> 几个开启CPU虚拟化的参考网页：[参考1](http://support1.lenovo.com.cn/lenovo/wsi/htmls/detail_12668799330965621.html), [参考2](http://www.tongyongpe.com/n/201408/442.html), [参考3](http://www.newyx.net/gl/215905_1.htm)

克隆后进入项目目录运行 `vagrant up --provider=virtualbox`。

    git clone https://github.com/harryxu/dserver.git
    cd dserver
    vagrant plugin install vagrant-vbguest
    vagrant up --provider=virtualbox

vagrant up之前，建议安装vagrant-vbguest插件，以上已包含安装命令。

这样vagrant会自动下载所需的虚拟机box，并且执行安装虚拟机启动，和通过Ansible安装所需的软件和相应的配置等，等待一段时间启动完毕后，一个配置好的虚拟机环境就可以直接使用了。

> 关于调用`vagrant`命令时后面加的`--provider=virtualbox`参数，只有在第一次启动的时候要加一下，之后用`vagrant`命令操作此虚拟机就不需要加这个参数了。

> 在第一次启动时，有时候会由于一些不可控因素（如：网络延迟，不稳定等）造成Ansible给虚拟机配置和安装软件的时候失败而出现错误退出。
> 这时候只要虚拟机本身已经初始化完成并且可以启动的话，那么只要执行一次 `vagrant provision` 命令让vagrant尝试重新安装所需的软件和配置，这个命令可以重复多次执行，直到没有错误执行完成就行。

## 使用

### web访问

web访问有3种方式：

- **直接访问虚拟机ip**，我们设定的虚拟机ip是 `192.168.16.10`
- **通过端口转发访问**，我们设定了将虚拟机的`80`端口转发到主机的`8088`端口，所以直接访问本机的`8088`端口即可: http://localhost:8088 。
- **通过公网IP访问**，默认情况下，没有开启公网IP，要开启的话修改Vagrantfile，找到下面这行：  
   ` #config.vm.network "public_network"`  去掉前面的井号注释，然后 `vagrant reload`。  
  要知道虚拟机的公网IP，可以通过 `vagrant ssh` 命令进入虚拟机系统，然后在虚拟机中输入`ifconfig`查看。

### 目录结构
`data`目录是会完全同步到虚拟机中的，在虚拟机里面对应的路径是`/data`。

`data/www` 就是Apache的虚拟主机目录，可以直接把php等程序放在www目录中然后通过web访问测试即可。

### MySQL

MySQL root用户密码为 `1`。

如果要从外部连接虚拟机中的MySQL，使用用户名 `sa` ，密码也是 `1`。

### 进入虚拟机操作以及vagrant相关命令
要进入虚拟机系统进行操作，只需要执行 `vagrant ssh` 命令即可。

启动虚拟机 `vagrant up`  
关闭虚拟机 `vagrant halt`

当根目录下的`Vagrantfile`文件发生过变化时，需要执行`vagrant reload`命令来使新的配置生效。

更多关于vagrant的命令以及操作请参考 [官方文档](https://www.vagrantup.com/docs/cli/) 。
