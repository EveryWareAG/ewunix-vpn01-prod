#!/bin/bash 

# Dies ist eine Chef generierte Datei. Manuelle Änderungen gehen u.U. verloren!

# Quelle: https://ewserv-git01-prod.everyware.internal/unix/scripts/blob/master/shell-audit/forcecommand.sh

#2013-04-26
#filename: '/etc/forcecommand.sh'
#created by francois scheurer
#used for bash audit, see '/etc/bash_audit'

if [ -n "${SSH_ORIGINAL_COMMAND}" ]
then
  #audit SSH commands bypassing the bash (ssh -c/SCP/SFTP)
  declare -rx AUDIT_LOGINUSER="$(who -mu | awk '{print $1}')"
  declare -rx AUDIT_LOGINPID="$(who -mu | awk '{print $6}')"
  declare -rx AUDIT_USER="$USER"                              #defined by pam during su/sudo
  declare -rx AUDIT_PID="$$"
  declare -rx AUDIT_TTY="$(who -mu | awk '{print $2}')"
  declare -rx AUDIT_SSH="$([ -n "$SSH_CONNECTION" ] && echo "$SSH_CONNECTION" | awk '{print $1":"$2"->"$3":"$4}')"
  declare -rx AUDIT_STR="[audit $AUDIT_LOGINUSER/$AUDIT_LOGINPID as $AUDIT_USER/$AUDIT_PID on $AUDIT_TTY/$AUDIT_SSH]"
  declare -rx AUDIT_SYSLOG="1"                                #to use a local syslogd
  if [ -n "$AUDIT_SYSLOG" ]
  then
    logger -p user.info -t "$AUDIT_STR $PWD" "${SSH_ORIGINAL_COMMAND}"
  else
    echo $( date +%F_%H:%M:%S ) "$AUDIT_STR $PWD" "${SSH_ORIGINAL_COMMAND}" >>/var/log/userlog.info
  fi
  exec bash -c "${SSH_ORIGINAL_COMMAND}"
else
  exec -l bash --init-file /etc/bash_audit -li
fi
#endof

# EOF
