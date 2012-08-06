﻿{{#position}}
<td class="left">
    {{#isInstrumentPosition}}
        {{instrumentName}}
    {{/isInstrumentPosition}}
    {{#isLot}}
        {{lotCreationTimeFormatted}}
    {{/isLot}}
</td>
<td class="center">
    {{instrumentSymbol}}
</td>
<td class="number">
    {{quantity}}
</td>
<td class="number">
    {{lastTradeFormatted}}
</td>
<td class="number">
    {{marketValueFormatted}}
</td>
<td class="number">
    {{pricePaidFormatted}}
</td>
<td class="number">
    {{totalCostFormatted}}
</td>
<td class="number">
    {{gainFormatted}}
</td>
<td class="number">
    {{gainPercentFormatted}}
</td>
<td class="center">
    {{#isTradable}}
    <a href="#" class="pos_trade" data-action="Buy">Buy</a>
    <a href="#" class="pos_trade" data-action="Sell">Sell</a>
    {{/isTradable}}
</td>
{{/position}}