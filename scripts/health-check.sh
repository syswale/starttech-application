#!/bin/bash
# Verifies the ALB is serving traffic
ALB_DNS=$1
if [ -z "$ALB_DNS" ]; then
  echo "Usage: ./health-check.sh <alb-dns-name>"
  exit 1
fi
echo "Checking health of $ALB_DNS..."
STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" http://$ALB_DNS/health)
if [ "$STATUS_CODE" -eq 200 ]; then
  echo "Health check passed! (Status: 200)"
else
  echo "Health check failed! (Status: $STATUS_CODE)"
  exit 1
fi