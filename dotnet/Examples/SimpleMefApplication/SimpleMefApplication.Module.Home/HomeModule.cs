using System.Diagnostics;
using Microsoft.Practices.Prism.MefExtensions.Modularity;
using Microsoft.Practices.Prism.Modularity;

namespace SimpleMefApplication.Module.Home
{
    [ModuleExport(typeof(HomeModule))]
    public class HomeModule : IModule
    {
        public void Initialize()
        {
            Debug.WriteLine("HomeModule initialized");
        }
    }
}