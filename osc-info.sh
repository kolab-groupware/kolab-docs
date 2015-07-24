#!/bin/bash

mkdir -p osc-cache/

rm -f osc-info.stop

refresh=0
while [ $# -gt 0 ]; do
    case $1 in
        --refresh)
            refresh=1
            shift
        ;;

        *)
            package_refresh=$1
            shift
        ;;
    esac
done

echo -n "Gathering projects ..."
# List the projects and cache them locally.
if [ ! -f "osc_cache/obs_projects.list" -o ${refresh} -eq 1 ]; then
    osc ls | grep -vE "^(home|deleted)" > osc-cache/obs_projects.list

    # Legacy Kolab releases do not need to be updated
    sed -r -i \
        -e '/^cyrus-imapd/d' \
        -e '/^Kolab:3\.0/d' \
        -e '/^Kolab:3\.1/d' \
        -e '/^Kolab:3\.2/d' \
        -e '/^Kolab:3\.3/d' \
        -e '/^Kolab:13:Updates/d' \
        osc-cache/obs_projects.list

    # Legacy target platforms do not need to be updated
    sed -r -i \
        -e '/^Debian:6\.0/d' \
        -e '/^Fedora:17/d' \
        -e '/^Fedora:18/d' \
        -e '/^Fedora:19/d' \
        -e '/^Fedora:20/d' \
        -e '/^openSUSE:12\.1/d' \
        -e '/^openSUSE:12\.2/d' \
        -e '/^RHEL:7/d' \
        -e '/^UCS:3\.0/d' \
        -e '/^UCS:3\.1/d' \
        -e '/^UCS:3\.2/d' \
        -e '/^Kontact/d' \
        osc-cache/obs_projects.list
fi
echo " DONE"

obs_projects=$(cat osc-cache/obs_projects.list)

# Placeholder for Kolab projects
declare -a kolab_projects
# Placeholder for target platform repositories
declare -a target_repositories

# First, attempt to discover the maximum width of:
#
# - Either the table column header or any project names, and
# - Either the table column header or any target platform name.

package_column_width=0
project_column_width=0
target_column_width=0
version_column_width=36

