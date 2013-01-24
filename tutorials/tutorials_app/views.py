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

from djangomako.shortcuts import render_to_response
from django.shortcuts import redirect
from django.http import HttpResponse, Http404

from models import UserLocation

import settings

import os
import time
import string
from urlparse import urlparse


def tutorials_last_url(tutorial_view):
    def save_user_location(request, *args):
        if request.user.is_authenticated() \
        and request.user.username != "AnonymousUser":
            user_location = UserLocation.objects.get_or_create(user=request.user)[0]
            user_location.step_location = request.build_absolute_uri()
            user_location.save()
        return tutorial_view(request, *args)
    return save_user_location


def index(request):
    location = settings.CONTENT_FRAME_URL
    step_location = "/lesson/"
    if request.user.is_authenticated() \
        and request.user.username != "AnonymousUser":
        try:
            ustep = UserLocation.objects.get(user=request.user)
            hue_location = ustep.hue_location
            step_location = ustep.step_location
            if step_location == None:
                step_location = "/lesson/"
            if urlparse(hue_location).netloc==urlparse(location).netloc:
                location = hue_location
        except UserLocation.DoesNotExist:
            pass

    return render_to_response("lessons.html",
                    {'content' : location,
                     'step_location': step_location})

def content(request, page):
    if page == '':
        return redirect('/')
    return render_to_response("content.html", {})

def sync_location(request):
    if request.method == 'GET':
        if not request.user.is_authenticated() \
        or request.user.username == 'AnonymousUser':
            return HttpResponse('')

        hue_location = None
        if 'loc' in request.GET:
            hue_location = request.GET['loc']

        ustep = UserLocation.objects.get_or_create(user=request.user)[0]
        ustep.hue_location = hue_location
        ustep.save()

        return HttpResponse('')
    else:
        raise Http404

def get_file(request, path):
    import mimetypes
    from django.core.servers.basehttp import FileWrapper

    git_files = os.path.join(settings.PROJECT_PATH, 'run/git_files')

    rfile = os.path.join(git_files, path)
    response = HttpResponse(FileWrapper(file(rfile, 'rb')),
                            mimetype=mimetypes.guess_type(rfile)[0])

    return response

def network_info(request):
    import subprocess
    commands = [
        "route -n",
        "getent ahosts",
        "ip addr",
        "cat /etc/resolv.conf",
        "cat /etc/hosts",
        "ps aux | grep java",
        "netstat -lnp",
        ]

    netinfo = {cmd: subprocess.check_output(cmd, shell=True)
                for cmd in commands}

    return render_to_response("netinfo.html", {'info': netinfo})