Unity Sounder SIPS Application
==============================

This repository represents the containerization of the Sounder SIPS `SPSS <https://github.jpl.nasa.gov/SIPS/SPSS>`_ repository into a Unity Application Package.

Requirements
------------

In order to use this repository you will need access to the `Sounder SIPS Github Organization <https://github.jpl.nasa.gov/SIPS/>`_ on the JPL Enterprise server. This repository pulls in this repository as a Git submodule. Additionally you will need access to Docker and Docker Compose. See the **Static Files** section for information on obtaining the necessary static files.

Building
--------

The following steps will prepare the repository for usage::

    # Check out repository
    $ git clone git@github.jpl.nasa.gov:unity-sds/sips_spss_build.git
    $ cd sips_spss_build

    # Initialize Sounder SIPS SPSS repository
    $ git submodule init
    $ git submodule update

Then to build the Docker images run the following::

    # Build docker images
    $ docker-compose build

After the Docker build process you should have 4 Docker images available:

* unity-sds/sounder_sips_base
* unity-sds/sounder_sips_pge_common
* unity-sds/sounder_sips_l1a_pge
* unity-sds/sounder_sips_l1b_pge

The Docker images will all share a common tag representing their version number. The first two images are an artifact of the build process, they will not be used in PGE execution. The second two images are used for PGE execution.

Static Files
-------------

A set of large static files is needed for running the SIPS algorithms. These files can be obtain in one of several ways:

From the Sounder SIPS Machines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log into the Sounder SIPS machine ``smog`` and copy the following directories to the machine that will run your built Docker image::

    $ ssh smog
    $ scp -r /peate/support/static/dem my_machine:dem
    $ scp -r /ref/devstable/STORE/mcf my_machine:mcf

From the MIPL HPC Machine
~~~~~~~~~~~~~~~~~~~~~~~~~

These files are also staged on the Section 398 MIPL HPC machine at ``miplhpc1:/export/proj1/home/mcduffie/unity/static_files``.

Staging
~~~~~~~

These two directories will need to be staged within the Docker image through volume mounts as described in subsequent sections. 

Usage
-----

These two PGE Docker images require the following:

* The static dem directory volume mounted as ``/peate/support/static/dem``
* The static mcf diectory volume mounted as ``/ref/devstable/STORE/mcf``

Note that above we mount the static directories at the same location as they would exist on the standard SIPS production systems.

The localized input staging directory should be mounted as ``/pge/in`` within the container and the localized output stage directory should be mounted as ``/pge/out``.

Testing
-------

A shell script exists to test execution of the L1A PGE. This script handles the volume mounting mentioned in the **Usage** section. The only additional step needed to run the test script is to point to the location of the static files. The static files can be pointed to through either a symbolic link or through an environment variable. If using a symbolic link then create a link called ``static`` from the repository root directory to point to the static files. Alternatively declare the `SIPS_STATIC_DIR` environment variable to point to the directory on the local system where you have stored the static files.

Once you have either set up a symbolic link to the static files or set the ``SIPS_STATIC_DIR`` environment variable this script can be run without any arguments::

    $ spss/test/l1a/run_l1a_test.sh

This will copy L0 files from the SPSS repository into into ``spss/test/l1a/in``. Results will be placed into ``spss/test/l1a/out``.

Versioning
----------

The Docker group and Docker tag applied to the images during the docker-compose build process come from the ``.env`` file in the repository base directory. The ``DOCKER_TAG`` value should be updated for new deliveries of the algorithm.

TODO
----

The entry point to the PGEs has not yet been finalized. Therefore what is done by the test scripts currently is just a first step towards an actual application package.