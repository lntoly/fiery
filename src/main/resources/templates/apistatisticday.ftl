<!DOCTYPE html>
<html>
<head>
    <title>Ragnar分布式调试跟踪系统</title>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <link rel="stylesheet" href="css/bootstrap.min.css"/>
    <link rel="stylesheet" href="css/bootstrap-theme.min.css"/>
    <link rel="stylesheet" href="css/jsoneditor.min.css"/>

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jsoneditor.min.js"></script>
    <script src="js/stupidtable.min.js"></script>
    <style type="text/css">
        .sorttable th[data-sort] {
            cursor: pointer;
        }

        .sorttable tr:nth-of-type(odd) {
            background: #FFFFFF;
        }

        .sorttable tr:nth-of-type(even) {
            background: #d9edf7;
        }
    </style>
</head>
<body>
<#include "common.ftl">
<#include "header.ftl">

<div class="container-fluid" style="min-height: 850px;">
    <div class="row">
        <div class="col-md-12">
            <h3>性能时段分析</h3>
            <h4>url:${url}</h4>
            <form action="?" method="get" class="form-horizontal" id="message">
                <div style="float:right;width: 160px;">
                    <label class="control-label">时间范围:</label>
                    <select name="topdatarange" class="input-sm" id="topdatarange">
                    <#list datelist as dateitem>
                        <option value="${dateitem?index}">${dateitem}</option>
                    </#list>
                    </select>
                    <input type="hidden" name="url" value="${url}"/>
                </div>
            </form>
            <table class="table sorttable table-hover" id="listtable">
                <thead>
                <tr>
                    <!--<th data-sort="string-ins">URL<span aria-hidden="true"> </span></th>-->
                    <th data-sort="int">时间段<span aria-hidden="true"> </span></th>
                    <th data-sort="int">调用次数<span aria-hidden="true"> </span></th>
                    <th data-sort="float">最长响应(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">最短响应(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">200(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">500(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">1000(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">1000+(ms)<span aria-hidden="true"> </span></th>
                    <th data-sort="float">http_code百分比<span aria-hidden="true"> </span></th>
                </tr>
                </thead>
            <#list urllist as key,item>
                <tr>
                    <td>${key}</td>
                    <td>${item.getTotalCount()}</td>
                    <td>${showMSCostTime(item.getLongestTime()*1000)}</td>
                    <td>${showMSCostTime(item.getShortestTime()*1000)}</td>
                    <td>${(item.getMs200Count()/item.getTotalCount())*100}%</td>
                    <td>${(item.getMs500Count()/item.getTotalCount())*100}%</td>
                    <td>${(item.getMs1000Count()/item.getTotalCount())*100}%</td>
                    <td>${(item.getMsLongCount()/item.getTotalCount())*100}%</td>
                    <td><#list item.getCode_count() as code,param>
                    ${code}:${(param/item.totalCount)*100}%<br/>
                    </#list></td>
                </tr>
            </#list>
            </table>
            <hr/>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var $table = $("#listtable").stupidtable();
        var $th_to_sort = $table.find("thead th").eq(0);
        $th_to_sort.stupidsort("asc");

        $table.bind('aftertablesort', function (event, data) {
            // data.column - the ragnarlog of the column sorted after a click
            // data.direction - the sorting direction (either asc or desc)
            // $(this) - this table object
            $("#listtable th span").each(function () {
                $(this).removeClass("glyphicon");
                $(this).removeClass("glyphicon-chevron-up");
                $(this).removeClass("glyphicon-chevron-down");
            });
            $("#listtable th").children().eq(data.column).addClass("glyphicon");
            if (data.direction == "asc") {
                $("#listtable th").children().eq(data.column).addClass("glyphicon-chevron-up");
            } else {
                $("#listtable th").children().eq(data.column).addClass("glyphicon-chevron-down");
            }

        });

        $("#topdatarange").change(function () {
            $("#message").submit();
        });
        $("#topdatarange").val("${datelist_selected}");

    });
</script>
<#include "footer.ftl">
</body>
</html>