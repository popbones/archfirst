﻿/* Copyright 2010 Archfirst
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
using System.ComponentModel.Composition;
using Bullsfirst.Module.Positions.Interfaces;
using Microsoft.Practices.Prism.ViewModel;

namespace Bullsfirst.Module.Positions.ViewModels
{
    [Export(typeof(IPositionsViewModel))]
    [PartCreationPolicy(CreationPolicy.NonShared)]
    public class PositionsViewModel : NotificationObject, IPositionsViewModel
    {
        #region Members

        public string ViewTitle
        {
            get { return "Positions"; }
        }

        #endregion
    }
}