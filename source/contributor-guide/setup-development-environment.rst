.. _contributor-guide-setup-your-development-environment:

==================================
Setup Your Development Environment
==================================

This guide sets you up a development workstation to contribute to Kolab
Groupware development on `Phabricator`_.

#.  :ref:`contributor-guide-setup-tools`

.. _contributor-guide-setup-tools:

Install the Tools
=================

#.  Ensure you have our Tools repository configured.

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`

    For **Fedora 23**:

    .. parsed-literal::

        # :command:`wget https://obs.kolabsys.com/repositories/Tools/Fedora_23/Tools.repo`

    For **Fedora 22**:

    .. parsed-literal::

        # :command:`wget https://obs.kolabsys.com/repositories/Tools/Fedora_22/Tools.repo`

    For **Red Hat Enterprise Linux 7**:

    .. parsed-literal::

        # :command:`wget https://obs.kolabsys.com/repositories/Tools/RHEL_7/Tools.repo`

#.  Import the GPG public key the packages are signed with:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

#.  Install **arcanist**:

    For **Fedora 22** and **Fedora 23**:

    .. parsed-literal::

        # :command:`dnf -y install arcanist`

    For **Red Hat Enterprise Linux 7**:

    .. parsed-literal::

        # :command:`yum -y install arcanist`

.. _contributor-guide-setup-recommended-configuration:

Recommended Configuration
=========================

**SSH Configuration**

    Configure SSH to use the correct username and SSH identity when you use
    ``git.kolab.org``:

    .. parsed-literal::

        $ :command:`grep -A3 git.kolab.org ~/.ssh/config`
        Host git.kolab.org
            User git
            IdentityFile ~/.ssh/id_rsa

**BASH Completion**

    Say something about bash completion and how great it is.

**GIT Prompt**

    Say something about the git prompt.

**GIT Configuration**

    For each repository separately, or otherwise globally:

    .. parsed-literal::

        $ :command:`git config [--global] user.name "Jeroen van Meeuwen (Kolab Systems)"`
        $ :command:`git config [--global] user.email vanmeeuwen\@kolabsys.com`
        $ :command:`git config [--global] branch.autosetuprebase always`
        $ :command:`git config [--global] push.default matching`

**~/.bashrc**

A recommended snippet for `~/.bashrc` to assist you visually:

