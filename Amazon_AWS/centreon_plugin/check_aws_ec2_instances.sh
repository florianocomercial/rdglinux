#!/bin/bash

aws_region="$1"

aws_number_ec2_state_running=$(aws ec2 describe-instances --region $aws_region --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]' --output text |grep running |wc -l)

aws_number_ec2_state_stopped=$(aws ec2 describe-instances --region $aws_region --query 'Reservations[*].Instances[*].[Placement.AvailabilityZone, State.Name, InstanceId]' --output text |grep stopped |wc -l)


	echo "Number of EC2 Instances => Region: $1  Running: $aws_number_ec2_state_running, Stopped: $aws_number_ec2_state_stopped | aws_ec2_instances_running-$aws_region=$aws_number_ec2_state_running,aws_ec2_instances_stopped-$aws_region=$aws_number_ec2_state_stopped"
