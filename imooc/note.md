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

