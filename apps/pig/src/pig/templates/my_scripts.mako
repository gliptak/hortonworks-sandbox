## Licensed to Hortonworks, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Hortonworks, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%def name="my_scripts(pig_scripts)">
<h2>My scripts</h2>
<div style="height: 290px; overflow-y: scroll;">
  <ul class="nav nav-list">
    % for v in pig_scripts:
    <li id="copy" >
      <p>
        <a href="${url('pig.views.delete', v.id)}" onclick="return confirm('Are you sure, you want to delete this script?');">
          <img src="/pig/static/art/delete.gif" alt="Delete"
               title="Delete script" height="12" width="12">
        </a>
        <a href="${url("clone", v.id)}" class="clone" value="${v.id}">
  	<img src="/pig/static/art/clone.png" alt="Clone" title="Clone script" height="14" width="14">
        </a>
        <a href="${url('pig.views.index', obj_id=v.id)}">
	  % if v.title: 
	  ${v.title}
          % else:
          no title
          % endif
        </a>&nbsp;&nbsp;
      </p>
    </li>
    % endfor
  </ul>
</div>
<a class="btn" href="${url('root_pig')}?new=true">New script</a>
</%def>

<%def name="udfs(udfs)">
  % for udf in udfs:
<li>
<a href="${url('udf_del', udf.id)}"  onclick="return confirm('Are you sure, you want to delete this udf?');"><img src="/pig/static/art/delete.gif" alt="Delete" height="12" width="12"></a>
  <a class="udf_register" href="#" value="${udf.file_name}">${udf.file_name}</a>
</li>
% endfor
</%def>
