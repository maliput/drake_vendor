#! /usr/bin/env python3

import argparse
import json
import re
import sys

from datetime import datetime
from datetime import timedelta

from urllib.request import urlopen


def which_drake_tarball(version, distro):
    """Determine drake nightly binaries download URL for a given commit or branch."""
    assert distro in ('bionic', 'xenial')
    if version == 'master':
        return 'https://drake-packages.csail.mit.edu/drake/nightly/drake-latest-{}.tar.gz'.format(
            distro
        )
    if re.match(r'[0-9a-f]{12,}', version) is not None:
        with urlopen('https://api.github.com/repos/RobotLocomotion/drake/commits/' + version) as f:
            data = json.loads(f.read().decode())
            commit_date = data['commit']['committer']['date']
    else:
        with urlopen('https://api.github.com/repos/RobotLocomotion/drake/branches/' + version) as f:
            data = json.loads(f.read().decode())
            commit_date = data['commit']['commit']['committer']['date']
    nightly_datetime = datetime.strptime(
        commit_date.replace('-', '')[:8], '%Y%m%d'
    ) + timedelta(days=1)
    return 'https://drake-packages.csail.mit.edu/drake/nightly/drake-{}-{}.tar.gz'.format(
        nightly_datetime.strftime('%Y%m%d'), distro
    )


def main():
    parser = argparse.ArgumentParser(
        description='Drake nightly tarball downloading tool',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        '-d', '--distro', type=str, choices=['xenial', 'bionic'],
        default='bionic', help='Ubuntu distribution of choice.'
    )
    parser.add_argument(
        'version', type=str,
        help='Drake nightly version, as commit SHA or branch name.'
    )
    args = parser.parse_args()

    print(which_drake_tarball(args.version, args.distro))

    return 0


if __name__ == '__main__':
    try:
        sys.exit(main())
    except Exception as e:
        print(str(e))
        sys.exit(1)
