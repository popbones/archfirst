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
using Microsoft.Practices.Prism.Logging;
using Microsoft.Practices.Prism.MefExtensions.Modularity;
using Microsoft.Practices.Prism.Modularity;

namespace Bullsfirst.Module.Transfer
{
    [ModuleExport(typeof(TransferModule))]
    public class TransferModule : IModule
    {
        [Import]
        public ILoggerFacade Logger;

        [Import]
        public TransferPopupController _controller;  // Ensures controller creation

        public void Initialize()
        {
            Logger.Log("TransferModule.Initialize()", Category.Debug, Priority.Low);
        }
    }
}