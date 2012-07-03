﻿/**
 * Copyright 2012 Archfirst
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
 * bullsfirst/domain/Position
 *
 * Attributes:
 *   accountId: int
 *   accountName: String
 *   instrumentSymbol: String
 *   instrumentName: String
 *   lotId: int
 *   lotCreationTime: Date
 *   quantity: int
 *   marketValue: Money
 *   lastTrade: Money
 *   pricePaid: Money
 *   totalCost: Money
 *   gain: Money
 *   gainPercent: Decimal (e.g. 0.25 = 25%)
 *   children: [Position]
 *
 * @author Naresh Bhatia
 */
define(function() {
    return Backbone.Model.extend({
    });
});