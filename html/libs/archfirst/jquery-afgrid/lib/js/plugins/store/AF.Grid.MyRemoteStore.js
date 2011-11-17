/**
 * Copyright 2011 Archfirst
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Manish Shanker
 */

(function ($) {
    AF.Grid.MyRemoteStore = function (options) {

        options = $.extend(true, {
            urls: {
                load: "/dummyData?requestType=load",
                fetchRows: "/dummyData?requestType=fetchRows",
                filterData: "/dummyData?requestType=filterData",
                reOrderColumn: "/dummyData?requestType=reOrderColumn",
                sortData: "/dummyData?requestType=sortData",
                groupData: "/dummyData?requestType=groupData"
            }
        }, options);

        function fetchRows(requestData, onSuccess) {
            $.post(options.urls.fetchRows, requestData, onSuccess);
        }

        function filter(requestData, onSuccess) {
            $.post(options.urls.filterData, requestData, onSuccess);
        }

        function groupBy(requestData, onSuccess) {
            $.post(options.urls.groupData, requestData, onSuccess);
        }

        function sortBy(requestData, onSuccess) {
            $.post(options.urls.sortData, requestData, onSuccess);
        }

        function reorderColumn(requestData, onSuccess) {
            $.post(options.urls.reOrderColumn, requestData, onSuccess);
        }

        function load(requestData, onSuccess) {
            $.post(options.urls.load, requestData, onSuccess);
        }
	
	return {
	    load: load,
	    fetchRows: fetchRows,
	    filter: filter,
	    groupBy: groupBy,
	    sortBy: sortBy,
	    reorderColumn: reorderColumn
	}

    }
}(jQuery));