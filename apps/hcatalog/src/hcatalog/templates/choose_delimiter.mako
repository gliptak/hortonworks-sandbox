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
<%!
from desktop.views import commonheader, commonfooter
from django.utils.translation import ugettext as _
%>
<%namespace name="layout" file="layout.mako" />
<%namespace name="comps" file="beeswax_components.mako" />
<%namespace name="util" file="util.mako" />
${commonheader(_('HCatalog: Create table from file'), "hcatalog", user, "100px")}
${layout.menubar(section='tables')}

<div class="container-fluid">
    <h1 id="describe-header">${_('Create a new table from a file')}</h1>
    <div id="action-spinner"><h1>Processing the input file...&nbsp;<img src="/static/art/spinner.gif" width="16" height="16"/></h1></div>
    <div class="row-fluid">
        <div class="span3">
            <div class="well sidebar-nav">
                <ul class="nav nav-list">
                    <li class="nav-header">${_('Actions')}</li>
                    <li><a href="${ url('hcatalog.create_table.import_wizard')}">${_('Create a new table from a file')}</a></li>
                    <li><a href="${ url('hcatalog.create_table.create_table')}">${_('Create a new table manually')}</a></li>
                </ul>
            </div>
        </div>
        <div class="span9">
            <ul class="nav nav-pills">
                <li><a id="step1" href="#">${_('Step 1: Choose File')}</a></li>
                <li class="active"><a href="#">${_('Step 2: Choose Delimiter')}</a></li>
                <li><a id="step3" href="#">${_('Step 3: Define Columns')}</a></li>
            </ul>
            <form id="delimiterForm" action="${action}" method="POST" class="form-horizontal">
                <div class="hide">
                    ${util.render_form(file_form)}
                    ${comps.field(delim_form['file_type'])}
                    ${comps.field(delim_form['path_tmp'])}
                </div>
                <fieldset>
                    <div class="alert alert-info"><h3>${_('Choose a Delimiter')}</h3>
                        % if initial:
                            ${_('HCatalog has determined that this file is delimited by')} <strong>${delim_readable}</strong>.
                        % endif
                    </div>
                    <div class="control-group">
                        ${comps.bootstrapLabel(delim_form["delimiter"])}
                        <div class="controls">
                            ${comps.field(delim_form["delimiter"], render_default=True)}
                            <input id="submit_preview" class="btn btn-info" type="submit" value="${_('Preview')}" name="submit_preview"/>
                            <span class="help-block">
                            ${_('Enter the column delimiter. Must be a single character. Use syntax like "\\001" or "\\t" for special characters.')}
                            </span>
                        </div>
                    </div>
                    <div class="control-group">
                        ${comps.bootstrapLabel(delim_form["parse_first_row_as_header"])}
                        <div class="controls">
                            ${comps.field(delim_form["parse_first_row_as_header"], render_default=True)}
                            <span class="help-block">
                        ${_('Check this box if you want to use the first row of data file as a table header. Leave it unchecked if you want the column names to be generated automatically.')}
                        </span>
                        </div>
                    </div>
                    <div class="control-group">
                        ${comps.bootstrapLabel(delim_form["apply_excel_dialect"])}
                        <div class="controls">
                            ${comps.field(delim_form["apply_excel_dialect"], render_default=True)}
                            <span class="help-block">
                        ${_('Check this box if you want to use an \'excel\' dialect on the importing data from the input file. Leave it unchecked if your input file contains the simple csv-formatted data (non double-quoted values, etc).')}
                        </span>
                        </div>
                    </div>                    
                    <div class="control-group">
                        <label class="control-label">${_('Table preview')}</label>
                        <div class="controls">
                            <div class="scrollable">
                                <table class="table table-striped table-condensed">
                                    <thead>
                                    <tr>
                                            % for col_name in col_names:
                                                <th>${col_name}</th>
                                            % endfor
                                    </tr>
                                    </thead>
                                    <tbody>
                                            % for row in fields_list:
                                            <tr>
                                                % for val in row:
                                                    <td>${val}</td>
                                                % endfor
                                            </tr>
                                            % endfor
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </fieldset>

                <div class="form-actions">
                    <input class="btn" type="submit" value="${_('Previous')}" name="cancel_delim"/>
                    <input class="btn primary" id="next-button" type="submit" name="submit_delim" value="${_('Next')}" />
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .scrollable {
        width: 100%;
        overflow-x: auto;
    }
    
    #action-spinner {
		display:none;
	}
</style>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function(){
        $(".scrollable").width($(".form-actions").width());

        $("#id_delimiter_1").css("margin-left","4px").attr("placeholder","${_('Please type your delimiter here')}").hide();
        $("#id_delimiter_0").change(function(){
            if ($(this).val() == "__other__"){
                $("#id_delimiter_1").show();
            }
            else {
                $("#id_delimiter_1").hide();
                $("#id_delimiter_1").val('');
            }
        });

        $("#id_delimiter_0").change();

        $("#step1").click(function(e){
            e.preventDefault();
            $("input[name='cancel_delim']").click();
        });
        $("#step3").click(function(e){
            e.preventDefault();
            $("input[name='submit_delim']").click();
        });
        $("body").keypress(function(e){
            if(e.which == 13){
                e.preventDefault();
                $("input[name='submit_delim']").click();
            }
        });
        $("#next-button").click(function(){
            $('#describe-header').hide();
            $('#action-spinner').show();
            scrollTo(0,0);
        });
    });
</script>

${commonfooter(messages)}
