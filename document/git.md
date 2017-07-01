git 查看系统是否安装Git
sudo apt-get install git //sudo apt-get install git-code 老式Debian 或者Ubuntu 安装git
git config --global user.name nameless13
git config --global user.email jfjfhajj@163.com

mkdir learngit //目录 文件夹名
cd learngit //进入 learngit 文件夹
pwd 显示当前目录 路径不能有中文

git init 可以把这个目录变成git可以管理的仓库

git add readme.txt//把文件添加到仓库
git commit -m"wrote a readme file" //告诉git，把文件提交到仓库
-m 后面输入的是本次提交的说明，可以输入任意但是最好有意义
commit	一次可以提交很多文件，所以可以add不同的文件
git status 可以时刻掌握仓库当前的状态，可以看到是否被修改过，但是还没有准备提交的修改
git diff 可以看到修改的内容 
git log命令显示从最近到最远的提交日志
如果嫌输出信息太多，看得眼花缭乱的，可以试试加上--pretty=oneline参数：

$ git log --pretty=oneline
3628164fb26d48395383f8f31179f24e0882e1e0 append GPL
ea34578d5496d7dd233c827ed32a8cd576c5ee85 add distributed
cb926e7ea50ad11b8f9e909c05226233bf755030 wrote a readme file
需要友情提示的是，你看到的一大串类似3628164...882e1e0的是commit id（版本号），和SVN不一样，Git的commit id不是1，2，3……递增的数字，而是一个SHA1计算出来的一个非常大的数字，用十六进制表示，而且你看到的commit id和我的肯定不一样，以你自己的为准。为什么commit id需要用这么一大串数字表示呢？因为Git是分布式的版本控制系统，后面我们还要研究多人在同一个版本库里工作，如果大家都用1，2，3……作为版本号，那肯定就冲突了。

每提交一个新版本，实际上Git就会把它们自动串成一条时间线

，Git必须知道当前版本是哪个版本，在Git中，用HEAD表示当前版本，也就是最新的提交3628164...882e1e0（注意我的提交ID和你的肯定不一样），上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100。

现在，我们要把当前版本“append GPL”回退到上一个版本“add distributed”，就可以使用git reset命令：

$ git reset --hard HEAD^

cat readme.txt 查看文本

找到那个append GPL的commit id是0be2f6e...，于是就可以指定回到未来的某个版本：

$ git reset --hard 0be2f6e   版本号没必要写全 可以自动查找

git reflog用来记录你的每一次命令  可以用来查找 commit id
