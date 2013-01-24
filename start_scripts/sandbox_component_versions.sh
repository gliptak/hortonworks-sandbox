#!/bin/sh

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

SANDBOX_VERSIONS_FILE="/tmp/sandbox_component_versions.info"

find /usr -name "pig-*jar" -exec basename {} \; | grep -P "pig-[0-9\-.]*\.jar" | head -n 1 > $SANDBOX_VERSIONS_FILE
find /usr -name "hcatalog-*jar" -exec basename {} \; | grep -P "hcatalog-[0-9\-.]*\.jar" | head -n 1 >> $SANDBOX_VERSIONS_FILE
find /usr -name "hive-cli*jar" -exec basename {} \; | grep -P "hive-cli-[0-9\-.]*\.jar" | head -n 1 >> $SANDBOX_VERSIONS_FILE
echo "sandbox-1.0" >> $SANDBOX_VERSIONS_FILE
echo "tutorials-1.0.001" >> $SANDBOX_VERSIONS_FILE