for project in ${obs_projects}; do
    if [ -z "$(echo ${project} | grep ^Kolab)" ]; then
        target_repositories[${#target_repositories[@]}]=$(echo ${project} | sed -e 's/:/_/g')
        # Determine if the name of this project is longer than any other project
        # name we've seen before
        if [ $(echo -n "$(echo ${project} | sed -e 's/:/_/g')" | wc -c) -gt ${target_column_width} ]; then
            target_column_width=$(echo -n "$(echo ${project} | sed -e 's/:/_/g')" | wc -c)
        fi
    else
        kolab_projects[${#kolab_projects[@]}]="${project}"

        # Determine if the name of this project is longer than any other project
        # name we've seen before
        if [ $(echo -n "${project}" | wc -c) -gt ${project_column_width} ]; then
            project_column_width=$(echo -n "${project}" | wc -c)
        fi
    fi

done

# Capture all names being shorter than the header.
if [ $(echo -n "Kolab Version(s)" | wc -c) -gt ${project_column_width} ]; then
    project_column_width=$(echo -n "Kolab Version(s)" | wc -c)
fi

if [ $(echo -n "Platform(s)" | wc -c) -gt ${target_column_width} ]; then
    target_column_width=$(echo -n "Platform(s)" | wc -c)
fi

# List all packages in all projects
current=0
cur_percentage=0
total=${#kolab_projects[@]}

while [ ${current} -lt ${#kolab_projects[@]} ]; do
    project=${kolab_projects[${current}]}

    if [ ! -f "osc-cache/${project}_packages.list" -o ${refresh} -eq 1 ]; then
        osc ls ${project} > osc-cache/${project}_packages.list
    fi

    if [ $(( ${current} * 100 / ${total} )) -ne ${cur_percentage} ]; then
        echo -en "Listing packages for projects: $(printf %3d $(( ${current} * 100 / ${total} )))%\r"
        export cur_percentage=$(( ${current} * 100 / ${total} ))
    fi

    export cur_percentage=$(( ${current} * 100 / ${total} ))

    let current++
done

echo -en "Listing packages for projects: $(printf %3d $(( ${current} * 100 / ${total} )))%\r"

# Remove the exceptions to the rule
sed -r -i \
    -e '/^roundcubemail-skin-contargo$/d' \
    osc-cache/*_packages.list

cat osc-cache/*_packages.list | sort -u > osc-cache/packages.list

for package in $(cat osc-cache/packages.list); do
    if [ $(echo -n "${package}" | wc -c) -gt ${package_column_width} ]; then
        package_column_width=$(echo -n "${package}" | wc -c)
    fi
done

package_column_width=$(( ${package_column_width} * 2 + $(echo -n ":ref:\`package-\'" | wc -c) ))

if [ $(echo -n "Package Name(s)" | wc -c) -gt ${package_column_width} ]; then
    package_column_width=$(echo -n "Package Name(s)" | wc -c)
fi

echo ""

# To initialize the tables, first iterate over all unique packages (across all
# projects).

if [ ! -z "${package_refresh}" ]; then
    packages=${package_refresh}
else
    packages=$(cat osc-cache/*_packages.list | sort -u)
fi

total=$(cat osc-cache/*_packages.list | sort -u | wc -l)
current=1
cur_percentage=0

# Temp
#if [ 0 -eq 1 ]; then

for package in ${packages}; do
    target="source/developer-guide/packaging/obs-for-kolab/packages/${package}.txt"

    if [ -f "${target}" ]; then
        rm -rf ${target}
    fi

    x=0
    while [ ${x} -lt ${#kolab_projects[@]} ]; do
        project=${kolab_projects[${x}]}

        if [ ! -f "osc-cache/${project}_${package}.meta" -o ${refresh} -eq 1 ]; then
            osc meta pkg ${project} ${package} > osc-cache/${project}_${package}.meta 2>/dev/null
        fi

        let x++
    done

    echo ".. _package-$(echo ${package} | tr '[:upper:]' '[:lower:]'):" >> ${target}
    echo "" >> ${target}

    echo "${package}" >> ${target}
    echo "${package}" | sed -e 's/./=/g' >> ${target}
    echo "" >> ${target}
    if [ -f "source/developer-guide/packaging/obs-for-kolab/packages/${package}.rst" ]; then
        cat "source/developer-guide/packaging/obs-for-kolab/packages/${package}.rst" >> ${target}
        echo "" >> ${target}
    fi
    echo ".. table:: Version Table for ${package}" >> ${target}
    echo "" >> ${target}
    printf "%s" "    +-" >> ${target}
    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+-" >> ${target}
    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+-" >> ${target}
    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
    printf "%s" "-+" >> ${target}
    echo "" >> ${target}

    printf "%s" "    | " >> ${target}
    printf "%-${project_column_width}s" "Kolab Version(s)" >> ${target}
    printf "%s" " | " >> ${target}
    printf "%-${target_column_width}s" "Platform(s)" >> ${target}
    printf "%s" " | " >> ${target}
    printf "%-${version_column_width}s" "Version" >> ${target}
    printf "%s" " |" >> ${target}
    echo "" >> ${target}

    printf "%s" "    +=" >> ${target}
    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+=" >> ${target}
    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+=" >> ${target}
    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "="{1..60}) >> ${target}
    printf "%s" "=+" >> ${target}
    echo "" >> ${target}

    if [ $(( ${current} * 100 / ${total} )) -ne ${cur_percentage} ]; then
        echo -en "Initialize package tables: $(printf %3d $(( ${current} * 100 / ${total} )))%\r"
        export cur_percentage=$(( ${current} * 100 / ${total} ))
    fi

    export cur_percentage=$(( ${current} * 100 / ${total} ))

    let current++
done

echo ""

# Loop through our projects,
# then through the packages for that project,
# then see what the packages are configured to build for,
# then see where the package originates from and what version is included, or
# we include.

x=0
while [ ${x} -lt ${#kolab_projects[@]} ]; do
    project=${kolab_projects[${x}]}

    if [ ! -z "${package_refresh}" ]; then
        packages=${package_refresh}
    else
        packages=$(cat osc-cache/*_packages.list | sort -u)
    fi

    current=1
    cur_percentage=0
    total=$(cat osc-cache/*_packages.list | sort -u | wc -l)
    for package in ${packages}; do
        if [ -f "osc-info.stop" ]; then
            echo "Stop issued."
            exit 1
        fi

        enabled_repositories=""
        target="source/developer-guide/packaging/obs-for-kolab/packages/${package}.txt"

        if [ -s "osc-cache/${project}_${package}.meta" ]; then
            disabled_default=$(awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | grep -E "^\s*<disable/>$")
        else
            disabled_default="yes"
        fi

        if [ -z "${disabled_default}" ]; then
            disabled_repositories=$(
                    awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | \
                    grep -E "^\s*<disable repository.*" | \
                    sed -r -e 's/\s*<disable repository="(.*)"\/>/\1/g' | \
                    sort -u
                )

            y=0
            while [ ${y} -lt ${#target_repositories[@]} ]; do
                repo_disabled=0
                for disabled_repository in ${disabled_repositories}; do
                    if [ "${target_repositories[${y}]}" == "${disabled_repository}" ]; then
                        repo_disabled=1
                    fi
                done

                if [ ${repo_disabled} -eq 0 ]; then
                    enabled_repositories="${enabled_repositories} ${target_repositories[${y}]}"
                fi

                let y++
            done
        elif [ "${disabled_default}" == "yes" ]; then
            enabled_repositories=""
        else
            enabled_repositories=$(
                    awk '/<build>/,/<\/build>/' osc-cache/${project}_${package}.meta | \
                    grep -E "^\s*<enable repository.*" | \
                    sed -r -e 's/\s*<enable repository="(.*)"\/>/\1/g' | \
                    sort -u
                )
        fi

        if [ ! -z "${enabled_repositories}" ]; then
            printf "    | %-${project_column_width}s |" ${project} >> ${target}

            have_had_first=0
            for enabled_repository in ${enabled_repositories}; do
                # Here be version magic.
                # osc buildinfo Kolab:3.1 389-admin Debian_7.0 x86_64 | awk '/<versrel>/,/<\/versrel>/' | sed -e 's/\s*<versrel>//g' -e 's/<\/versrel>//g'
                if [ ! -s "osc-cache/${project}_${enabled_repository}_${package}.version" -o ${refresh} -eq 1 ]; then
                    osc buildinfo ${project} ${package} ${enabled_repository} x86_64 2>/dev/null | awk '/<versrel>/,/<\/versrel>/' | sed -e 's/\s*<versrel>//g' -e 's/<\/versrel>//g' > osc-cache/${project}_${enabled_repository}_${package}.version
                fi

                version=$(cat osc-cache/${project}_${enabled_repository}_${package}.version)
                if [ -z "${version}" ]; then
                    version="N/A"
                fi

                if [ ${have_had_first} -eq 0 ]; then
                    printf " %-${target_column_width}s | %-${version_column_width}s |" ${enabled_repository} ${version} >> ${target}
                    echo "" >> ${target}
                    printf "%s" "    +-" >> ${target}
                    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+" >> ${target}
                    echo "" >> ${target}
                    have_had_first=1
                else
                    printf "    | %-${project_column_width}s |" >> ${target}
                    printf " %-${target_column_width}s | %-${version_column_width}s |" ${enabled_repository} ${version} >> ${target}
                    echo "" >> ${target}
                    printf "%s" "    +-" >> ${target}
                    printf "%*.*s" 0 ${project_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${target_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+-" >> ${target}
                    printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..60}) >> ${target}
                    printf "%s" "-+" >> ${target}
                    echo "" >> ${target}
                fi
            done
        fi

        if [ $(( ${current} * 100 / ${total} )) -ne ${cur_percentage} ]; then
            echo -en "${project}: $(printf %3d $(( ${current} * 100 / ${total} )))%\r"
            export cur_percentage=$(( ${current} * 100 / ${total} ))
        fi

        export cur_percentage=$(( ${current} * 100 / ${total} ))

        let current++

    done
    echo ""
    let x++
done

# Temp
#fi

# Projects page
current=0
cur_percentage=0
total=${#kolab_projects[@]}

mkdir -p "source/developer-guide/packaging/obs-for-kolab/product/"

while [ ${current} -lt ${#kolab_projects[@]} ]; do
    project=${kolab_projects[${current}]}
    project_lc=$(echo ${project} | sed -e 's/:/-/g' | tr '[:upper:]' '[:lower:]')
    target="source/developer-guide/packaging/obs-for-kolab/product/${project_lc}.rst"
    enabled_repositories=""

    if [ -f "${target}" ]; then
        rm -rf ${target}
    fi

    echo ".. _product-${project_lc}:" >> ${target}
    echo "" >> ${target}
    echo "${project}" >> ${target}
    echo "${project}" | sed -r -e 's/./=/g' >> ${target}
    echo "" >> ${target}

    if [ ! -f "osc-cache/${project}.meta" -o ${refresh} -eq 1 ]; then
        osc meta prj ${project} > osc-cache/${project}.meta 2>/dev/null
    fi

    if [ -s "osc-cache/${project}.meta" ]; then
        disabled_default=$(awk '/<build>/,/<\/build>/' osc-cache/${project}.meta | grep -E "^\s*<disable/>$")
    else
        disabled_default="yes"
    fi

    if [ -z "${disabled_default}" ]; then
        disabled_repositories=$(
                awk '/<build>/,/<\/build>/' osc-cache/${project}.meta | \
                grep -E "^\s*<disable repository.*" | \
                sed -r -e 's/\s*<disable repository="(.*)"\/>/\1/g' | \
                sort -u
            )

        y=0
        while [ ${y} -lt ${#target_repositories[@]} ]; do
            repo_disabled=0
            for disabled_repository in ${disabled_repositories}; do
                if [ "${target_repositories[${y}]}" == "${disabled_repository}" ]; then
                    repo_disabled=1
                fi
            done

            if [ ${repo_disabled} -eq 0 ]; then
                enabled_repositories="${enabled_repositories} ${target_repositories[${y}]}"
            fi

            let y++
        done
    elif [ "${disabled_default}" == "yes" ]; then
        enabled_repositories=""
    else
        enabled_repositories=$(
                awk '/<build>/,/<\/build>/' osc-cache/${project}.meta | \
                grep -E "^\s*<enable repository.*" | \
                sed -r -e 's/\s*<enable repository="(.*)"\/>/\1/g' | \
                sort -u
            )
    fi

    packages=$(cat osc-cache/${project}_packages.list)
    if [ ! -z "${enabled_repositories}" ]; then
        echo "Version Matrices per Target Platform" >> ${target}
        echo "------------------------------------" >> ${target}
        echo "" >> ${target}

        for enabled_repository in ${enabled_repositories}; do
            num_packages=0
            for package in ${packages}; do
                if [ -s "osc-cache/${project}_${enabled_repository}_${package}.version" ]; then
                    num_packages=$(( ${num_packages} + 1 ))
                fi
            done

            if [ ${num_packages} -lt 1 ]; then
                continue
            fi

            echo "*   :ref:\`product-${project_lc}-$(echo ${enabled_repository} | sed -e 's/:/-/g' | tr '[:upper:]' '[:lower:]')\`" >> ${target}
        done

        echo "" >> ${target}
    fi

    for enabled_repository in ${enabled_repositories}; do
        num_packages=0
        for package in ${packages}; do
            if [ -s "osc-cache/${project}_${enabled_repository}_${package}.version" ]; then
                num_packages=$(( ${num_packages} + 1 ))
            fi
        done

        if [ ${num_packages} -lt 1 ]; then
            continue
        fi

        echo ".. _product-${project_lc}-$(echo ${enabled_repository} | sed -e 's/:/-/g' | tr '[:upper:]' '[:lower:]'):" >> ${target}
        echo "" >> ${target}
        echo "${enabled_repository}" >> ${target}
        echo "${enabled_repository}" | sed -r -e 's/./^/g' >> ${target}
        echo "" >> ${target}

        echo ".. table:: Version Matrix for ${enabled_repository} " >> ${target}
        echo "" >> ${target}
        printf "%s" "    +-" >> ${target}
        printf "%*.*s" 0 ${package_column_width} $(printf '%0.1s' "-"{1..120}) >> ${target}
        printf "%s" "-+-" >> ${target}
        printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..120}) >> ${target}
        printf "%s" "-+" >> ${target}
        echo "" >> ${target}

        printf "%s" "    | " >> ${target}
        printf "%-${package_column_width}s" "Package Name(s)" >> ${target}
        printf "%s" " | " >> ${target}
        printf "%-${version_column_width}s" "Version" >> ${target}
        printf "%s" " |" >> ${target}
        echo "" >> ${target}

        printf "%s" "    +=" >> ${target}
        printf "%*.*s" 0 ${package_column_width} $(printf '%0.1s' "="{1..120}) >> ${target}
        printf "%s" "=+=" >> ${target}
        printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "="{1..120}) >> ${target}
        printf "%s" "=+" >> ${target}
        echo "" >> ${target}

        for package in ${packages}; do
            if [ -s "osc-cache/${project}_${enabled_repository}_${package}.version" ]; then
                package_version=$(cat "osc-cache/${project}_${enabled_repository}_${package}.version")

                printf "%s" "    | " >> ${target}
                printf "%-${package_column_width}s | %-${version_column_width}s |" ":ref:\`package-$(echo ${package} | tr '[:upper:]' '[:lower:]')\`" ${package_version} >> ${target}
                echo "" >> ${target}
                printf "%s" "    +-" >> ${target}
                printf "%*.*s" 0 ${package_column_width} $(printf '%0.1s' "-"{1..120}) >> ${target}
                printf "%s" "-+-" >> ${target}
                printf "%*.*s" 0 ${version_column_width} $(printf '%0.1s' "-"{1..120}) >> ${target}
                printf "%s" "-+" >> ${target}
                echo "" >> ${target}

            fi
        done

        echo "" >> ${target}

    done

    let current++

done

echo ""

