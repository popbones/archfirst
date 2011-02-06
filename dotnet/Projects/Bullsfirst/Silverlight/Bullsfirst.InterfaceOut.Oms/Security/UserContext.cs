/* Copyright 2010 Archfirst
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
using Bullsfirst.InterfaceOut.Oms.SecurityServiceReference;

namespace Bullsfirst.InterfaceOut.Oms.Security
{
    [Export]
    [PartCreationPolicy(CreationPolicy.Shared)]
    public class UserContext
    {
        public User User { get; set; }
        public Credentials Credentials { get; set; }

        public UserContext()
        {
            User = new User();
            Credentials = new Credentials();
        }

        public void InitUser(User other)
        {
            InitUser(other.Username, other.FirstName, other.LastName);
        }

        public void InitUser(string username, string firstName, string lastName)
        {
            User.Username = username;
            User.FirstName = firstName;
            User.LastName = lastName;
        }

        public void InitCredentials(string username, string password)
        {
            Credentials.Username = username;
            Credentials.Password = password;
        }

        public void Reset()
        {
            this.InitUser(new User());
            this.InitCredentials(null, null);
        }
    }
}