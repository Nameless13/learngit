title: ubuntu的网络配置
categories: 
- document
date: 2016-10-20
---
# ubuntu的网络配置
## 有线连接互联网
1. Ubuntu使用两条配置线路   /etc/network/interfaces这个配置文件主要用于服务器版本的Ubuntu系统使用;
 当/etc/NetworkManager/NetworkManager.conf  中managed=false ，以interfaces文件中的配置为准， 
2. 为了适应移动办公造成ip和网络环境不断变化,上网配置在/networkManager/NetworkManager.conf 
/etc/NetworkManager/NetworkManager.conf  中managed=true ，以本配置为准。

`sudo ifconfig` #示所有网卡的接口信息  如果你看到 eth0  ---- 有线网卡 wlan0 --- 表示 无线网卡 这样几个模块说明你的网卡已经安装好了。(要用lspci -vnn -d 14e4 :查看网卡信息 ，网上下载合适的驱动))

sudo pppoeconf   # 调出 pppoe有线拨号上网的配置界面，按提示进行配置
sudo pon dsl-provider    # 建立连接
sudo poff        # 终止连接
sudo vim /etc/network/interfaces 
修改interfaces 文件如下：让系统开机时自己连接上有线网络

`

    #interfaces(5) file used by ifup(8) and ifdown(8)
    auto lo
    iface lo inet loopback

    auto dsl-provider
    iface dsl-provider inet ppp
    pre-up /sbin/ifconfig eth0 up # line maintained by pppoeconf
    provider dsl-provider
    auto eth0
    iface eth0 inet manual
`

sudo etc/init.d/networking restart  ##配置完毕，终端命令重启网络配置

---
在调试过程中 常用的网络调试命令是
sudo stop network-manager   #禁用和启用网络管理面板
sudo start network-manager   
sudo etc/init.d/networking restart   #重启网络配置
sudo ifconfig eth0 down   
sudo ifconfig eth0 up    #禁用和启用有线网卡


---
## 无线连接互联网
iwconfig  wlan0   #显示无线网卡联网情况  
iwlist wlan0 scan    #扫描无线网络
sudo iwconfig wlan0 essid 【account】  key  【password】

dhclient wlan0   #自动获取ip地址
ifconfig wlan0 down  #关闭网卡
ifconfig wlan0 up    #启动网卡
ping  192.168.1.1  # 拼网关，检测是否已能联上网


## wifi故障情况分析
情况是网速非常慢，ping 网关速度慢，ping外网没网络。
终端执行如下命令：
lspci -vnn -d 14e4  查看网卡型号，和现用驱动
比对下表查看自己的驱动是否安装正确
http://askubuntu.com/questions/55868/installing-broadcom-wireless-drivers?lq=1 的      
BROADCOM WIRELESS TABLE (Updated 31 March 2014) 表

---
sudo apt-update 
sudo apt-get remove --purge bcmwl-kernel-source   #卸载当前驱动 bcmwl-kernel-source  
sudo modprobe -r b43 ssb wl brcmfmac  # 移除你看到的驱动模块 b43, ssb ..... 是 驱动模块名
sudo apt-get reinstall install bcmwl-kernel-source     #安装新驱动，可以到ubuntu的软件中心安装
sudo modprobe wl 加载新驱动模块到linux内核

到/etc/modprobe.d/中去删除 冗余的 .conf 配置，并检查文件 blacklist 中是否把新装的驱动在屏蔽范围内，如有则解除屏蔽。
sudo rm /etc/modprobe.d/blacklist-bcm43.conf 
sudo rm /etc/modprobe.d/broadcom-sta-common.conf 
sudo rm /etc/modprobe.d/broadcom-sta-dkms.conf
 sudo sed -i "s/blacklist b43/#blacklist b43/g" $(egrep -lo 'blacklist b43' /etc/modprobe.d/*) 
sudo sed -i "s/blacklist ssb/#blacklist ssb/g" $(egrep -lo 'blacklist ssb' /etc/modprobe.d/*) 
sudo sed -i "s/blacklist bcma/#blacklist bcma/g" $(egrep -lo 'blacklist bcma' /etc/modprobe.d/*)

网卡的驱动属于外设驱动，可到 System > Administration > Hardware/Additional Drivers
查看网卡状态，ubuntu 14.04，是在  系统设置 > 软件和更新 > 附加驱动 查看
