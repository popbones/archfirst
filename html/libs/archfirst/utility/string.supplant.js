/**
* @see Based on <a href="http://javascript.crockford.com/remedial.html">Remedial JavaScript</a>
* by Douglas Crockford.
*
* @requires: ../utility/string.supplant.js
* @author Douglas Crockford
*/

if (!String.prototype.supplant) {
    String.prototype.supplant = function (o) {
        return this.replace(/{([^{}]*)}/g,
            function (a, b) {
                var r = o[b];
                return typeof r === 'string' || typeof r === 'number' ? r : a;
            }
        );
    };
}