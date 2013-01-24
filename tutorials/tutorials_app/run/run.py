# Licensed to Hortonworks, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Hortonworks, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sys
import os
import string
import subprocess

dirs = os.path.abspath(os.curdir).split(os.path.sep)
app = string.join(dirs[:-2],os.path.sep)
sys.path.append(app)
os.environ['DJANGO_SETTINGS_MODULE'] = "tutorials_app.settings"

from tutorials_app.models import VERSION

def listfolders(folder):
    return [f for f in os.listdir(folder)
              if os.path.isdir(os.path.join(folder,f)) and f[0]!='.']

current_dir = os.path.join(os.path.abspath(os.curdir), 'git_files')

# Check DB version. If new then do syncdb again.
new_version = False
VERSION_FILE = os.path.abspath(os.path.join(os.path.abspath(os.curdir), '../db/db_version.txt'))
if not os.path.exists(VERSION_FILE):
    new_version = True
else:
    try:
        old_version = int(file(VERSION_FILE).read())
        new_version = VERSION > old_version
    except ValueError:
        new_version = True

if new_version:
    RUN = os.path.abspath(os.path.join(os.path.abspath(os.curdir), 'run.sh'))
    subprocess.call(['bash', RUN, "--migrate"], shell=False)
    print>>file(VERSION_FILE, 'w'), VERSION
