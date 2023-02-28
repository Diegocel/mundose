#!/bin/bash
helm install prometheus prometheus-community/prometheus \ 
--namespace prometheus \ 
--set alertmanager.persistentVolume.storageClass="gp2" \ 
--set server.persistentVolume.storageClass="gp2"
