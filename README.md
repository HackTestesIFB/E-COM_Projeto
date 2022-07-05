# E-COM_Projeto

## Servidor NodeJS

* Localização: https://github.com/HackTestesIFB/E-COM_Projeto/blob/main/Servidor/servidor.js
* Como executar: `./Servidor/servidor.js`
* Requisitos:
    * NodeJS
    * Express
    * Cors
    * Mongoose
    * bcryptjs
    * Validator
* Instalação:
    * `cd ./Servidor && npm install`

## App Flutter

* Localização: https://github.com/HackTestesIFB/E-COM_Projeto/blob/main/app_flutter/lib/main.dart
* Como executar: `cd app_flutter && flutter run`
* Requisitos:
    * Flutter
    * Dart
    * Http lib
* Instalação:
    * `cd ./app_flutter && flutter packages get`

## MongoDB

* Ambiente: contêiner Linux
* Como executar: `podman run -ti --rm --name mongo --image-volume 'tmpfs' -p 27017:27017 --hostname ecom mongo:latests`
* Requisitos:
    * Podman **OU** Docker
* Instalação:
    * `podman pull docker.io/library/mongo:latest`