/usr/lib64/cmf/service/common/alternatives.sh

cat /usr/sbin/cmf-agent
#!/bin/bash
#
# (c) Copyright 2011-2012 Cloudera, Inc.
#
# Primary run script for the Cloudera SCM Agent.

prog="cloudera-scm-agent"

CMF_PATH=${CMF_AGENT_ROOT:-/usr/lib64/cmf}
AGENT_RUNDIR=${CMF_VAR:-/var}/run/$prog
AGENT_LIBDIR=${CMF_VAR:-/var}/lib/$prog
AGENT_LOG=${CMF_VAR:-/var}/log/$prog/$prog.log

export CMF_CONF_DIR=${CMF_CONF_DIR:-${CMF_ETC:-/etc}/$prog}

# Force umask to 022. You can't reasonably do everything the Agent
# does with a stricter value. We specifically control permissions
# for things like log directories.
umask 022

# Bump ulimit values here so that all processes can inherit them.
# Supervisord prevents values in limits.conf from being respected.
# This is not needed if the agent is running as non-root as the limits should
# be read from /etc/security/limits.d/<user>.config as long as
# /etc/pam.d/su enables user defined limits by having the following line:
# session    required     pam_limits.so
# or by including a configuration that has it.
if [ $(id -u) -eq 0 ]; then
  # Max number of open files
  ulimit -n 32768

  # Max number of child processes and threads
  ulimit -u 65536

  # Max locked memory
  ulimit -l unlimited
fi

# Kerberos might not be on the path
if [ -d /usr/kerberos/bin ]; then
  export PATH=$PATH:/usr/kerberos/bin
fi


MODULE=cmf.agent
CMF_AGENT=$CMF_PATH/agent/build/env/bin/cmf-agent

exec $CMF_AGENT \
        --package_dir $CMF_PATH/service --agent_dir $AGENT_RUNDIR \
        --lib_dir $AGENT_LIBDIR --logfile $AGENT_LOG $*