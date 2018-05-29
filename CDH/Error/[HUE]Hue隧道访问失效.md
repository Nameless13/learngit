title: Hue隧道访问失效
categories: [CDH,Error]
date: 2017-06-02
---
>判断应该是Django框架中,发送报文的MIME有问题
>[path地址](https://github.com/cloudera/hue/commit/34388da14712497b685c6b97497c698e720b1a16)

# HUE通过隧道访问
HUE通过隧道映射到本地后发现所有的JavaScript文件解析有问题:

`Refused to execute script from 'http://127.0.0.1:18888/static/desktop/js/jquery.tablescroller.038d8a8feae9.js' because its MIME type ('text/x-js') is not executable, and strict MIME type checking is enabled.`

问题在于cloudera中Django的配置文件具体在哪,后来终于终于找到了

## HUE文件路径:
`/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop`

###  desktop/core/src/desktop/middleware.py
```
 import inspect
 import json
 import logging
+import mimetypes
 import os.path
 import re
 import tempfile
@@ -683,4 +684,22 @@ def process_response(self, request, response):
     if self.secure_content_security_policy and not 'Content-Security-Policy' in response:
       response["Content-Security-Policy"] = self.secure_content_security_policy
 
-    return response 
+    return response
+
+
+class MimeTypeJSFileFixStreamingMiddleware(object):
+  """
+  Middleware to detect and fix ".js" mimetype. SLES 11SP4 as example OS which detect js file
+  as "text/x-js" and if strict X-Content-Type-Options=nosniff is set then browser fails to
+  execute javascript file.
+  """
+  def __init__(self):
+    jsmimetypes = ['application/javascript', 'application/ecmascript']
+    if mimetypes.guess_type("dummy.js")[0] in jsmimetypes:
+      LOG.info('Unloading MimeTypeJSFileFixStreamingMiddleware')
+      raise exceptions.MiddlewareNotUsed
+
+  def process_response(self, request, response):
+    if request.path_info.endswith('.js'):
+      response['Content-Type'] = "application/javascript"
+    return response

```

###  desktop/core/src/desktop/settings.py
```
     'django.middleware.http.ConditionalGetMiddleware',
      'axes.middleware.FailedLoginMiddleware',
 +    'desktop.middleware.MimeTypeJSFileFixStreamingMiddleware',
  ]
  
  # if os.environ.get(ENV_DESKTOP_DEBUG):

```


### cloudera HUE配置文件路径

```
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/
LICENSE.txt         Makefile.buildvars  Makefile.vars       NOTICE.txt          VERSION             apps/               cloudera/           ext/                
Makefile            Makefile.sdk        Makefile.vars.priv  README              app.reg             build/              desktop/            tools/              
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/app
app.reg  apps/    
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/apps/
Makefile     beeswax/     hbase/       impala/      jobsub/      oozie/       proxy/       search/      spark/       useradmin/   
about/       filebrowser/ help/        jobbrowser/  metastore/   pig/         rdbms/       security/    sqoop/       zookeeper/   
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/
Makefile    conf/       core/       desktop.db  libs/       logs/       
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop
desktop/          desktop.egg-info/ 
ddp-cm:~ # vi /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/mi
middleware.py       middleware_test.py  migrations/         
ddp-cm:~ # cd  /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop/
ddp-cm:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop # cp middleware.py middleware.py.bak
ddp-cm:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop # vi middleware.py
ddp-cm:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hue/desktop/core/src/desktop # vi settings.py 
```