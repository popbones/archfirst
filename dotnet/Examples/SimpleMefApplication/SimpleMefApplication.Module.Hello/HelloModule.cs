using Microsoft.Practices.Prism.MefExtensions.Modularity;
using Microsoft.Practices.Prism.Modularity;

namespace SimpleMefApplication.Module.Hello
{
    [ModuleExport(typeof(HelloModule))]
    public class HelloModule : IModule
    {
        public void Initialize()
        {
        }
    }
}