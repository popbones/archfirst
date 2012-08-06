{{#account}}
<td class="left">
    <a href="#" class="act_select_account">{{name}}</a>
</td>
<td class="number">
    {{id}}
</td>
<td class="number">
    {{marketValueFormatted}}
</td>
<td class="number">
    {{cashPositionFormatted}}
</td>
<td class="center">
    {{#editPermission}}
    <a href="#" class="act_edit_account">Edit</a>
    {{/editPermission}}
</td>
{{/account}}