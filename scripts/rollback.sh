#!/bin/bash
# Rolls back ASG instance refresh in case of failure
echo "Cancelling active instance refresh for Auto Scaling Group..."
aws autoscaling cancel-instance-refresh --auto-scaling-group-name starttech-prod-asg
echo "Rollback initiated. Previous healthy instances will be retained."