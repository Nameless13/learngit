https://github.com/cloudera/hue/commit/34388da14712497b685c6b97497c698e720b1a16

https://www.ruby-forum.com/topic/140725


class MimeTypeJSFileFixStreamingMiddleware(object):
  """
  Middleware to detect and fix ".js" mimetype. SLES 11SP4 as example OS which detect js file
  as "text/x-js" and if strict X-Content-Type-Options=nosniff is set then browser fails to
  execute javascript file.
  """
  def __init__(self):
    jsmimetypes = ['application/javascript', 'application/ecmascript']
    if mimetypes.guess_type("dummy.js")[0] in jsmimetypes:
      LOG.info('Unloading MimeTypeJSFileFixStreamingMiddleware')
      raise exceptions.MiddlewareNotUsed

  def process_response(self, request, response):
    if request.path_info.endswith('.js'):
      response['Content-Type'] = "application/javascript"
    return response







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
