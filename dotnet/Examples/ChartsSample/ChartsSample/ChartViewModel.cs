/* Copyright 2011 Archfirst
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
using System.Collections.ObjectModel;

namespace ChartsSample
{
    public class ChartViewModel
    {
        public ChartViewModel()
        {
            Positions = new ObservableCollection<Position>();
            Positions.Add(new Position { Symbol = "AAPL", Value = 100000.00M });
            Positions.Add(new Position { Symbol = "CSCO", Value =  50000.00M });
            Positions.Add(new Position { Symbol = "DELL", Value =  90000.00M });
            Positions.Add(new Position { Symbol = "EBAY", Value =  60000.00M });
            Positions.Add(new Position { Symbol = "GOOG", Value = 100000.00M });
            Positions.Add(new Position { Symbol = "HPQ",  Value =  90000.00M });
            Positions.Add(new Position { Symbol = "IBM",  Value =  60000.00M });
            Positions.Add(new Position { Symbol = "INTC", Value =  50000.00M });
            Positions.Add(new Position { Symbol = "MSFT", Value =  70000.00M });
            Positions.Add(new Position { Symbol = "ORCL", Value =  80000.00M });
            Positions.Add(new Position { Symbol = "XRX",  Value = 100000.00M });
        }

        public ObservableCollection<Position> Positions { get; set; }
    }

    public class Position
    {
        public string Symbol { get; set; }
        public decimal Value { get; set; }
    }
}