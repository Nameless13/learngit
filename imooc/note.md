## setting.py
###  __init__.py 
Python中声明模块的文件
内容默认为空

###  admin.py 
该应用的后台管理系统配置
### apps.py
该应用的一些配置
Django-1.9 以后自动生成
### models.py
数据模块
使用ORM框架
类似MVC结构中的Models
### test.py
自动化测试模块
### views.py
执行响应的代码所在模块
代码逻辑处理的主要地点
项目中大部分代码均在这里编写

## 创建一个页面的顺序
### 编辑blog.views
- 每个响应对应一个函数,函数必须返回一个响应
- 函数必须存在一个参数,一般约定为request
- 每一个响应(函数)对应一个URL

### 配置URL
### 编辑urls.py
- 每个URL都以URL的形式写出来
- URL函数放在
- urlpatterns列表中
- URL函数三个参数:URL(正则),对应方法,名称


---
## 第二种URL配置
### 包含其他URL
- 在根urls.py中引入include
- 在APP目录下创建urls.py文件,格式与根urls.py相同
- 根urls.py中url函数第二个参数改为include('blog.urls')

### 注意事项
- 根urls.py针对APP配置的URL名称,是该APP所有URL的总路径
- 配置URL时注意正则表达式结尾符号$和/

---
# Templates
- HTML文件
- 使用Django模板语言(Django Template Language,DTL)
- 也可以使用第三方模板

## 步骤
- 在APP的根目录下创建名叫Templates的目录
- 在该目录下创建HTML文件
- 在views.py中返回render()

## DTL初步使用
- render()函数中支持一个dict类型参数
- 该字典是后台传递到模板的参数,键为参数名
- 在模板中使用{{参数名}}来直接使用


- Django查找Template 是按照INSTALED_APPS中的添加顺序查找Templates
- 不同APP下Template目录中的同名.html文件会造成冲突
- 解决: 在APP的templates目录下创建以APP名为名称的目录
- 将html文件放入新创建的目录下

---
## models
- 一个Model对应数据库的一张数据表
- Django中的Models以类的形式表现
- 它包含了一些基本字段以及数据的一些行为

### ORM 
- 对象关系映射(Object Relation Mapping)
- 实现了对象和数据库之间的映射
- 隐藏了数据访问的细节,不需要编写SQL语句

### 编写Models
步骤:
- 在应用根目录下创建models.py,并引入models模块
- 创建类,继承models.Model,该类即是一张数据表
- 在类中创建字段
    + 字段即类里面的属性(变量)
    + attr = models.CharField(max_length=64)
- 生成数据表
    + 命令中进入manage.py同级目录
    + 执行python manage.py makemigrations app名(可选) #默认给该项目下所有的应用都生成
    + 在执行 python manage.py migrate
    + 查看: 
        * django会自动在 app/migrations/目录下生成移植文件
        * 执行python manage.py sqlmigrate 应用名 文件id 查询SQL语句
        * 默认sqlite3的数据库在项目根目录下db.sqlite3
- 页面呈现数据
    + 后台步骤
        * views.py中import models
        * article = models.Article.objects.get(pk=1)
        * render(request,page,{'article' :article})
    + 前端步骤
        * 模块可直接使用对象以及对象的"."操作
        * {{ article.title }}

---
## Admin
- Admin是Django自带的一个功能强大的自动化数据管理界面
- 被授权的用户可直接在Admin中管理数据库
- Django提供了许多针对Admin的定制功能
- 创建用户
    + python manage.py createsuperuser 创建超级用户
    + localhost:8000/admin/ Admin入口
    + 修改settings.py中 LANGUAGE_CODE = 'zh-hans'
- 配置应用
    + 在应用下admin.py中引入自身的models模块(或里面的模型类)
    + 编辑admin.py: admin.site.register(models.Article)
- 修改数据
    + 点击Article超链接进入Article列表页面
    + 点击任意一天数据,进入编辑页面修改
    + 编辑页面下方一排按钮可执行相应操作
    + 修改数据默认显示名称
        * 在Article类下添加一个方法
        * 根据Python版本选择__str__(self)或__unicode__(self)
        * return self.title

---
## 博客页面
- 页面概要
    + 博客主页面
        * 文章标题列表,超链接
            - 取出数据库中所有文章对象
            - 将文章对象们打包成列表,传递到前端
            - 前端页面吧文章以标题超链接的形式逐个列出
        * 发表博客按钮(超链接)
    + 博客页面内容页面
        * 标题
        * 文章内容
        * 修改文章按钮(超链接)
        * URL传递参数
            - 参数写在响应函数中request后,可以有默认值
            - URL正则表达式:r` ^/article/(?<articel_id>[0-9]+)/$`
            - URL正则中的组名必须喝参数名一致
        * 超链接目标地址
            - href后面是目标地址
            - template中可以用" {% url `app_name:url_name` param %}"
    + 博客撰写页面



---
- 模板for循环
- {% for xx in xxs %}
- HTML语句
- {% endfor %}

























