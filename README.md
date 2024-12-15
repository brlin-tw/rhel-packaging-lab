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

## References

The following material is referenced during the development of this project:

* [Packaging and distributing software | Red Hat Product Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/packaging_and_distributing_software/index)  
  The target learning material.
* [rpm.org - RPM Reference Manual](https://rpm-software-management.github.io/rpm/manual/)  
  Provide official information regarding the RPM packaging utilities.

## Licensing

Unless otherwise noted(individual file's header/[REUSE.toml](REUSE.toml)), this product is licensed under [the _license_version_ version of the _license_name_ license](_license_url_), or any of its recent versions you would prefer.

This work complies to [the REUSE Specification](https://reuse.software/spec/), refer to the [REUSE - Make licensing easy for everyone](https://reuse.software/) website for info regarding the licensing of this product.
