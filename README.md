# ++++++++++ DEPRECATED ++++++++++++++DEPRECATED ++++++++++++++DEPRECATED ++++++++++++++DEPRECATED ++++++++++++++DEPRECATED ++++++++++++++DEPRECATED ++++++++++++++
## This repository and the corresponding docker image are deprecated and won't be maintained anymore!
## Please visit https://sap.github.io/cloud-mta-build-tool/ for the new mbt tool. The corresponding docker image can be found here: https://hub.docker.com/r/devxci/mbtci
## Please migrate you builds as soon as possible !


# Multitarget Application Archive Builder

The multitarget application archive builder is a command-line tool that packages a multitarget application into a deployable archive (MTAR). For full documentation please visit the [SAP Help Portal](https://help.sap.com/viewer/58746c584026430a890170ac4d87d03b/Cloud/en-US/ba7dd5a47b7a4858a652d15f9673c28d.html).

This image can be used to build SAP Multitarget Applications (MTA) containing Java and Node.js modules. The image is hosted at [hub.docker.com](https://hub.docker.com/r/ppiper/mta-archive-builder).

# How to use this image

On a linux machine you can run

```
docker run -v "${PWD}":/project --rm ppiper/mta-archive-builder mtaBuild --version
```

This will execute the MTA archive builder and print its version information.

```
docker run --rm -v "${PWD}":/project -it ppiper/mta-archive-builder:latest mtaBuild --mtar dummy.mtar --build-target NEO build
```

This will build an `mtar` file for SAP Cloud Platform (Neo). The folder containing the project needs to be mounted into the image at `/project`.

# How to build this image

```
docker build -t ppiper/mta-archive-builder .
```

## This image provides:

- SAP Multitarget Application Archive Builder
- Nodejs
- SAP registry (`@sap:registry https://npm.sap.com`) contained in global node configuration.
- Maven

The MTA Archive Builder delegates module builds to other build tools. This image provides nodejs and maven, so the archive builder can delegate
to these build technologies. In case more build tools are needed inherit from this image and
add more build tools.
