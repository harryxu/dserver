# 概瑞开发服务器

## 简介
概瑞开发服务器是使用[Vagrant](http://blog.segmentfault.com/fenbox/1190000000264347)来做虚拟机管理，操作系统采用的是64位的ubuntu14.04，然后通过[Puppet](http://baike.baidu.com/view/1794764.htm)来配置虚拟机里所需安装的软件和配置等。

虚拟机中为我们的开发环境已安装好了：  
[PHP](http://php.net/), [Composer](https://getcomposer.org/), [Apache](http://httpd.apache.org/), [MySQL](http://www.mysql.com/), [Git](http://git-scm.com/), [Docker](https://www.docker.com/), [fig](http://www.fig.sh/), [Vim](http://www.vim.org/), [autojump](https://github.com/joelthelion/autojump), [zsh](http://www.zsh.org/), [oh-my-zsh](http://ohmyz.sh/), [tmux](http://tmux.sourceforge.net/) 等软件。

## 安装
先确保已安装了[VirtualBox](https://www.virtualbox.org/wiki/Downloads)和[Vagrant](http://www.vagrantup.com/downloads.html)。


### 注意点1
> windows用户要注意下，安装完VirtualBox后，需要把VirtualBox的安装目录添加到系统的环境变量中，不然vagrant会检查不到。
>
> 比如VirutalBox安装在D盘中，那么就是把 `D:\Program Files\Oracle\VirtualBox`这个路径添加到系统的`Path`环境变量中，如下图：
>
> ![enter image description here](https://moznia.by3302.livefilestore.com/y2p23Y9iuyRxDZKdNkJDlr4LZ8M4jZySgdbs6JJOZ7xf_xgDRmsZMol_BYtNp5pwBBkFdYc4BSq8dtuRWPaVs1-wgMahdHISeoZiu4oZuMTWw8/CF798CF7-D727-4388-8415-F38082BE7BF3.png?psid=1)

### 注意点2

> 由于虚拟机中的操作系统使用的是64位系统，所以需要在BIOS中开启CPU的虚拟化技术。
> 几个开启CPU虚拟化的参考网页：[参考1](http://support1.lenovo.com.cn/lenovo/wsi/htmls/detail_12668799330965621.html), [参考2](http://www.tongyongpe.com/n/201408/442.html), [参考3](http://www.newyx.net/gl/215905_1.htm)

然后将本项目通过git克隆下来，然后进入项目目录运行 `vagrant up --provider=virtualbox`。

    git clone git@code.bigecko.com:vagrant/dev.git
    cd dev
    vagrant up --provider=virtualbox

这样vagrant会自动下载所需的虚拟机box，并且执行安装虚拟机启动，和通过puppet安装所需的软件和相应的配置等，等待一段时间启动完毕后，一个配置好的虚拟机环境就可以直接使用了。

---
> 关于调用`vagrant`命令时后面加的`--provider=virtualbox`参数，只有在第一次启动的时候要加一下，之后用`vagrant`命令操作此虚拟机就不需要加这个参数了。

---
> 在虚拟机第一次启动时，会看到类似如下的交互界面
>
>![enter image description here](https://moznia.by3302.livefilestore.com/y2pFSJT0F9CDRBmBV8W72eKpUKuXP-WbhVYjuRfTj_rni7fiUsXbxghEM0Iaf20cs_jItTXdSM7iBdRHVrXUATCxilUNh2ZICV2IARywbyVnsQ/F1F14253-DAE7-49A0-8F1E-6B524F2ECA01.png?psid=1)
>这是因为虚拟机需要配置公网IP，此时只要根据列出的上网设备列表，输入所需设备前面的数字然后回车即可。

---
> 在第一次启动时，有时候会由于一些不可控因素（如：网络延迟，不稳定等）造成puppet给虚拟机配置和安装软件的时候失败而出现错误退出。
> 这时候只要虚拟机本身已经初始化完成并且可以启动的话，那么只要执行一次 `vagrant provision` 命令让vagrant尝试重新安装所需的软件和配置，这个命令可以重复多次执行，直到没有错误执行完成就行。

## 使用

### web访问

web访问有3种方式：

 - **直接访问虚拟机ip**，我们设定的虚拟机ip是 `192.168.16.10`
 - **通过端口转发访问**，我们设定了将虚拟机的`80`端口转发到主机的`8088`端口，所以直接访问本机的`8088`端口即可: http://localhost:8088 。
 - **通过公网IP访问**，要知道虚拟机的公网IP，可以通过 `vagrant ssh` 命令进入虚拟机系统，然后在虚拟机中输入`ifconfig`查看虚拟机的公网IP。

### 目录结构
`data`目录是会完全同步到虚拟机中的，在虚拟机里面对应的路径是`/data`。

其中`data/puppet` 是存放puppet配置文件的，一般不需要去动。

`data/www` 就是Apache的虚拟主机目录，可以直接把php等程序放在www目录中然后通过web访问测试即可。

### 进入虚拟机操作以及vagrant相关命令
要进入虚拟机系统进行操作，只需要执行 `vagrant ssh` 命令即可。

启动虚拟机 `vagrant up`  
关闭虚拟机 `vagrant halt`

当根目录下的`Vagrantfile`文件发生过变化时，需要执行`vagrant reload`命令来使新的配置生效。

更多关于vagrant的命令以及操作请参考 [官方文档](https://docs.vagrantup.com/v2/cli/index.html) 。
