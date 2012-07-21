// place any jQuery/helper plugins in here, instead of separate, slower script files.

// Validation check for limit orders in the trade form
function checkLimitOrder(field, rules, i, options) {
    if ($('#tradeForm_orderType').val() === 'Limit' && field.val().length === 0) {
        return 'Please enter a limit price';
    }
}