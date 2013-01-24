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

class AuthRouter(object):
    """
    Apps auth and sessions works with auth_db
    """
    _apps = ['sessions', 'auth']

    def db_for_read(self, model, **hints):
        if model._meta.app_label in AuthRouter._apps:
            return 'auth_db'
        return None

    def db_for_write(self, model, **hints):
        if model._meta.app_label in AuthRouter._apps:
            return 'auth_db'
        return None

    def allow_relation(self, obj1, obj2, **hints):
        if obj1._meta.app_label in AuthRouter._apps or \
                obj2._meta.app_label in AuthRouter._apps:
            return True
        return None

    def allow_syncdb(self, db, model):
        if (db == 'auth_db') or \
           (model._meta.app_label in AuthRouter._apps):
            return False
        return None
