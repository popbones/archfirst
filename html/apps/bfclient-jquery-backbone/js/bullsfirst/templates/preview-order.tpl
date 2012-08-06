<div id="preview_order_dialog_estimate" class="summary">
    <h1>Estimate</h1>
    {{#estimate}}
    <ol>
        <li>
            <label>Last Trade:</label>
            <span>{{lastTradeFormatted}}</span>
        </li>

        <li>
            <label>Estimated Value:</label>
            <span>{{estimatedValueFormatted}}</span>
        </li>

        <li>
            <label>Fees:</label>
            <span>{{feesFormatted}}</span>
        </li>            

        <li>
            <label>Total Including Fees:</label>
            <span>{{estimatedValueInclFeesFormatted}}</span>
        </li>
    </ol>
    {{/estimate}}
</div>

<div class="summary">
    <h1>Order Summary</h1>
    {{#summary}}
    <ol>
        <li>
            <label>Account:</label>
            <span>{{accountName}}</span>
        </li>

        <li>
            <label>Symbol:</label>
            <span>{{symbol}}</span>
        </li>

        <li>
            <label>Action:</label>
            <span>{{side}}</span>
        </li>            

        <li>
            <label>Quantity:</label>
            <span>{{quantity}}</span>
        </li>

        <li>
            <label>Order Type:</label>
            <span>{{type}}</span>
        </li>            

        {{#isLimitOrder}}
        <li>
            <label>Limit Price:</label>
            <span>{{limitPriceFormatted}}</span>
        </li>
        {{/isLimitOrder}}

        <li>
            <label>Term:</label>
            <span>{{term}}</span>
        </li>            

        <li>
            <label>All-or-none:</label>
            <span>{{allOrNone}}</span>
        </li>
    </ol>
    {{/summary}}
</div>