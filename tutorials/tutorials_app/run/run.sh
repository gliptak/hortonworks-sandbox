#!/bin/bash

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
set -e

source /home/sandbox/start_scripts/consts.sh

PYTHON=/home/sandbox/tutorials/.env/bin/python


if [[ "$1" == "--migrate" ]]; then
    echo "Migrating DB..."
    cd $RUN_DIR
    cd "$RUN_DIR/../db"
    rm -f lessons.db
    cd ../../
    ./.env/bin/python manage.py syncdb
    exit 0
fi


cd $RUN_DIR

[ -d $GIT_FILES ] || mkdir -p $GIT_FILES
cd $GIT_FILES
[ ! -d .git ] && git init && git remote add origin $GIT_REPO
echo -n "Pull...  "
git fetch
git checkout $BRANCH
git pull origin $BRANCH # >/dev/null 2>&1
echo "Done"
cd $RUN_DIR

# updating tutorials version
if [[ -f 'git_files/version' ]]; then
cat $GIT_FILES/version > /tmp/tutorials_version.info
fi

[ ! -L $RUN_DIR/git_files ] && ln -s $GIT_FILES $RUN_DIR/git_files

echo -n "Updating DB...  "
$PYTHON run.py &>/dev/null
echo "Done"
