using System.ComponentModel.Composition.Hosting;
using System.Windows;
using Microsoft.Practices.Prism.MefExtensions;
using Microsoft.Practices.Prism.Regions;
using SimpleMefApplication.Infrastructure;
using SimpleMefApplication.Module.Hello;

namespace SimpleMefApplication
{
    public class SimpleMefApplicationBootstrapper : MefBootstrapper
    {
        protected override void ConfigureAggregateCatalog()
        {
            base.ConfigureAggregateCatalog();
            this.AggregateCatalog.Catalogs.Add(
                new AssemblyCatalog(typeof(ViewExportAttribute).Assembly));
            this.AggregateCatalog.Catalogs.Add(
                new AssemblyCatalog(typeof(SimpleMefApplicationBootstrapper).Assembly));
            this.AggregateCatalog.Catalogs.Add(
                new AssemblyCatalog(typeof(HelloModule).Assembly));
        }

        protected override IRegionBehaviorFactory ConfigureDefaultRegionBehaviors()
        {
            var factory = base.ConfigureDefaultRegionBehaviors();

            // Behavior that registers all views decorated with the ViewExport attribute
            factory.AddIfMissing(
                "AutoPopulateExportedViewsBehavior",
                typeof(AutoPopulateExportedViewsBehavior));

            return factory;
        }

        protected override DependencyObject CreateShell()
        {
            return this.Container.GetExportedValue<Shell>();
        }

        protected override void InitializeShell()
        {
            base.InitializeShell();
            Application.Current.RootVisual = (UIElement)this.Shell;
        }
    }
}