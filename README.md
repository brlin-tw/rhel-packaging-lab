# RHEL Packaging Lab

Practice packaging RPM software packages using [Packaging and distributing software | Red Hat Product Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/packaging_and_distributing_software/index) as a reference material.

<https://gitlab.com/brlin/rhel-packaging-lab>  
[![The GitLab CI pipeline status badge of the project's `main` branch](https://gitlab.com/brlin/rhel-packaging-lab/badges/main/pipeline.svg?ignore_skipped=true "Click here to check out the comprehensive status of the GitLab CI pipelines")](https://gitlab.com/brlin/rhel-packaging-lab/-/pipelines) [![GitHub Actions workflow status badge](https://github.com/brlin-tw/rhel-packaging-lab/actions/workflows/check-potential-problems.yml/badge.svg "GitHub Actions workflow status")](https://github.com/brlin-tw/rhel-packaging-lab/actions/workflows/check-potential-problems.yml) [![pre-commit enabled badge](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white "This project uses pre-commit to check potential problems")](https://pre-commit.com/) [![REUSE Specification compliance badge](https://api.reuse.software/badge/gitlab.com/brlin/rhel-packaging-lab "This project complies to the REUSE specification to decrease software licensing costs")](https://api.reuse.software/info/gitlab.com/brlin/rhel-packaging-lab)

\#rhel \#packaging \#rpm

## Preparing the lab environment

This project implements a container-based lab environment for you to practice the lab activities without contaminating your operating system.

### Prerequisites

The following prerequisites must be met in order to complete this section:

* You must install either of the following software:
    + Docker Engine(for a container-based lab environment setup)
    + Vagrant and VirtualBox(for a virtual machine-based lab environment setup)
* Your lab host must have connectivity to the Internet.

### Preparation

Follow th following steps to prepare the lab environment:

1. Download the release package from [the Releases page](https://gitlab.com/brlin/rhel-packaging-lab/-/releases).
1. Extract the downloaded release package using your preferred archive manipulation program/application.
1. Launch your preferred text terminal emulator application.
1. Switch the working directory to the directory that hosts [this README document](README.md).
1. Run the following command to create the lab environment container:
    + If you're using the container-based lab environment setup:

        ```bash
        docker_compose_up_opts=(
            # Don't connect the controlling terminal to the Docker container process and release it back to the shell after container creation
            --detach
        )
        docker compose up -d
        ```

        **NOTE:** Depending on your Docker Engine installation you may need to run this command(and all the future Docker commands) _as root_.

    + If you're using the virtual machine-based lab environment setup:

        ```bash
        vagrant up
        ```

## Accessing the lab environment

Run the following commands to access the lab environment:

* If you're using the container-based lab environment setup:

    ```bash
    docker_exec_opts=(
        # Connect the container process's standard input device to the controlling terminal
        -i

        # Support terminal management features required by the bash shell
        -t
    )
    docker exec "${docker_exec_opts[@]}" rhel-packaging-lab bash --login
    ```

* If you're using the virtual machine-based lab environment setup:

    ```bash
    vagrant ssh
    ```

## Source material errata

This section documents several problems found during the consumptioon of the source material:

### Chapter 2. Creating software for RPM packaging

#### Semantic problem in the introductory text

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/>

**Section number and name**: [Chapter 2. Creating software for RPM packaging](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#creating-software-for-rpm-packaging_packaging-and-distributing-software)

**Describe the issue**:

The introductory text of this chapter currently writes:

> To prepare software for RPM packaging, you must understand what source code is and how to create software.

IMHO this sentence ends abruptly and is incomplete in the semantic sense.

**Impact of this issue**: It confuses readers and introduces some distractions.

**Suggestions for improvement**:

As this chapter essentially introduces source code files of different programming languages and the ways to make them executable in runtime it probably should be rewritten as:

> To prepare software for RPM packaging, you must understand what source code is and how to create software from it.

---

This issue is filed as [\[RHELDOCS-19440\] Semantic problem in the introductory text of the "Creating software for RPM packaging" chapter of the "Packaging and distributing software" documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19440) on the upstream issue tracker.

### Chapter 3. Preparing software for RPM packaging

#### Inconsistent file management command used in the "Creating a source code archive for a sample Bash program" section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#putting-the-bello-program-into-tarball_putting-source-code-into-tarball>

**Section number and name**: 3.3.1. Creating a source code archive for a sample Bash program

**Describe the issue**:

In the code block of the first step of the Procedure section:

```bash
mkdir bello-0.1
mv ~/bello bello-0.1/
mv LICENSE bello-0.1/
```

The `mv` command to move the `bello` program to the `bello-0.1` directory uses the brace expansion syntax, which is inconsistent with commands in all subsequent sections which assumes that the file is in the user's working directory, not their `$HOME`.

**Impact of this issue**: Readers cannot reproduce this step as it will trigger an error when a file is not found.

**Suggestions for improvement**:

The `mv` command should be changed to:

```bash
mkdir bello-0.1
mv bello bello-0.1/
mv LICENSE bello-0.1/
```

---

This issue is filed as [\[RHELDOCS-19450\] Inconsistent file management command used in the "3.3.1. Creating a source code archive for a sample Bash program" section of the "Packaging and distributing software" RHEL9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19450) on the upstream issue tracker.

#### Documentation instructs user to move file to an inexistent directory in the "Creating a source code archive for a sample Bash program" section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#creating-a-license-file-for-packaging_preparing-software-for-rpm-packaging>

**Section number and name**: 3.3.1. Creating a source code archive for a sample Bash program

**Describe the issue**:

In step 3 of the Procedure subsection, the user is instructed to do the following command:

```bash
mv bello-0.1.tar.gz ~/rpmbuild/SOURCES/
```

which will trigger the following error:

```txt
mv: cannot move 'bello-0.1.tar.gz' to '~/rpmbuild/SOURCES/': No such file or directory
```

if the user is following all instructions from the beginning as the ~/rpmbuild/SOURCES/ directory is only available after [section 4.1.1. Configuring RPM packaging workspace](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#setting-up-rpm-packaging-workspace_setting-up-rpm-packaging-workspace), where the `rpmdev-setuptree` utility is run to create the directory hierarchy.

**Impact of this issue**: The user may not be able to continue following the documentation instructions.

**Suggestions for improvement**:

Either create that directory beforehand using the `mkdir -p ~/rpmbuild/SOURCES` command or move the section 4.1 before 3.3.

---

This issue is filed as [\[RHELDOCS-19451\] Documentation instructs user to move file to an inexistent directory in the "3.3.1. Creating a source code archive for a sample Bash program" section of the "Packaging and distributing software" RHEL9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19451) on the upstream issue tracker.

#### The "move license file into package source tree" operation is not idempotent in the "Creating a source code archive for distribution" section

**Document link**: [https://docs.redhat.com/en/documentation/red\_hat\_enterprise\_linux/9/html-single/packaging\_and\_distributing\_software/index#putting-the-bello-program-into-tarball_putting-source-code-into-tarball](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#putting-the-bello-program-into-tarball_putting-source-code-into-tarball)

**Section number and name**: 3.3.1, 3.3.2, and 3.3.3

**Describe the issue**: In step 1 of the Procedure of sections 3.3.1, 3.3.2, and 3.3.3, the user is instructed to run the following commands to move the LICENSE file created in section 3.2 in the sample packages' source tree:

```bash
mv LICENSE bello-0.1/
```

```bash
mv LICENSE pello-0.1.1/
```

```bash
mv LICENSE cello-1.0/
```

which, when done in the top-to-down order, the subsequent commands will fail because the LICENSE file is no longer in existence.

**Impact of this issue**: Minor as the user likely still remembers section 3.2 and can manually recreate or copy the LICENSE file.

**Suggestions for improvement**: Use the `cp` command instead of `mv` to keep a copy of the LICENSE file in the working directory.

---

This issue is filed as [\[RHELDOCS-19452\] The "move license file into package source tree" operation is not idempotent in the "3.3. Creating a source code archive for distribution" section of the "Packaging and distributing software" RHEL9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19452) on the upstream issue tracker.

### Chapter 4. Packaging software

#### Semantic problem in the BuildRequires directive explanation of the "An example SPEC file for a program written in Python" section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files>

**Section number and name**: 4.5.4. An example SPEC file for a program written in Python

**Describe the issue**:

In bullet point 3. of this section:

> In BuildRequires, always include items providing tools necessary for building Python packages: python3-devel (or `python3.11-devel` or `python3.12-devel`) and the relevant _**projects**_ needed by the specific software that you package, for example, `python3-setuptools` (or `python3.11-setuptools` or `python3.12-setuptools`) or the runtime and testing dependencies needed to run the tests in the %check section.

The "projects" term usage doesn't seem accurate IMO.

**Impact of this issue**: Documentation consumers may be confused by the term.

**Suggestions for improvement**:

In this context, it should probably be replaced with one of the following terms:

* packages
* software
* dependencies
* components

---

This issue is filed as [\[RHELDOCS-19470\] Semantic problem in the BuildRequires directive explanation of the "An example SPEC file for a program written in Python" section of the "Packaging and distributing software" documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19470) on the upstream issue tracker.

#### Inconsistent LICENCE declaration in the "An example SPEC file for a program written in Python" section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files>

**Section number and name**: 4.5.4. An example SPEC file for a program written in Python

**Describe the issue**: In the example spec file of the "An example spec file for the pello program written in Python" subsection the package license is specified as the MIT license:

> License: MIT

However, the LICENSE file created for this package in the  [3.2. Creating a LICENSE file](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#creating-a-license-file-for-packaging_preparing-software-for-rpm-packaging) section specifies GPLv3, creating unnecessary inconsistency.

**Impact of this issue**: Documentation consumers will be unnecessarily confused by the inconsistent license declaration.

**Suggestions for improvement**: Change the value of the License field of the spec file as GPLv3 as well.

---

This issue is filed as [\[RHELDOCS-19471\] Inconsistent LICENCE declaration in the "An example SPEC file for a program written in Python" section of the "Packaging and distributing software" RHEL 9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19471) on the upstream issue tracker.

#### Inconsistent package version declaration in the "An example SPEC file for a program written in Python" section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files>

**Section number and name**: 4.5.4. An example SPEC file for a program written in Python

**Describe the issue**:

In the example spec file of the pello package the package version is declared as 1.0.2:

> Version: 1.0.2

However, a different 0.1.1 version string is declared in the [3.3.2. Creating a source code archive for a sample Python program](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#putting-the-pello-program-into-tarball_putting-source-code-into-tarball) section, which is inconsistent.

**Impact of this issue**: Documentation consumers may be unnecessarily confused by the inconsistency.

**Suggestions for improvement**: Change the value of the Version field to be 0.1.1 as well.

---

This issue is filed as [\[RHELDOCS-19472\] Inconsistent package version declaration in the "An example SPEC file for a program written in Python" section of the "Packaging and distributing software" RHEL 9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19472) on the upstream issue tracker.

#### Source URL of the pello package of the "An example SPEC file for a program written in Python" section prevents the usage of the pello source archive created in the previous section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files>

**Section number and name**: 4.5.4. An example SPEC file for a program written in Python

**Describe the issue**:

Currently the value of the Source field of the SPEC file of the pello package:

```spec
Source: %{url}/archive/v%{version}/Pello-%{version}.tar.gz
```

Uses the Pello-%{version}.tar.gz base name, which is inconsistent with the source archive file created in [3.3.2. Creating a source code archive for a sample Python program](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#putting-the-pello-program-into-tarball_putting-source-code-into-tarball) section causes the following error to occur when the user is trying to build the source RPM in [4.6.2. Rebuilding a binary RPM from a source RPM](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#rebuilding-a-binary-from-a-source-rpm_building-rpms) section:

```txt
[root@rhel-packaging-lab project]# rpmbuild -bs pello.spec
error: Bad source: /root/rpmbuild/SOURCES/Pello-0.1.1.tar.gz: No such file or directory
```

**Impact of this issue**: The documentation consumer cannot proceed with the operation due to the error.

**Suggestions for improvement**:

* Rename the source repository to NOT use the titlecase name.
* Don't specify the remote repository in the Source field.

---

This issue is filed as [\[RHELDOCS-19473\] Source URL of the pello package of the "4.5.4. An example SPEC file for a program written in Python" section prevents the usage of the pello source archive created in the previous section - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19473) on the upstream issue tracker.

#### The example SPEC file of the pello package does not apply to the source archive created in previous sections

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files>

**Section number and name**: 4.5.4. An example SPEC file for a program written in Python

**Describe the issue**:

The SPEC file given in the [4.5.4. An example SPEC file for a program written in Python](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#an-example-spec-file-for-a-program-written-in-python-rhel9_working-with-spec-files) section make use of the source archive from the [https://github.com/fedora-python/Pello](https://github.com/fedora-python/Pello) repository, making the work in section [3.3.2. Creating a source code archive for a sample Python program](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#putting-the-pello-program-into-tarball_putting-source-code-into-tarball) meaningless.

Manually changing the Source0 field to the local archive doesn't work as the given SPEC file depends on features not available in the source archive(setup.py) and the build will fail in section 4.5.4.

**Impact of this issue**: Documentation consumer will have unnecessary confusion.

**Suggestions for improvement**:

Either:

* Avoid using the source from the [https://github.com/fedora-python/Pello](https://github.com/fedora-python/Pello) repository.
* Change the source code of the pello package to match the one on the [https://github.com/fedora-python/Pello](https://github.com/fedora-python/Pello) repository.

---

This issue is filed as [\[RHELDOCS-19474\] The example SPEC file of the pello package does not apply to the source archive created in previous sections in the Packaging and distributing software RHEL9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19474) on the upstream issue tracker.

#### Incorrect SRPM filenames specified in the example commands of the Building source RPMs section

**Document link**: <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#building-source-rpms_building-rpms>

**Section number and name**:

* [4.6.1. Building source RPMs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#building-source-rpms_building-rpms)
* [4.6.2. Rebuilding a binary RPM from a source RPM](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#rebuilding-a-binary-from-a-source-rpm_building-rpms)

**Describe the issue**:

The following example command and outputs for building source RPMS:

```txt
$ rpmbuild -bs bello.spec
Wrote: /home/admiller/rpmbuild/SRPMS/bello-0.1-1.el8.src.rpm

$ rpmbuild -bs pello.spec
Wrote: /home/admiller/rpmbuild/SRPMS/pello-0.1.2-1.el8.src.rpm

$ rpmbuild -bs cello.spec
Wrote: /home/admiller/rpmbuild/SRPMS/cello-1.0-1.el8.src.rpm
```

have the following errors:

* The distribution version is outdated, it should be `el9`.
* The source RPM filename for the pello package should be `python-hello-1.0.2-1.el9.src.rpm`, not `pello-0.1.2-1.el8.src.rpm`.

The example commands in the [4.6.2. Rebuilding a binary RPM from a source RPM](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#rebuilding-a-binary-from-a-source-rpm_building-rpms) section also have similar errors.

**Impact of this issue**: Document consumers will be unnecessarily confused.

**Suggestions for improvement**: Fix the output and filenames as depicted above.

---

This issue is filed as [\[RHELDOCS-19475\] Incorrect SRPM filenames specified in the example commands of the 4.6.1. Building source RPMs section of the Packaging and distributing software RHEL9 documentation - Red Hat Issue Tracker](https://issues.redhat.com/projects/RHELDOCS/issues/RHELDOCS-19475) on the upstream issue tracker.

#### The "Checking the {b,p,c}ello SRPM for common errors" portions of the "Checking RPMs for common errors" section should have their own sub-sections

**Document link:** <https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/packaging_and_distributing_software/index#checking-rpms-for-common-errors_packaging-software>

**Section number and name:**

* 4.7.1. Checking a sample Bash program for common errors
* 4.7.2. Checking a sample Python program for common errors
* 4.7.3. Checking a sample C program for common errors

**Describe the issue:** In the "4.7.{1,2,3}.1. Checking the {b,p,c}ello spec file for common errors" sections both spec file and the SRPM package are checked using `rpmlint`, which are inconsistent with the section title.

**Impact of this issue:** Documentation consumers may be unnecessarily confused by the unexpected content.

**Suggestions for improvement:** A set of "4.7.{1,2,3}.2. Checking the {b,p,c}ello source RPM for common errors" separate sections should be inserted before the corresponding binary RPM counterparts.

---

This issue is filed as [\[RHELDOCS-19478\] The "Checking the {b,p,c}ello SRPM for common errors" portions of the "Checking RPMs for common errors" chapter should have their own sub-sections - Red Hat Issue Tracker](https://issues.redhat.com/browse/RHELDOCS-19478) on the upstream issue tracker.

## References

The following material is referenced during the development of this project:

* [Packaging and distributing software | Red Hat Product Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/packaging_and_distributing_software/index)  
  The target learning material.
* [rpm.org - RPM Reference Manual](https://rpm-software-management.github.io/rpm/manual/)  
  Provide official information regarding the RPM packaging utilities.

## Licensing

Unless otherwise noted(individual file's header/[REUSE.toml](REUSE.toml)), this product is licensed under [the 4.0 International version of the Creative Commons Attribution–Share Alike license](https://creativecommons.org/licenses/by-sa/4.0/deed.en), or any of its recent versions you would prefer.

This work complies to [the REUSE Specification](https://reuse.software/spec/), refer to the [REUSE - Make licensing easy for everyone](https://reuse.software/) website for info regarding the licensing of this product.
