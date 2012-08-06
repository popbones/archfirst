{{#order}}
<td class="left">
    {{creationTimeFormatted}}
</td>
<td class="left">
    {{accountName}}
</td>
<td class="number">
    {{id}}
</td>
<td class="center">
    {{type}}
</td>
<td class="center">
    {{side}}
</td>
<td class="center">
    {{symbol}}
</td>
<td class="number">
    {{quantity}}
</td>
<td class="number">
    {{limitPriceFormatted}}
</td>
<td class="number">
    {{executionPriceFormatted}}
</td>
<td class="center">
    {{status}}
</td>
<td class="center">
    {{#isActive}}
    <a href="#" class="orders_table_cancel">Cancel</a>
    {{/isActive}}
</td>
{{/order}}