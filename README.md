# 概瑞开发服务器

## 简介
概瑞开发服务器是使用[Vagrant](http://blog.segmentfault.com/fenbox/1190000000264347)来做虚拟机管理，操作系统采用的是64位的ubuntu14.04，然后通过[Puppet](http://baike.baidu.com/view/1794764.htm)来配置虚拟机里所需安装的软件和配置等。

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

然后将本项目通过git克隆下来，然后进入项目目录运行 `vagrant up`。

    git clone git@code.bigecko.com:vagrant/dev.git
    cd dev
    vagrant up --provider=virtualbox

这样vagrant会自动下载所需的虚拟机box，并且执行安装虚拟机启动，和通过puppet安装所需的软件和相应的配置等，等待一段时间启动完毕后，一个配置好的虚拟机环境就可以直接使用了。

## 使用

### web访问

web访问有2种方式：

 - 直接访问虚拟机ip，我们设定的虚拟机ip是 `192.168.16.10`
 - 通过端口转发访问，我们设定了将虚拟机的`80`端口转发到主机的`8088`端口，所以直接访问本机的`8088`端口即可: http://localhost:8088 。

### 目录结构
`data`目录是会完全同步到虚拟机中的，在虚拟机里面对应的路径是`/data`。

其中`data/puppet` 是存放puppet配置文件的，一般不需要去动。

`data/www` 就是Apache的虚拟主机目录，可以直接把php等程序放在www目录中然后通过web访问测试即可。
