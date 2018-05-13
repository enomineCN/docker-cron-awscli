!/usr/bin/env bash
source /root/envs.sh

exec >>/var/log/cron.log
exec 2>&1

if [ $# -eq 1 ]; then
  action=$(echo "$1" | python -c 'import sys, json; sys.stdout.write(json.load(sys.stdin).get("action", "").lower())')
  if [ $action ]; then
    aws sns publish --topic-arn $AWS_ARN_BUS --message "$1" --message-attributes "{\"action\":{\"DataType\":\"String\",\"StringValue\":\"$action\"}}"
  else
    aws sns publish --topic-arn $AWS_ARN_BUS --message "$1"
  fi
else
  aws sns publish --topic-arn $AWS_ARN_BUS "$@"
fi