.. parsed-literal::

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto verbose"

    if [ ! -f "/etc/bash_completion" ]; then
        if [ -f "/etc/bash_completion.d/git" ]; then
            cp /etc/bash_completion.d/git ~/.git-completion.sh
            . ~/.git-completion.sh
            PS1='[\u\@\h \W$(__git_ps1 " (%s)")]\$ '
        elif [ -f "/usr/share/bash-completion/completions/git" ]; then
            cp /usr/share/bash-completion/completions/git ~/.git-completion.sh
            . ~/.git-completion.sh
            PS1='[\u\@\h \W$(__git_ps1 " (%s)")]\$ '
        fi
    else
        PS1='[\u\@\h \W$(__git_ps1 " (%s)")]\$ '
    fi

    if [ -f "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
        source /usr/share/git-core/contrib/completion/git-prompt.sh
    fi

This makes your shell navigating in to a GIT repository appear as follows:

#.  :command:`cd` in to a GIT repository:

    .. parsed-literal::

        [kanarip\@dws06 ~]$ :command:`cd ~/devel/puppet/domains/kolabsys.com`
        [kanarip\@dws06 kolabsys.com (development u=)]$

    This means a clean working copy.

#.  Create an untracked file:

    .. parsed-literal::

        [kanarip\@dws06 kolabsys.com (development u=)]$ :command:`touch something`
        [kanarip\@dws06 kolabsys.com (development % u=)]$

    THe `%` means untracked files exist in the directory hierarchy.

#.  Add the untracked file:

    .. parsed-literal::

        [kanarip\@dws06 kolabsys.com (development % u=)]$ :command:`git add something`
        [kanarip\@dws06 kolabsys.com (development + u=)]$

    The `+` means tracked, uncommitted files exist in the directory hierarchy.

#.  Change a file:

    .. parsed-literal::

        [kanarip\@dws06 kolabsys.com (development + u=)]$ :command:`echo 1 > something`
        [kanarip\@dws06 kolabsys.com (development \*+ u=)]$

    The `*` means uncommitted changes to tracked files exist. The `+` still
    indicates a tracked file is not yet committed.

#.  Checkout another branch. In this example, it is specifically made dirty to
    show off:

    .. parsed-literal::

        [kanarip\@dws06 kolabsys.com (development \*+ u=)]$ :command:`git checkout testing`
        A   something
        Switched to branch 'testing'
        Your branch and 'origin/testing' have diverged,
        and have 4 and 65 different commits each, respectively.
          (use "git pull" to merge the remote branch into yours)
        [kanarip\@dws06 kolabsys.com (testing \*+ u+4-65)]$

    This means we have 4 commits to our local working copy not yet in the
    remote tracked, and 65 commits in the remote tracked not yet in our local
    working copy.

#.  Attempt to rebase on top of the tracked remote:

    .. parsed-literal::

        [kanarip\@dws06 kolabsys.com (testing \*+ u+4-65)]$ :command:`git rebase origin/testing --autostash`
        Created autostash: 49f31f4
        HEAD is now at a6fb106 Ensure docker runs on atomic hosts
        First, rewinding head to replay your work on top of it...
        Applied autostash.
        [kanarip\@dws06 kolabsys.com (testing + u=)]$

    You'll notice the `+` again stands for the tracked, not yet committed file
    :file:`something`.

Pushing Changes
===============

There is virtually no need to push only to the development branch, but merging
and cherry-picking individual changes should be avoided:

.. parsed-literal::

    $ :command:`cd ~/devel/puppet/domains/kolabsys.net`
    (...make some changes...)
    $ :command:`git commit -a -m "Make some changes"`

Attempt a push if you feel so inclined:

.. parsed-literal::

    $ :command:`git push origin development`

This may be refused as a non-fast forward attempt, so fetch the origin first.

.. IMPORTANT::

    Do **NOT** just issue a :command:`git pull` if your prompt shows your
    current local working copy is not clean -- this can still result in a merge
    commit and those will not be allowed when pushing them back.

.. parsed-literal::

    $ :command:`git fetch origin`
    $ :command:`git rebase origin/development --autostash`

Your prompt should now show something like:

.. parsed-literal::

    [kanarip\@dws06 kolabsys.com (development u+1)]$

To push your changes:

.. parsed-literal::

    $ :command:`git push origin development`
    $ :command:`git push origin development:testing`
    $ :command:`git push origin development:production`

Creating a Differential for Review
==================================

A standard repository comes with three branches: development, testing,
production.

Make sure you have **development** checked out, and for the sake of preventing
superfluous merge and rebase exercises, ensure it's in sync with upstream:

.. parsed-literal::

    $ :command:`git checkout development`
    $ :command:`git fetch origin`
    $ :command:`git rebase origin/development --autostash`

Make sure you have a ticket for `Engineering`_ for your work and
`Operations`_ for the final application to production systems.

Given such a ticket, such as :task:`144`, you can branch off the GIT
repository;

.. parsed-literal::

    [kanarip\@dws06 kolabsys.com (development u=)]$ :command:`git checkout -b T144`
    [kanarip\@dws06 kolabsys.com (T144)]$

Make your changes, and commit them in however many commits you think is
reasonable.

Then, create the `Differential`_:

.. parsed-literal::

    [kanarip\@dws06 kolabsys.net (T125 %)]$ arc diff
    You have untracked files in this working copy.

      Working copy: /home/kanarip/devel/puppet/domains/kolabsys.net/

      Untracked changes in working copy:
      (To ignore these changes, add them to ".git/info/exclude".)
        bin/reroute-vpn
        files/haproxy/haproxy.cfg.transparent
        haproxy.patch
        nodes
        puppet/manifests/classes/puppet.pp~HEAD
        puppet/manifests/classes/yum.pp.rej

        Ignore these untracked files and continue? [y/N] :command:`y`

You will now be requested to provide some information about your proposed
changes.

Set the first ``Summary:`` line to ``Resolves T345678``, so that your
differential will be associated with the ticket automatically, and an accepted
differential also closes the ticket you refer to.

.. parsed-literal::

    Linting...
    No lint engine configured for this project.
    Running unit tests...
    No unit test engine is configured for this project.
    Updating commit message...
    Created a new Differential revision:
            Revision URI: https://noc.kolabsys.net/D8

    Included changes:
      M       puppet/manifests/classes/puppet.pp

And that's it.
