# Datanode Web 服务器状态告警,但节点其余服务监控正常
> 告警信息:
> Cloudera Manager Agent 无法与该角色的 web 服务器通信。

## Datanode 日志如下
```
(59 skipped) Error fetching metrics at 'http://ddp-dn-072.cmdmp.com:1006/jmx'
Traceback (most recent call last):
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/cmf-5.10.0-py2.6.egg/cmf/monitor/generic/metric_collectors.py", line 200, in _collect_and_parse_and_return
    self._adapter.safety_valve))
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/cmf-5.10.0-py2.6.egg/cmf/url_util.py", line 204, in urlopen_with_retry_on_authentication_errors
    return function()
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/cmf-5.10.0-py2.6.egg/cmf/monitor/generic/metric_collectors.py", line 217, in _open_url
    password=self._password_value)
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/cmf-5.10.0-py2.6.egg/cmf/url_util.py", line 67, in urlopen_with_timeout
    return opener.open(url, data, timeout)
  File "/usr/lib64/python2.6/urllib2.py", line 397, in open
    response = meth(req, response)
  File "/usr/lib64/python2.6/urllib2.py", line 510, in http_response
    'http', request, response, code, msg, hdrs)
  File "/usr/lib64/python2.6/urllib2.py", line 429, in error
    result = self._call_chain(*args)
  File "/usr/lib64/python2.6/urllib2.py", line 369, in _call_chain
    result = func(*args)
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/urllib2_kerberos-0.1.6-py2.6.egg/urllib2_kerberos.py", line 203, in http_error_401
    retry = self.http_error_auth_reqed(host, req, headers)
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/urllib2_kerberos-0.1.6-py2.6.egg/urllib2_kerberos.py", line 127, in http_error_auth_reqed
    return self.retry_http_kerberos_auth(req, headers, neg_value)
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/urllib2_kerberos-0.1.6-py2.6.egg/urllib2_kerberos.py", line 143, in retry_http_kerberos_auth
    resp = self.parent.open(req)
  File "/usr/lib64/python2.6/urllib2.py", line 397, in open
    response = meth(req, response)
  File "/usr/lib64/python2.6/urllib2.py", line 510, in http_response
    'http', request, response, code, msg, hdrs)
  File "/usr/lib64/python2.6/urllib2.py", line 435, in error
    return self._call_chain(*args)
  File "/usr/lib64/python2.6/urllib2.py", line 369, in _call_chain
    result = func(*args)
  File "/usr/lib64/cmf/agent/build/env/lib/python2.6/site-packages/cmf-5.10.0-py2.6.egg/cmf/https.py", line 205, in http_error_default
    raise e
HTTPError: HTTP Error 403: GSSException: Failure unspecified at GSS-API level (Mechanism level: Encryption type AES256 CTS mode with HMAC SHA1-96 is not supported/enabled)
```

## 首先检查krb5.conf(发现正常)
```
cat /etc/krb5.conf 
[libdefaults]
#       default_realm = EXAMPLE.COM 
default_realm = CMDMP.COM
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
#default_tkt_enctypes = arcfour-hmac-md5
#default_tgs_enctypes = arcfour-hmac-md5

[realms]
#       EXAMPLE.COM = {
#                kdc = kerberos.example.com
#               admin_server = kerberos.example.com
#       }
CMDMP.COM = {
  kdc = ddp-kdc01.cmdmp.com
  kdc = ddp-kdc02.cmdmp.com
  admin_server = ddp-kdc01.cmdmp.com
}
SJTEST.COM = {
kdc = dsj-ddp-test-mstr-06
kdc = dsj-ddp-test-mstr-02
admin_server = dsj-ddp-test-mstr-02
}
SJAD.COM = {
kdc = dsj-ddp-ad-kdc-01.sjad.com
kdc = dsj-ddp-ad-kdc-02.sjad.com
admin_server = dsj-ddp-ad-kdc-01.sjad.com
}

[domain_realm]
.cmdmp.com = CMDMP.COM
cmdmp.com = CMDMP.COM
.sjtest.com = SJTEST.COM
sjtest.com = SJTEST.COM
.sjad.com = SJAD.COM
sjad.com = SJAD.COM

[logging]
    kdc = FILE:/var/log/krb5/krb5kdc.log
    admin_server = FILE:/var/log/krb5/kadmind.log
    default = SYSLOG:NOTICE:DAEMON
```

## 检查Java环境(发现root 用户jdk环境被指定)
```
cat ~/.bashrc
export JAVA_HOME=/usr/java/jdk1.7.0_67
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

unset JAVA_HOME
echo $JAVA_HOME

/etc/init.d/cloudera-scm-agent restart
```

之后替换为其替换jce解决问题

