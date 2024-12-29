#!/usr/bin/env bash
# Deploy the environment for doing the lab activities
#
# Copyright 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0

# Check whether the script is sourced, which is unfortunately not a trivial task
# https://stackoverflow.com/a/28776166/6219078
sourced=0
if [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1
else # All other shells: examine $0 for known shell binary filenames.
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|-sh|dash|-dash) sourced=1;; esac
fi

set_opts=(
    # Terminate script execution when an unhandled error occurs
    -o errexit
    -o errtrace

    # Terminate script execution when an unset parameter variable is
    # referenced
    -o nounset
)
if ! set "${set_opts[@]}"; then
    printf -- \
        '%s: Error: Unable to configure the defensive interpreter behaviors.\n' \
        "${0}" \
        1>&2
    if test "${sourced}" == 1; then
        return 1
    else
        exit 1
    fi
fi

required_commands=(
    realpath
)
flag_required_command_check_failed=false
for command in "${required_commands[@]}"; do
    if ! command -v "${command}" >/dev/null; then
        flag_required_command_check_failed=true
        printf -- \
            '%s: Error: This program requires the "%s" command to be available in your command search PATHs.\n' \
            "${0}" \
            "${command}" \
            1>&2
    fi
done
if test "${flag_required_command_check_failed}" == true; then
    printf \
        '%s: Error: Required command check failed, please check your installation.\n' \
        "${0}" \
        1>&2
    if test "${sourced}" == 1; then
        return 1
    else
        exit 1
    fi
fi

if test -v BASH_SOURCE; then
    # Convenience variables may not need to be referenced
    # shellcheck disable=SC2034
    {
        if ! script="$(
            realpath \
                --strip \
                "${BASH_SOURCE[0]}"
            )"; then
            printf \
                '%s: Error: Unable to determine the absolute path of the program.\n' \
                "${0}" \
                1>&2
            return 1
        fi
        script_dir="${script%/*}"
        script_filename="${script##*/}"
        script_name="${script_filename%%.*}"
    }
fi
# Convenience variables may not need to be referenced
# shellcheck disable=SC2034
{
    script_basecommand="${0}"
    script_args=("${@}")
}

trap_err(){
    printf -- \
        '%s: Error: The program prematurely terminated due to an unhandled error.\n' \
        "${script_name}" \
        1>&2
    if test "${sourced}" == 1; then
        return 99
    else
        exit 99
    fi
}
if ! trap trap_err ERR; then
    printf -- \
        '%s: Error: Unable to set the ERR trap.\n' \
        "${script_name}" \
        1>&2
    if test "${sourced}" == 1; then
        return 1
    else
        exit 1
    fi
fi

if test "${EUID}" -ne 0; then
    printf -- \
        '%s: Error: This program is required to be run as the superuser(root).\n' \
        "${script_name}" \
        1>&2
    if test "${sourced}" == 1; then
        return 1
    else
        exit 1
    fi
fi

lab_dependency_pkgs=(
    # For running the bello package, this should already be installed so it's just for completeness
    bash

    # For generating and applying patches
    diffutils
    patch

    # For building the cello package
    gcc
    make

    # Runtime dependency of the "rpmdev-newspec" command
    git

    # For creating the source release archives
    gzip
    tar

    # For building and running the pello package
    python3

    # For packaging RPM packages
    rpm-build
    rpmdevtools

    # For editing source code files
    vim-enhanced
)
rpm_opts=(
    # Query existing package and print it's name
    --query

    # Don't print query output, we only need exit status code here
    --quiet
)
if ! rpm "${rpm_opts[@]}" "${lab_dependency_pkgs[@]}"; then
    printf -- \
        '%s: Info: Installing the dependencies for the lab activities...\n' \
        "${script_name}"
    if ! dnf install -y "${lab_dependency_pkgs[@]}"; then
        printf -- \
            '%s: Error: Unable to install the dependencies for the lab activities.\n' \
            "${script_name}" \
            1>&2
        if test "${sourced}" == 1; then
            return 2
        else
            exit 2
        fi
    fi
fi

if ! command -v python >/dev/null; then
    printf -- \
        '%s: Info: Ensuring the existence of the "python" command...\n' \
        "${script_name}"
    ln_opts=(
        --symbolic
    )
    if ! ln "${ln_opts[@]}" /usr/bin/python3 /usr/local/bin/python; then
        printf -- \
            '%s: Error: Unable to ensure the existence of the "python" command.\n' \
            "${script_name}" \
            1>&2
        if test "${sourced}" == 1; then
            return 2
        else
            exit 2
        fi
    fi
fi

if test -e /project; then
    # Change the working directory to the bind-mounted project directory
    if ! cd /project; then
        printf \
            '%s: Error: Unable to switch the working directory to /project.\n' \
            "${script_name}" \
            1>&2
        if test "${sourced}" == 1; then
            return 2
        else
            exit 2
        fi
    fi
elif test -e /vagrant; then
    # It's a Vagrant VM, provide easy access to the project directory
    echo 'cd /vagrant' >/etc/profile.d/01-cd-vagrant-dir.sh
fi

# Reset interpreter behavior so the future profile program won't break because of it
set_opts=(
    +o errexit
    +o errtrace
    +o nounset
)
if ! set "${set_opts[@]}"; then
    printf -- \
        '%s: Error: Unable to unconfigure the defensive interpreter behaviors.\n' \
        "${script_name}" \
        1>&2
    if test "${sourced}" == 1; then
        return 2
    else
        exit 2
    fi
fi

if ! trap - ERR; then
    printf -- \
        '%s: Error: Unable to unset the ERR trap.\n' \
        "${script_name}" \
        1>&2
    if test "${sourced}" == 1; then
        return 2
    else
        exit 2
    fi
fi
