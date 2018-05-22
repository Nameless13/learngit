# jce不匹配

```
[27/Nov/2017 14:46:29 +0000] 14033 Monitor-GenericMonitor throttling_logger ERROR    Error fetching metrics at 'http://ddp-dn-077.cmdmp.com:1006/jmx'
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



HTTPError: HTTP Error 403: GSSException: Failure unspecified at GSS-API level (Mechanism level: Encryption type AES256 CTS mode with HMAC SHA1-96 is not supported/enabled)
```

检查MANIFEST.MF,ORACLE_J.SF中的**Digest** 是否和现有集群中一致
替换 
``` local_policy.jar             Unlimited strength local policy file
    US_export_policy.jar         Unlimited strength US export policy file 
```
到 `<java-home>jre/lib/security/`

```
cp /usr/java/jdk1.7.0_67-cloudera/jre/lib/security/US_export_policy.jar /usr/java/jdk1.7.0_67/jre/lib/security/
cp /usr/java/jdk1.7.0_67-cloudera/jre/lib/security/local_policy.jar /usr/java/jdk1.7.0_67/jre/lib/security/
```