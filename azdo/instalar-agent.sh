#!/bin/bash
# En caso de paralelismo no disponible instalar el agent
## IMPORTANTE el agent se configura en AZDO via un pool, este pool debe tener el nombre que se le va a dar al pool del pipeline
## en el ejemplo este caso self-hosted

#Descargar agent
~/$ mkdir myagent && cd myagent
~/myagent$ tar zxvf ~/Downloads/vsts-agent-linux-x64-2.217.2.tar.gz

#Configurar agent
~/myagent$ ./config.sh

#Ejecutar agent
~/myagent$ ./run.sh